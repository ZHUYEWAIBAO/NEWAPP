//
//  ForgetPwdCodeVC.m
//  WomenHealthApp
//
//  Created by 朱青 on 14/12/10.
//  Copyright (c) 2014年 WomenHealthApp. All rights reserved.
//

#import "ForgetPwdCodeVC.h"
#import "ForgetPwdSetVC.h"

@interface ForgetPwdCodeVC ()

@end

@implementation ForgetPwdCodeVC

- (void)loadView
{
    [super loadView];
    
    self.title = @"忘记密码";

}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setViewLayer:self.textBgImageView andCornerRadius:3 andBorderColor:[UIColor lightGrayColor] andBorderWidth:0.6f];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    self.view.backgroundColor = [UIColor whiteColor];
}

//验证手机号码
- (void)checkPhoneNumberAndGetVericationCode
{
    if (self.phoneNumTextField.text.length == 0) {
        
        [SVProgressHUD showErrorWithStatus:@"手机号码不能为空"];
        
        return;
    }

    [self getVerificationCodeAction];
    
}

//获取验证码
- (void)getVerificationCodeAction
{
    [SVProgressHUD showWithStatus:@"正在获取验证码" maskType:SVProgressHUDMaskTypeClear];
    
    [NETWORK_ENGINE requestWithPath:[GLOBALSHARE.CIRCLE_BIGMENU_PATH stringByAppendingFormat:@"?mod=code&phone=%@&type=get_password",self.phoneNumTextField.text] Params:self.params CompletionHandler:^(MKNetworkOperation *completedOperation) {
        
        NSDictionary *dic=[completedOperation responseDecodeToDic];
        
        NSDictionary *statusDic = [dic objectForKey:@"status"];
        
        if ([@"1" isEqualToString:CHECK_VALUE([statusDic objectForKey:@"statu"])]){
            
            [SVProgressHUD showSuccessWithStatus:CHECK_VALUE([statusDic objectForKey:@"msg"])];
 
            ForgetPwdSetVC *vc = [[ForgetPwdSetVC alloc]initWithNibName:@"ForgetPwdSetVC" bundle:nil];
            vc.phoneNum = self.phoneNumTextField.text;
            [self.navigationController pushViewController:vc animated:YES];
            
        }
        else{
            [SVProgressHUD showErrorWithStatus:CHECK_VALUE([statusDic objectForKey:@"msg"])];
        }
        
    } ErrorHandler:^(MKNetworkOperation *completedOperation, NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"服务器忙，请稍候再试"];
    }];
}

- (IBAction)btnClickAction:(id)sender
{

    [self.phoneNumTextField resignFirstResponder];
    [self checkPhoneNumberAndGetVericationCode];

    
}

#pragma mark --UITextFiled的观察者方法
-(void)textFiledEditChanged:(NSNotification *)obj
{
    UITextField *textField = (UITextField *)obj.object;
    
    if (textField == self.phoneNumTextField) {
        
        if ([self.phoneNumTextField.text isValidatePhoneNum]) {
            [self.getVerCodeBtn setEnabled:YES];
        }
        else{
            [self.getVerCodeBtn setEnabled:NO];
        }
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
