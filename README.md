# WLScanQRCodeView
二维码扫描控件

示例代码:
    //****************************** 添加扫描控件 *************************************
    
    CGRect scanView_scope = CGRectMake(self.view.bounds.size.width/2-240/2, self.view.bounds.size.height/2-240/2, 240, 240);
    WLScanQRCodeView *scanView = [WLScanQRCodeView viewWithFrame:self.view.bounds scanScope:scanView_scope];
    [self.view addSubview:scanView];
    [scanView startRunning];
    scanView.scanResultHandle = ^(WLScanQRCodeView *view, NSString *result){
        resultViewController *vc = [[resultViewController alloc] init];
        vc.result = result;
        [self.navigationController pushViewController:vc animated:YES];
    };
    
    //****************************** 添加扫描控件 *************************************
