//
//  ForgetPwdSetVC.m
//  WomenHealthApp
//
//  Created by 朱青 on 14/12/10.
//  Copyright (c) 2014年 WomenHealthApp. All rights reserved.
//

#import "ForgetPwdSetVC.h"
#import "LoginDataModel.h"

@interface ForgetPwdSetVC ()

@end

@implementation ForgetPwdSetVC

- (void)loadView
{
    [super loadView];
    
    self.title = @"忘记密码";
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setViewLayer:self.pwdView andCornerRadius:4 andBorderColor:[UIColor lightGrayColor] andBorderWidth:0.6f];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    self.view.backgroundColor = [UIColor whiteColor];
}

- (IBAction)btnClickAction:(id)sender
{
    [self.codeTextField resignFirstResponder];
    [self.firstPwdField resignFirstResponder];
    [self.secondPwdField resignFirstResponder];
    
    [self checkPasswordAndGetTheRegisterDone];
}

- (void)checkPasswordAndGetTheRegisterDone
{
    if (self.codeTextField.text.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"请输入验证码"];
        return;
    }
    if (self.firstPwdField.text.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"请输入密码"];
        return;
    }
    if (self.secondPwdField.text.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"请再次输入密码"];
        return;
    }
    
    //设置请求参数
    [self.params removeAllObjects];
    
    [self.params setObject:CHECK_VALUE(self.firstPwdField.text) forKey:@"password"];
    [self.params setObject:CHECK_VALUE(self.secondPwdField.text) forKey:@"password2"];
    [self.params setObject:CHECK_VALUE(self.codeTextField.text) forKey:@"code"];

    [SVProgressHUD showWithStatus:@"正在登录" maskType:SVProgressHUDMaskTypeClear];
    
    [NETWORK_ENGINE requestWithPath:[NSString stringWithFormat:@"/api/ec/user.php?mod=reset_password&phone=%@",self.phoneNum] Params:self.params CompletionHandler:^(MKNetworkOperation *completedOperation) {
        
        NSDictionary *dic=[completedOperation responseDecodeToDic];
        
        NSDictionary *statusDic = [dic objectForKey:@"status"];
        
        if ([@"1" isEqualToString:CHECK_VALUE([statusDic objectForKey:@"statu"])]){
            
            [SVProgressHUD showSuccessWithStatus:@"设置成功"];

            LoginDataModel *loginData = GetTheSavedUserPhoneNumAndPassword();
            //替换记住的密码
            loginData.loginPassword = self.firstPwdField.text;
            SaveTheUserPhoneNumAndPassword(loginData);
            
            [self.navigationController popToRootViewControllerAnimated:YES];
            
        }
        else{
            [SVProgressHUD showErrorWithStatus:CHECK_VALUE([statusDic objectForKey:@"msg"])];
        }
        
    } ErrorHandler:^(MKNetworkOperation *completedOperation, NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"服务器忙，请稍候再试"];
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
