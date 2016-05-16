//
//  WLScanQRCodeView.m
//
//  Created by wanglei on 15/12/25.
//  Copyright © 2015年 wanglei. All rights reserved.
//

#import "WLScanQRCodeView.h"

@interface WLScanQRCodeView ()<AVCaptureMetadataOutputObjectsDelegate>

@property (nonatomic, strong) AVCaptureSession *captureSession;
@property (nonatomic, assign) CGRect scope;//扫描区域
@property (nonatomic, strong) UIImageView *scanLine;//扫描线
@property (nonatomic, strong) UIImageView *scanBackgroundImg;//扫描区域边框背景

@end

@implementation WLScanQRCodeView

//Initialization method
+(instancetype)viewWithFrame:(CGRect)viewFrame scanScope:(CGRect)scope{
    return [[WLScanQRCodeView alloc] initWithFrame:viewFrame scanScrope:scope];
}

- (instancetype)initWithFrame:(CGRect)frame scanScrope:(CGRect)scope
{
    self = [super initWithFrame:frame];
    if (self) {
        self.scope = scope;
        [self initView];
    }
    return self;
}

-(void)initView{
    
    //权限判断
    AVAuthorizationStatus authorizationStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (authorizationStatus == AVAuthorizationStatusRestricted || authorizationStatus == AVAuthorizationStatusDenied) {
        return;
    }
    
    //获取捕捉设备(摄像头)
    AVCaptureDevice *captureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    if ([captureDevice hasFlash] && [captureDevice hasTorch]) {
        [captureDevice lockForConfiguration:nil];
        [captureDevice setFlashMode:AVCaptureFlashModeAuto];
        [captureDevice setTorchMode:AVCaptureTorchModeAuto];
        [captureDevice unlockForConfiguration];
    }
    self.isTorchOn = NO;
    
    //创建输入流
    NSError *createInpuError;
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:captureDevice error:&createInpuError];
    if (createInpuError) {
#ifdef DEBUG
        NSLog(@"Failure to create AVCaptureDeviceInput instance, error: %@", createInpuError.localizedDescription);
#endif
        [self removeFromSuperview];
        return;
    }
    
    //创建输出流
    __block AVCaptureMetadataOutput *output = [[AVCaptureMetadataOutput alloc] init];
    [output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];//设置代理
    
    //创建 session
    AVCaptureSession *session = [[AVCaptureSession alloc] init];
    [session addInput:input];
    [session addOutput:output];
    NSMutableArray *array = [NSMutableArray array];
    if ([output.availableMetadataObjectTypes containsObject:AVMetadataObjectTypeQRCode]) {
        [array addObject:AVMetadataObjectTypeQRCode];
    }
    if ([output.availableMetadataObjectTypes containsObject:AVMetadataObjectTypeEAN13Code]) {
        [array addObject:AVMetadataObjectTypeEAN13Code];
    }
    if ([output.availableMetadataObjectTypes containsObject:AVMetadataObjectTypeEAN8Code]) {
        [array addObject:AVMetadataObjectTypeEAN8Code];
    }
    if ([output.availableMetadataObjectTypes containsObject:AVMetadataObjectTypeCode128Code]) {
        [array addObject:AVMetadataObjectTypeCode128Code];
    }
    output.metadataObjectTypes = array;//设置扫码支持的编码格式
    self.captureSession = session;
    
    //创建视频画面显示层
    AVCaptureVideoPreviewLayer *previewLayer = [AVCaptureVideoPreviewLayer layerWithSession:self.captureSession];
    previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    previewLayer.frame = self.bounds;
    [self.layer insertSublayer:previewLayer above:0];
    
    //设置有效扫描区域
    CGFloat sizeExpansion = 20;
    CGRect tempScope = CGRectMake(_scope.origin.x - sizeExpansion,
                                  _scope.origin.y - sizeExpansion,
                                  _scope.size.width + sizeExpansion * 2,
                                  _scope.size.height + sizeExpansion * 2);
    [[NSNotificationCenter defaultCenter] addObserverForName:AVCaptureInputPortFormatDescriptionDidChangeNotification object:nil queue:[NSOperationQueue currentQueue] usingBlock:^(NSNotification * _Nonnull note) {
        output.rectOfInterest = [previewLayer metadataOutputRectOfInterestForRect:tempScope];
    }];
    
    //添加扫描背景图片
    UIImageView *scanBackgroundImg = [[UIImageView alloc] initWithFrame:self.scope];
    scanBackgroundImg.image = [UIImage imageNamed:@"scanBackgroundImg"];
    self.scanBackgroundImg = scanBackgroundImg;
    [self addSubview:self.scanBackgroundImg];
    
    //添加遮罩层
    [self addMaskViewExceptScanScope];
    
    //扫描动画
    [self scanLineAnimation];
    
}

//添加遮罩层视图(扫描区域除外)
-(void)addMaskViewExceptScanScope{
    
    CGFloat scanScope_X = CGRectGetMinX(self.scope);
    CGFloat scanScope_Y = CGRectGetMinY(self.scope);
    CGFloat scanScope_H = CGRectGetHeight(self.scope);
    
    CGRect topView_frame = CGRectMake(0, 0, self.bounds.size.width, scanScope_Y);
    CGRect leftView_frame = CGRectMake(0, scanScope_Y, scanScope_X, scanScope_H);
    CGRect rightView_frame = CGRectMake(CGRectGetMaxX(self.scope), scanScope_Y, self.bounds.size.width-CGRectGetMaxX(self.scope), scanScope_H);
    CGRect bottomView_frame = CGRectMake(0, CGRectGetMaxY(self.scope), self.bounds.size.width, self.bounds.size.height-CGRectGetMaxY(self.scope));
    
    [self createMaskViewWithFrame:topView_frame];
    [self createMaskViewWithFrame:leftView_frame];
    [self createMaskViewWithFrame:rightView_frame];
    [self createMaskViewWithFrame:bottomView_frame];
    
}

-(void)createMaskViewWithFrame:(CGRect)frame{
    UIView *maskView = [[UIView alloc] initWithFrame:frame];
    maskView.backgroundColor = [UIColor blackColor];
    maskView.alpha = 0.5;
    [self addSubview:maskView];
}

//扫描线动画
-(void)scanLineAnimation{
    
    CGFloat scanLine_X = CGRectGetMinX(self.scope);
    CGFloat scanLine_Y = CGRectGetMinY(self.scope);
    CGFloat scanLine_W = CGRectGetWidth(self.scope);
    CGFloat scanLine_H = CGRectGetHeight(self.scope);
    
    CGRect startFrame = CGRectMake(scanLine_X, scanLine_Y, scanLine_W, 2);
    CGRect endFrame = CGRectMake(scanLine_X, scanLine_Y+scanLine_H-2, scanLine_W, 2);
    
    if (!self.scanLine) {
        UIImageView *scanLine = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"scanLine"]];
        scanLine.frame = startFrame;
        self.scanLine = scanLine;
        [self addSubview:self.scanLine];
    }else{
        self.scanLine.frame = startFrame;
    }
    
    __block __weak typeof (self) weak_self = self;
    [UIView animateWithDuration:2 animations:^{
        self.scanLine.frame = endFrame;
    } completion:^(BOOL finished) {
        [weak_self scanLineAnimation];
    }];
    
}

//Start scanning
-(void)startRunning{
    if (!self.captureSession.isRunning) {
        [self.captureSession startRunning];
    }
}

//Stop scanning
-(void)stopRunning{
    if (self.captureSession.isRunning) {
        [self.captureSession stopRunning];
    }
}

#pragma mark - AVCaptureMetadataOutputObjectsDelegate
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection{
    [self stopRunning];
    if (metadataObjects.count > 0) {
        AVMetadataMachineReadableCodeObject *object = metadataObjects.firstObject;
        if (self.scanResultHandle) {
            self.scanResultHandle(self, object.stringValue);
        }
    }
}

- (void)turnTorchOn:(BOOL)on{
    Class captureDeviceClass = NSClassFromString(@"AVCaptureDevice");
    if (captureDeviceClass != nil) {
        AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
        if ([device hasTorch] && [device hasFlash]){
            [device lockForConfiguration:nil];
            if (on) {
                [device setTorchMode:AVCaptureTorchModeOn];
                [device setFlashMode:AVCaptureFlashModeOn];
                self.isTorchOn = YES;
            } else {
                [device setTorchMode:AVCaptureTorchModeOff];
                [device setFlashMode:AVCaptureFlashModeOff];
                self.isTorchOn = NO;
            }
            [device unlockForConfiguration];
        }
    }
}

- (BOOL)ishaveAuthorization{
    AVAuthorizationStatus authorizationStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (authorizationStatus == AVAuthorizationStatusRestricted || authorizationStatus == AVAuthorizationStatusDenied) {
        return NO;
    }else{
        return YES;
    }
}

@end














