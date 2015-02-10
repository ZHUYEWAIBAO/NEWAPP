//
//  AboutUsVC.m
//  WomenHealthApp
//
//  Created by 朱青 on 14/11/26.
//  Copyright (c) 2014年 WomenHealthApp. All rights reserved.
//

#import "AboutUsVC.h"
#import "TotalInfoModel.h"

@interface AboutUsVC ()

@property (strong, nonatomic) TotalInfoModel *totalModel;

@end

@implementation AboutUsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"关于我们";
    
    _totalModel = GetTheAppTotalInfoModel();
    self.phoneLabel.text = [NSString stringWithFormat:@"电话：%@",_totalModel.service_phone];
    
    if (self.phoneLabel.text.length > 0) {
        UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(phoneCallAction)];
        //设置成NO表示当前控件响应后会传播到其他控件上，默认为YES。
        tapGestureRecognizer.cancelsTouchesInView = NO;
        //将触摸事件添加到当前view
        [self.phoneLabel addGestureRecognizer:tapGestureRecognizer];
    }

    self.versionLabel.text = [NSString stringWithFormat:@"V%@",CLIENT_VERSION];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)phoneCallAction
{
    [self callTheSystemTelephone:_totalModel.service_phone];

}

//拨打系统电话
- (void)callTheSystemTelephone:(NSString *)telNum
{
    NSString *deviceType = [UIDevice currentDevice].model;
    if([deviceType  isEqualToString:@"iPod touch"]||[deviceType  isEqualToString:@"iPad"]||[deviceType  isEqualToString:@"iPhone Simulator"]){
        [SVProgressHUD showErrorWithStatus:@"您的设备不能拨打电话"];
  
    }
    else{
     
        NSString *str = [NSString stringWithFormat:@"您确定要打电话给%@吗",telNum];
        UIAlertView *infoAlert = [[UIAlertView alloc] initWithTitle:@"提示" message:str delegate:self cancelButtonTitle:@"否" otherButtonTitles:@"是",nil];
        
        [infoAlert show];
        
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{

    if (buttonIndex == 1) {
        NSString *callStr = [NSString stringWithFormat:@"tel://%@",_totalModel.service_phone];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:callStr]];
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
