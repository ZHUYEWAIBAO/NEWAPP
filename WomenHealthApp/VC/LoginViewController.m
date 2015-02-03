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
#import "ForgetPwdCodeVC.h"
#import "LoginDataModel.h"

#define btn_register  100     //注册
#define btn_login     101     //登录
#define btn_forgetPwd 102     //忘记密码
#define btn_qq        103     //qq登录
#define btn_sina      104     //新浪微博登录

@interface LoginViewController ()
{
    NSString *thirdImageStr;
}

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

    USERINFO.username = [userInfo nickname];
    
    NSArray *keys = [[userInfo sourceData] allKeys];
    for (int i = 0; i < [keys count]; i++){
        
        NSString *keyName = [keys objectAtIndex:i];
        id value = [[userInfo sourceData] objectForKey:keyName];
        if (![value isKindOfClass:[NSString class]]){
            
            if ([value respondsToSelector:@selector(stringValue)]){
                value = [value stringValue];
            }
            else{
                value = @"";
            }
        }
        if([keyName isEqualToString:@"avatar_large"]){
            
            thirdImageStr = value;
            
            break;
        }

    }
    
    [self loginActionWithUid:[userInfo uid]];

}

- (void)fillQQSpaceUser:(id<ISSPlatformUser>)userInfo
{
    self.loginType = loginType_qq;

    thirdImageStr = [userInfo profileImage];
    USERINFO.username = [userInfo nickname];
    
    NSLog(@"%@------%@",[userInfo uid],[userInfo nickname]);
    
    [self loginActionWithUid:[userInfo uid]];
    
    

}

- (void)downloadImage:(NSString *)url
{
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    NSError *error;
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:&error];
    
    if(data){
  
        [self upLoaduserPhoto:data];

    }
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
    
    //百度推送uid
    if (USERINFO.baiduUid.length > 0) {
        [self.params setObject:USERINFO.baiduUid forKey:@"pushid"];
    }
    else{
        [self.params setObject:@"" forKey:@"pushid"];
    }

    //系统版本
    [self.params setObject:@"ios" forKey:@"pushos"];
    
    [SVProgressHUD showWithStatus:@"正在登录" maskType:SVProgressHUDMaskTypeClear];
    
    NSString *path = [NSString stringWithFormat:@"/api/ec/user.php?mod=logging&action=login&loginsubmit=yes&handlekey=login&inajax=1&logintype=%u&other_code=%@",self.loginType,uid];
    
    [NETWORK_ENGINE requestWithPath:path Params:self.params CompletionHandler:^(MKNetworkOperation *completedOperation) {
        
        NSDictionary *dic=[completedOperation responseDecodeToDic];
        
        NSDictionary *statusDic = [dic objectForKey:@"status"];
        NSDictionary *dataDic = [dic objectForKey:@"data"];

        if ([@"1" isEqualToString:CHECK_VALUE([statusDic objectForKey:@"statu"])]) {
            
            USERINFO.isLogin = YES;
            USERINFO.loginType = [NSString stringWithFormat:@"%d",self.loginType];
            USERINFO.thirdId = uid;

            if ([@"1" isEqualToString:CHECK_VALUE([dataDic objectForKey:@"is_login"])]) {
                //登录
                [USERINFO parseDicToUserInfoModel:dataDic];
                
                LoginDataModel *model = [LoginDataModel rememberLoginPhoneNum:self.userNumTextField.text andPassword:self.userPwdTextField.text andThirdUid:uid andLoginType:USERINFO.loginType remember:YES];
                
                SaveTheUserPhoneNumAndPassword(model);
                
                [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFICATION_USER_LOGIN object:nil];
                
                [self dismissViewControllerAnimated:YES completion:nil];
                
                [SVProgressHUD dismiss];
                
            }
            else{
                //注册
                USERINFO.uid = CHECK_VALUE([dataDic objectForKey:@"uid"]);
                
                LoginDataModel *model = [LoginDataModel rememberLoginPhoneNum:@"" andPassword:@"" andThirdUid:uid andLoginType:USERINFO.loginType remember:YES];
                
                SaveTheUserPhoneNumAndPassword(model);
                
                [self downloadImage:thirdImageStr];
                
                [self upLoadTheUseName];
            }
            

        }
        else{
            [SVProgressHUD showErrorWithStatus:CHECK_VALUE([statusDic objectForKey:@"msg"])];
        }
        
    } ErrorHandler:^(MKNetworkOperation *completedOperation, NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"服务器忙，请稍候再试"];
    }];
    
}

//上传用户名
- (void)upLoadTheUseName
{

    [self.params removeAllObjects];
    [self.params setObject:CHECK_VALUE(USERINFO.username) forKey:@"username"];
    
    NSString *path = [NSString stringWithFormat:@"/dz/uc_server/index.php?m=user&uid=%@&a=updateusername",USERINFO.uid];
    
    [NETWORK_ENGINE requestWithPath:path Params:self.params CompletionHandler:^(MKNetworkOperation *completedOperation) {
        
//        NSDictionary *dic=[completedOperation responseDecodeToDic];
 
    } ErrorHandler:^(MKNetworkOperation *completedOperation, NSError *error) {

    }];
    
}

//上传头像
- (void)upLoaduserPhoto:(NSData *)imgData
{
    [self.params removeAllObjects];
   
    NSString *path = [NSString stringWithFormat:@"/dz/uc_server/index.php?m=user&uid=%@&a=uploadavatarapi",USERINFO.uid];
    
    [NETWORK_ENGINE requestWithPath:path Params:self.params imageData:imgData keyString:@"Filedata" CompletionHandler:^(MKNetworkOperation *completedOperation) {
        
        NSDictionary *dic=[completedOperation responseDecodeToDic];
        
        NSDictionary *statusDic = [dic objectForKey:@"status"];
        
        if ([@"1" isEqualToString:CHECK_VALUE([statusDic objectForKey:@"statu"])]) {
 
            NSDictionary *dataDic = [dic objectForKey:@"data"];
            NSArray *array = [dataDic objectForKey:@"list"];
            
            USERINFO.user_icon = [array objectAtIndex:0];
  
            [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFICATION_USER_LOGIN object:nil];
            
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
    ForgetPwdCodeVC *vc = [[ForgetPwdCodeVC alloc]initWithNibName:@"ForgetPwdCodeVC" bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
