//
//  PasswordSetVC.m
//  YueDongApp
//
//  Created by 朱 青 on 14-8-5.
//  Copyright (c) 2014年 朱 青. All rights reserved.
//

#import "PasswordSetVC.h"
#import "LoginViewController.h"
#import "LoginDataModel.h"

@interface PasswordSetVC ()

@end

@implementation PasswordSetVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)loadView
{
    [super loadView];
    
    self.title = @"注册";
    
//    self.textFieldNum = 1;
    self.passwordTextField.tag = 1;
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setViewLayer:self.textBgImageView andCornerRadius:3 andBorderColor:[UIColor lightGrayColor] andBorderWidth:0.6f];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    self.view.backgroundColor = [UIColor whiteColor];
}

- (IBAction)btnClickAction:(id)sender
{
    [self.passwordTextField resignFirstResponder];
    [self checkPasswordAndGetTheRegisterDone];
}

- (void)checkPasswordAndGetTheRegisterDone
{
    if (self.passwordTextField.text.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"请输入密码"];
        return;
    }

    //设置请求参数
    [self.params removeAllObjects];
    
    [self.params setObject:CHECK_VALUE(self.passwordTextField.text) forKey:@"password"];
    [self.params setObject:CHECK_VALUE(self.passwordTextField.text) forKey:@"password2"];
    [self.params setObject:CHECK_VALUE(self.vertifiCode) forKey:@"code"];
    [self.params setObject:CHECK_VALUE(self.registerModel.registerPhoneNum) forKey:@"username"];
    
    [SVProgressHUD showWithStatus:@"正在登录" maskType:SVProgressHUDMaskTypeClear];
    
    [NETWORK_ENGINE requestWithPath:@"/api/ec/user.php?mod=register&inajax=1" Params:self.params CompletionHandler:^(MKNetworkOperation *completedOperation) {
        
        NSDictionary *dic=[completedOperation responseDecodeToDic];

        NSDictionary *statusDic = [dic objectForKey:@"status"];
        
        if ([@"1" isEqualToString:CHECK_VALUE([statusDic objectForKey:@"statu"])]){

            [SVProgressHUD dismiss];
            
            self.registerModel.registerPassword = self.passwordTextField.text;
            
            USERINFO.isLogin = YES;
            
            [USERINFO parseDicToUserInfoModel:[dic objectForKey:@"data"]];
            
            LoginDataModel *model = [LoginDataModel rememberLoginPhoneNum:self.registerModel.registerPhoneNum andPassword:self.registerModel.registerPassword andThirdUid:@"" andLoginType:USERINFO.loginType remember:YES];
            
            SaveTheUserPhoneNumAndPassword(model);
            
            [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFICATION_USER_LOGIN object:nil];
            
            [self dismissViewControllerAnimated:YES completion:nil];
            
        }
        else{
            [SVProgressHUD showErrorWithStatus:CHECK_VALUE([statusDic objectForKey:@"msg"])];
        }
        
    } ErrorHandler:^(MKNetworkOperation *completedOperation, NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"服务器忙，请稍候再试"];
    }];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
