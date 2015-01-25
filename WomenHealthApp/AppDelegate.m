//
//  AppDelegate.m
//  WomenHealthApp
//
//  Created by 朱 青 on 14-10-23.
//  Copyright (c) 2014年 WomenHealthApp. All rights reserved.
//

#import "AppDelegate.h"
#import "FirstRecordVC.h"
#import "RecordViewController.h"
#import "BBSViewController.h"
#import "ShoppingViewController.h"
#import "SetViewController.h"
#import "UITabbarCommonViewController.h"
#import <ShareSDK/ShareSDK.h>
#import <QZoneConnection/ISSQZoneApp.h>
#import "WXApi.h"
#import "LoginDataModel.h"
#import <TencentOpenAPI/QQApi.h>
#import <TencentOpenAPI/QQApiInterface.h>
#import <TencentOpenAPI/TencentOAuth.h>
#import <AlipaySDK/AlipaySDK.h>

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    [ShareSDK registerApp:@"46ddb4d7bdeb"];
//    [ShareSDK registerApp:@"iosv1101"];
    [self initializePlat];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    
    self.tabCtrl = [[UITabbarCommonViewController alloc]initWithNibName:@"UITabbarCommonViewController" bundle:nil];

    //记录
    UINavigationController *record_vc;
    if ([COMMONDSHARE getTheLocalAddressKey]) {
        record_vc = [RecordViewController navigationControllerContainSelf];
        
        //圈子
        UINavigationController *bbs_vc = [BBSViewController navigationControllerContainSelf];
        //购物
        UINavigationController *shopping_vc = [ShoppingViewController navigationControllerContainSelf];
        //设置
        UINavigationController *set_vc = [SetViewController navigationControllerContainSelf];
        
        NSArray *ctrs = [NSArray arrayWithObjects:record_vc,bbs_vc,shopping_vc,set_vc,nil];
        
        NSArray *imgs = [NSArray  arrayWithObjects:[UIImage imageWithContentFileName:@"new_record_btn.png"],[UIImage imageWithContentFileName:@"new_circle_btn.png"],[UIImage imageWithContentFileName:@"new_buy_btn.png"],[UIImage imageWithContentFileName:@"new_set_btn.png"],nil];
        
        NSArray *sImgs = [NSArray arrayWithObjects:[UIImage imageWithContentFileName:@"new_record_btn_selected.png"],[UIImage imageWithContentFileName:@"new_circle_btn_selected.png"],[UIImage imageWithContentFileName:@"new_buy_btn_selected.png"],[UIImage imageWithContentFileName:@"new_set_btn_selected.png"],nil];
        
        NSArray *tits = [NSArray arrayWithObjects:@"记录",@"圈子",@"购物",@"设置",nil];
        
        self.tabCtrl.viewControllers = ctrs;
        self.tabCtrl.images = imgs;
        self.tabCtrl.selectImages = sImgs;
        self.tabCtrl.titles = tits;
        
        [WHSinger share].customTabbr = self.tabCtrl;
        
        self.window.rootViewController = self.tabCtrl;
        
    }
    else{
        record_vc = [FirstRecordVC navigationControllerContainSelf];
        
        self.window.rootViewController = record_vc;
    }

    LoginDataModel *loginData = GetTheSavedUserPhoneNumAndPassword();
    if (loginData.loginType.length > 0) {
        
        [self loginActionWithUid:loginData];
    }

    [self.window makeKeyAndVisible];
    
    return YES;
}

- (void)loginActionWithUid:(LoginDataModel *)data
{
    //设置请求参数
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    if ([@"3" isEqualToString:data.loginType]) {
        
        [params setObject:CHECK_VALUE(data.loginPassword) forKey:@"password"];
        [params setObject:CHECK_VALUE(data.loginPhoneNum) forKey:@"username"];
    }
    else{
        [params setObject:@"" forKey:@"password"];
        [params setObject:@"Nick" forKey:@"username"];
    }
    
    
    [SVProgressHUD showWithStatus:@"正在登录" maskType:SVProgressHUDMaskTypeClear];
    
    NSString *path = [NSString stringWithFormat:@"/api/ec/user.php?mod=logging&action=login&loginsubmit=yes&handlekey=login&inajax=1&logintype=%@&other_code=%@",data.loginType,data.thirdUid];
    
    [NETWORK_ENGINE requestWithPath:path Params:params CompletionHandler:^(MKNetworkOperation *completedOperation) {
        
        NSDictionary *dic=[completedOperation responseDecodeToDic];
        
        NSDictionary *statusDic = [dic objectForKey:@"status"];
        
        if ([@"1" isEqualToString:CHECK_VALUE([statusDic objectForKey:@"statu"])]) {
            
            USERINFO.isLogin = YES;
            USERINFO.loginType = data.loginType;
            USERINFO.thirdId = data.thirdUid;
          
            //登录
            [USERINFO parseDicToUserInfoModel:[dic objectForKey:@"data"]];
        
            [SVProgressHUD dismiss];
                

        }
        else{
            [SVProgressHUD showErrorWithStatus:CHECK_VALUE([statusDic objectForKey:@"msg"])];
        }
        
    } ErrorHandler:^(MKNetworkOperation *completedOperation, NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"服务器忙，请稍候再试"];
    }];
    
}

- (void)initializePlat
{
    /**
     连接新浪微博开放平台应用以使用相关功能，此应用需要引用SinaWeiboConnection.framework
     http://open.weibo.com上注册新浪微博开放平台应用，并将相关信息填写到以下字段
     **/
    [ShareSDK connectSinaWeiboWithAppKey:@"79554925"
                               appSecret:@"eb24938cb9628fb682622d5e21da979d"
                             redirectUri:@"http://www.thatdays.com/"];

    
    /**
     连接QQ空间应用以使用相关功能，此应用需要引用QZoneConnection.framework
     http://connect.qq.com/intro/login/上申请加入QQ登录，并将相关信息填写到以下字段
     
     如果需要实现SSO，需要导入TencentOpenAPI.framework,并引入QQApiInterface.h和TencentOAuth.h，将QQApiInterface和TencentOAuth的类型传入接口
     **/
    [ShareSDK connectQZoneWithAppKey:@"1103957599"
                           appSecret:@"xt7YrOjfZn8EWMw7"
                   qqApiInterfaceCls:[QQApiInterface class]
                     tencentOAuthCls:[TencentOAuth class]];
    
    //导入QQ互联和QQ好友分享需要的外部库类型，如果不需要QQ空间SSO和QQ好友分享可以不调用此方法
//    [ShareSDK importQQClass:[QQApiInterface class] tencentOAuthCls:[TencentOAuth class]];
    
    /**
     连接QQ应用以使用相关功能，此应用需要引用QQConnection.framework和QQApi.framework库
     http://mobile.qq.com/api/上注册应用，并将相关信息填写到以下字段
     **/
    //旧版中申请的AppId（如：QQxxxxxx类型），可以通过下面方法进行初始化
    //    [ShareSDK connectQQWithAppId:@"QQ075BCD15" qqApiCls:[QQApi class]];
    
//    [ShareSDK connectQQWithQZoneAppKey:@"1103507357"
//                     qqApiInterfaceCls:[QQApiInterface class]
//                       tencentOAuthCls:[TencentOAuth class]];
    
}

/**
 *	@brief	托管模式下的初始化平台
 */
- (void)initializePlatForTrusteeship
{
    
    //导入QQ互联和QQ好友分享需要的外部库类型，如果不需要QQ空间SSO和QQ好友分享可以不调用此方法
    [ShareSDK importQQClass:[QQApiInterface class] tencentOAuthCls:[TencentOAuth class]];

    
}

- (BOOL)application:(UIApplication *)application
      handleOpenURL:(NSURL *)url
{
    return [ShareSDK handleOpenURL:url wxDelegate:self];
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation
{
    //跳转支付宝钱包进行支付，需要将支付宝钱包的支付结果回传给SDK
    if ([url.host isEqualToString:@"safepay"]) {
        [[AlipaySDK defaultService]
         processOrderWithPaymentResult:url
         standbyCallback:^(NSDictionary *resultDic) {
             NSLog(@"result = %@", resultDic);
             
             if (resultDic){
                 if ([@"9000" isEqualToString:[resultDic objectForKey:@"resultStatus"]]){
                     
                     [SVProgressHUD showSuccessWithStatus:@"支付成功"];
                     
                     [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFICATION_ALIPAY object:nil];

                 }
                 else{
                     //交易失败
                     [SVProgressHUD showErrorWithStatus:@"支付失败"];
                 }
             }
             else{
                 //交易失败
                 [SVProgressHUD showErrorWithStatus:@"支付失败"];

             }

         }];
    }
    else{
        
        return [ShareSDK handleOpenURL:url
                     sourceApplication:sourceApplication
                            annotation:annotation
                            wxDelegate:self];
    }
    
    return YES;

}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
