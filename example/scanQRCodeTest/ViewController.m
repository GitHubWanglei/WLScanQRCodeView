//
//  ViewController.m
//  scanQRCodeTest
//
//  Created by lihongfeng on 15/12/23.
//  Copyright © 2015年 wanglei. All rights reserved.
//

#import "ViewController.h"
#import "scanViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIButton *btn2 = [UIButton buttonWithType:UIButtonTypeSystem];
    [btn2 setTitle:@"扫描" forState:UIControlStateNormal];
    btn2.frame = CGRectMake(20, 200, 100, 30);
    [btn2 addTarget:self action:@selector(toTempVC) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn2];
    
}

-(void)toTempVC{
    
    scanViewController *vc = [[scanViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
