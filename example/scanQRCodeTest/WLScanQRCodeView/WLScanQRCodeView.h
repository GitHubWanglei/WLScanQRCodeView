//
//  WLScanQRCodeView.h
//
//  Created by wanglei on 15/12/25.
//  Copyright © 2015年 wanglei. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WLScanQRCodeView;
typedef void(^scanResult)(WLScanQRCodeView *view, NSString *result);

@interface WLScanQRCodeView : UIView

//Callback after the instance to commplete scanning QR code
@property (nonatomic, strong) scanResult scanResultHandle;

@property (nonatomic, assign) BOOL isTorchOn;

//Initialization method
+ (instancetype)viewWithFrame:(CGRect)viewFrame scanScope:(CGRect)scope;

//turn torch on or off
- (void)turnTorchOn:(BOOL)on;

//Start scanning
- (void)startRunning;

//Stop scanning
- (void)stopRunning;

@end
