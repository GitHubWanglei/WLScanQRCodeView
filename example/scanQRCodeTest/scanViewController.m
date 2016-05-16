//
//  scanViewController.m
//  scanQRCodeTest
//
//  Created by lihongfeng on 15/12/23.
//  Copyright © 2015年 wanglei. All rights reserved.
//

#import "scanViewController.h"
#import "WLScanQRCodeView.h"
#import "resultViewController.h"

@interface scanViewController ()

@property (nonatomic, strong) WLScanQRCodeView *scanView;

@end

@implementation scanViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    //****************************** 添加扫描组件 *************************************
    
    //初始化
    CGRect scanView_scope = CGRectMake(self.view.bounds.size.width/2-240/2, self.view.bounds.size.height/2-240/2, 240, 240);
    WLScanQRCodeView *scanView = [WLScanQRCodeView viewWithFrame:self.view.bounds scanScope:scanView_scope];
    [self.view addSubview:scanView];
    
    if (![scanView ishaveAuthorization]) {
        NSLog(@"无权限");
    }
    
    //开启扫描
    [scanView startRunning];
    //回调
    scanView.scanResultHandle = ^(WLScanQRCodeView *view, NSString *result){
        resultViewController *vc = [[resultViewController alloc] init];
        vc.result = result;
        [self.navigationController pushViewController:vc animated:YES];
    };
    //打开关闭闪光灯
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(20, self.view.bounds.size.height-50, 30, 30)];
    [btn setBackgroundImage:[UIImage imageNamed:@"torch.png"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(turnTorchOn:) forControlEvents:UIControlEventTouchUpInside];
    [scanView addSubview:btn];
    
    //****************************** 添加扫描组件 *************************************
    self.scanView = scanView;
    
}

-(void)turnTorchOn:(UIButton *)btn{
    if (self.scanView.isTorchOn) {
        [self.scanView turnTorchOn:NO];
    }else{
        [self.scanView turnTorchOn:YES];
    }
    
}

//-(void)viewWillAppear:(BOOL)animated{
//    [self.scanView startRunning];
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
