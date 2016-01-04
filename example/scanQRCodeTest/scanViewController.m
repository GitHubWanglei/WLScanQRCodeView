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
    
    CGRect scanView_scope = CGRectMake(self.view.bounds.size.width/2-240/2, self.view.bounds.size.height/2-240/2, 240, 240);
    WLScanQRCodeView *scanView = [WLScanQRCodeView viewWithFrame:self.view.bounds scanScope:scanView_scope];
    [self.view addSubview:scanView];
    [scanView startRunning];
    scanView.scanResultHandle = ^(WLScanQRCodeView *view, NSString *result){
        resultViewController *vc = [[resultViewController alloc] init];
        vc.result = result;
        [self.navigationController pushViewController:vc animated:YES];
    };
    
    self.scanView = scanView;
    
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
