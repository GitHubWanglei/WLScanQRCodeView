# WLScanQRCodeView
二维码扫描控件

示例代码:

    //****************************** 添加扫描组件 *************************************

    //初始化
    CGRect scanView_scope = CGRectMake(self.view.bounds.size.width/2-240/2, self.view.bounds.size.height/2-240/2, 240, 240);
    WLScanQRCodeView *scanView = [WLScanQRCodeView viewWithFrame:self.view.bounds scanScope:scanView_scope];
    [self.view addSubview:scanView];
    //判断访问相机权限
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
    //打开关闭闪光灯按钮
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(20, self.view.bounds.size.height-50, 30, 30)];
    [btn setBackgroundImage:[UIImage imageNamed:@"torch.png"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(turnTorchOn:) forControlEvents:UIControlEventTouchUpInside];
    [scanView addSubview:btn];

    //****************************** 添加扫描组件 *************************************
    self.scanView = scanView;

效果图:

![image](https://raw.githubusercontent.com/GitHubWanglei/WLScanQRCodeView/master/image.png)
