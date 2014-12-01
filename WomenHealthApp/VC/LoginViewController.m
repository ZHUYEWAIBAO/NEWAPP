//
//  LoginViewController.m
//  WomenHealthApp
//
//  Created by 朱青 on 14/11/27.
//  Copyright (c) 2014年 WomenHealthApp. All rights reserved.
//

#import "LoginViewController.h"
#import "RegisterViewController.h"

#define btn_register  100     //注册
#define btn_login     101     //登录
#define btn_forgetPwd 102     //忘记密码
#define btn_qq        103     //qq登录
#define btn_sina      104     //新浪微博登录

@interface LoginViewController ()

@end

@implementation LoginViewController

+ (UINavigationController *)navigationControllerContainSelf
{
    LoginViewController *vc = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:vc];
    return nav;
    
}

- (void)loadView
{
    [super loadView];
    
    self.title = @"登录";
}

- (void)viewDidLoad {
    [super viewDidLoad];
 
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:_forgetBtn];
    self.navigationItem.rightBarButtonItem = leftItem;
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    self.view.backgroundColor = [UIColor whiteColor];
}

#pragma mark 按钮事件
- (IBAction)btnClickAction:(id)sender
{

    UIButton *btn = (UIButton *)sender;
    
    switch (btn.tag) {
        case btn_register:{
            
            RegisterViewController *vc = [[RegisterViewController alloc]initWithNibName:@"RegisterViewController" bundle:nil];
            
            [self.navigationController pushViewController:vc animated:YES];
        }
            
            break;
            
        case btn_login:{
            
            [self loginAction];
        }
            
            break;
            
        case btn_forgetPwd:{

        }
            
            break;

        case btn_qq:{
            
        }
            
            break;
            
        case btn_sina:{
            
        }
            
            break;
            
        default:
            break;
    }
}

- (void)loginAction
{
    if (self.userNumTextField.text.length == 0 ) {
        [SVProgressHUD showErrorWithStatus:@"请输入手机号码"];
        return;
    }
    
    if (self.userPwdTextField.text.length == 0 ) {
        [SVProgressHUD showErrorWithStatus:@"请输入密码"];
        return;
    }

    //设置请求参数
    [self.params removeAllObjects];
    
    [self.params setObject:CHECK_VALUE(self.userPwdTextField.text) forKey:@"password"];
    [self.params setObject:CHECK_VALUE(self.userNumTextField.text) forKey:@"username"];
    
    [SVProgressHUD showWithStatus:@"正在登录" maskType:SVProgressHUDMaskTypeClear];
    
    [NETWORK_ENGINE requestWithPath:[@"/api/dz/member.php?mod=logging&action=login&loginsubmit=yes&handlekey=login&inajax=1&logintype=3&other_code=" stringByAppendingString:@""] Params:self.params CompletionHandler:^(MKNetworkOperation *completedOperation) {
        
        NSDictionary *dic=[completedOperation responseDecodeToDic];
        
        NSDictionary *statusDic = [dic objectForKey:@"status"];
        NSLog(@"yyy %@",dic);
        
        if ([@"1" isEqualToString:CHECK_VALUE([statusDic objectForKey:@"statu"])]) {
            
            USERINFO.isLogin = YES;
            
            //            [USERINFO parseDicToUserInfoModel:dic];
            //
            //            [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFICATION_USER_LOGIN object:@"1"];
            //
            //            [self.navigationController popToRootViewControllerAnimated:YES];
            
            [SVProgressHUD dismiss];
            
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
