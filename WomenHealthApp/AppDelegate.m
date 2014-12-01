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
#import <TencentOpenAPI/QQApi.h>
#import <TencentOpenAPI/QQApiInterface.h>
#import <TencentOpenAPI/TencentOAuth.h>

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
//    [ShareSDK registerApp:@"46ddb4d7bdeb"];
    [ShareSDK registerApp:@"iosv1101"];
    [self initializePlat];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    
    self.tabCtrl = [[UITabbarCommonViewController alloc]initWithNibName:@"UITabbarCommonViewController" bundle:nil];

    //记录
    UINavigationController *record_vc;
    if ([COMMONDSHARE getTheLocalAddressKey]) {
        record_vc = [RecordViewController navigationControllerContainSelf];
    }
    else{
        record_vc = [FirstRecordVC navigationControllerContainSelf];
    }
    
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
    
    [self.window makeKeyAndVisible];
    
    return YES;
}

- (void)initializePlat
{
    /**
     连接新浪微博开放平台应用以使用相关功能，此应用需要引用SinaWeiboConnection.framework
     http://open.weibo.com上注册新浪微博开放平台应用，并将相关信息填写到以下字段
     **/
    [ShareSDK connectSinaWeiboWithAppKey:@"568898243"
                               appSecret:@"38a4f8204cc784f81f9f0daaf31e02e3"
                             redirectUri:@"http://www.sharesdk.cn"];

    
    /**
     连接QQ空间应用以使用相关功能，此应用需要引用QZoneConnection.framework
     http://connect.qq.com/intro/login/上申请加入QQ登录，并将相关信息填写到以下字段
     
     如果需要实现SSO，需要导入TencentOpenAPI.framework,并引入QQApiInterface.h和TencentOAuth.h，将QQApiInterface和TencentOAuth的类型传入接口
     **/
    [ShareSDK connectQZoneWithAppKey:@"100371282"
                           appSecret:@"aed9b0303e3ed1e27bae87c33761161d"
                   qqApiInterfaceCls:[QQApiInterface class]
                     tencentOAuthCls:[TencentOAuth class]];
    
    /**
     连接微信应用以使用相关功能，此应用需要引用WeChatConnection.framework和微信官方SDK
     http://open.weixin.qq.com上注册应用，并将相关信息填写以下字段
     **/
    //    [ShareSDK connectWeChatWithAppId:@"wx4868b35061f87885" wechatCls:[WXApi class]];
    [ShareSDK connectWeChatWithAppId:@"wx4868b35061f87885"
                           appSecret:@"64020361b8ec4c99936c0e3999a9f249"
                           wechatCls:[WXApi class]];
    
    /**
     连接QQ应用以使用相关功能，此应用需要引用QQConnection.framework和QQApi.framework库
     http://mobile.qq.com/api/上注册应用，并将相关信息填写到以下字段
     **/
    //旧版中申请的AppId（如：QQxxxxxx类型），可以通过下面方法进行初始化
    //    [ShareSDK connectQQWithAppId:@"QQ075BCD15" qqApiCls:[QQApi class]];
    
    [ShareSDK connectQQWithQZoneAppKey:@"100371282"
                     qqApiInterfaceCls:[QQApiInterface class]
                       tencentOAuthCls:[TencentOAuth class]];
    
}
//
///**
// *	@brief	托管模式下的初始化平台
// */
//- (void)initializePlatForTrusteeship
//{
//    
//    //导入QQ互联和QQ好友分享需要的外部库类型，如果不需要QQ空间SSO和QQ好友分享可以不调用此方法
//    [ShareSDK importQQClass:[QQApiInterface class] tencentOAuthCls:[TencentOAuth class]];
//
//    //导入微信需要的外部库类型，如果不需要微信分享可以不调用此方法
//    [ShareSDK importWeChatClass:[WXApi class]];
//    
//}

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
    return [ShareSDK handleOpenURL:url
                 sourceApplication:sourceApplication
                        annotation:annotation
                        wxDelegate:self];
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
