//
//  LoginViewController.m
//  WomenHealthApp
//
//  Created by 朱青 on 14/11/27.
//  Copyright (c) 2014年 WomenHealthApp. All rights reserved.
//

#import "LoginViewController.h"
#import "RegisterViewController.h"
#import <ShareSDK/ShareSDK.h>

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
    
    //为了释放定时器，自定义返回按钮
    UIButton *leftButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 46, 25)];
    [leftButton addTarget:self action:@selector(leftBackClick:) forControlEvents:UIControlEventTouchUpInside];
    [leftButton setImage:[UIImage imageWithContentFileName:@"back_bt.png"] forState:UIControlStateNormal];
    UIBarButtonItem *leftButtonItem = [[UIBarButtonItem alloc]initWithCustomView:leftButton];
    self.navigationItem.leftBarButtonItem = leftButtonItem;
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)leftBackClick:(id)sender
{

    [self dismissViewControllerAnimated:YES completion:nil];
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
            
            self.loginType = loginType_mobile;
            [self loginActionWithUid:@""];
        }
            
            break;
            
        case btn_forgetPwd:{

        }
            
            break;
        default:
            break;
    }
}

- (IBAction)thirdClickAction:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    
    id<ISSAuthOptions> authOptions = [ShareSDK authOptionsWithAutoAuth:YES
                                                         allowCallback:YES
                                                         authViewStyle:SSAuthViewStyleFullScreenPopup
                                                          viewDelegate:nil
                                               authManagerViewDelegate:nil];
    
    if (btn.tag == btn_sina) {
        
        [ShareSDK getUserInfoWithType:ShareTypeSinaWeibo
                          authOptions:authOptions
                               result:^(BOOL result, id<ISSPlatformUser> userInfo, id<ICMErrorInfo> error) {
                                   
                                   if (result){
    
                                       [self fillSinaWeiboUser:userInfo];
                                       
                                       
                                   }
                                   
                               }];

    }
    else{
        [ShareSDK getUserInfoWithType:ShareTypeQQSpace
                          authOptions:authOptions
                               result:^(BOOL result, id<ISSPlatformUser> userInfo, id<ICMErrorInfo> error) {
                                   
                                   if (result){
                                    
                                       [self fillQQSpaceUser:userInfo];
                                       
                                       
                                   }
                                   
                               }];
    }
}

- (void)fillSinaWeiboUser:(id<ISSPlatformUser>)userInfo
{
    self.loginType = loginType_sina;
    
    USERINFO.user_icon = [userInfo profileImage];
    USERINFO.username = [userInfo nickname];
    
    NSLog(@"%@------%@",[userInfo uid],[userInfo nickname]);
    
    [self loginActionWithUid:[userInfo uid]];

}

- (void)fillQQSpaceUser:(id<ISSPlatformUser>)userInfo
{
    self.loginType = loginType_qq;

    USERINFO.user_icon = [userInfo profileImage];
    USERINFO.username = [userInfo nickname];
    
    NSLog(@"%@------%@",[userInfo uid],[userInfo nickname]);
    
    [self loginActionWithUid:[userInfo uid]];

}

- (void)loginActionWithUid:(NSString *)uid
{
    //设置请求参数
    [self.params removeAllObjects];
    
    if (self.loginType == loginType_mobile) {
        if (self.userNumTextField.text.length == 0 ) {
            [SVProgressHUD showErrorWithStatus:@"请输入手机号码"];
            return;
        }
        
        if (self.userPwdTextField.text.length == 0 ) {
            [SVProgressHUD showErrorWithStatus:@"请输入密码"];
            return;
        }
        
        [self.params setObject:CHECK_VALUE(self.userPwdTextField.text) forKey:@"password"];
        [self.params setObject:CHECK_VALUE(self.userNumTextField.text) forKey:@"username"];
    }
    else{
        [self.params setObject:@"" forKey:@"password"];
        [self.params setObject:@"Nick" forKey:@"username"];
    }

    
    [SVProgressHUD showWithStatus:@"正在登录" maskType:SVProgressHUDMaskTypeClear];
    
    NSString *path = [NSString stringWithFormat:@"/api/ec/user.php?mod=logging&action=login&loginsubmit=yes&handlekey=login&inajax=1&logintype=%u&other_code=%@",self.loginType,uid];
    
    [NETWORK_ENGINE requestWithPath:path Params:self.params CompletionHandler:^(MKNetworkOperation *completedOperation) {
        
        NSDictionary *dic=[completedOperation responseDecodeToDic];
        
        NSDictionary *statusDic = [dic objectForKey:@"status"];

        if ([@"1" isEqualToString:CHECK_VALUE([statusDic objectForKey:@"statu"])]) {
            
            USERINFO.isLogin = YES;
            
            [USERINFO parseDicToUserInfoModel:statusDic];

            [self dismissViewControllerAnimated:YES completion:nil];
            
            [SVProgressHUD dismiss];
            
        }
        else{
            [SVProgressHUD showErrorWithStatus:CHECK_VALUE([statusDic objectForKey:@"msg"])];
        }
        
    } ErrorHandler:^(MKNetworkOperation *completedOperation, NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"服务器忙，请稍候再试"];
    }];
    
}

- (IBAction)forgetPwdAction:(id)sender
{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
