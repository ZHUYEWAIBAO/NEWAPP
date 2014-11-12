//
//  AppDelegate.m
//  WomenHealthApp
//
//  Created by 朱 青 on 14-10-23.
//  Copyright (c) 2014年 WomenHealthApp. All rights reserved.
//

#import "AppDelegate.h"
#import "RecordViewController.h"
#import "BBSViewController.h"
#import "ShoppingViewController.h"
#import "SetViewController.h"
#import "UITabbarCommonViewController.h"
/**
 *  ceshi
 */
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    
    UITabbarCommonViewController *tabCtrl = [[UITabbarCommonViewController alloc]initWithNibName:@"UITabbarCommonViewController" bundle:nil];

    //记录
    UINavigationController *record_vc = [RecordViewController navigationControllerContainSelf];
    //圈子
    UINavigationController *bbs_vc = [BBSViewController navigationControllerContainSelf];
    //购物
    UINavigationController *shopping_vc = [ShoppingViewController navigationControllerContainSelf];
    //设置
    UINavigationController *set_vc = [SetViewController navigationControllerContainSelf];
    
    NSArray *ctrs = [NSArray arrayWithObjects:record_vc,bbs_vc,shopping_vc,set_vc,nil];
    
    NSArray *imgs = [NSArray  arrayWithObjects:[UIImage imageWithContentFileName:@"record_btn.png"],[UIImage imageWithContentFileName:@"circle_btn.png"],[UIImage imageWithContentFileName:@"buy_btn.png"],[UIImage imageWithContentFileName:@"set_btn.png"],nil];
    
    NSArray *sImgs = [NSArray arrayWithObjects:[UIImage imageWithContentFileName:@"record_btn_selected.png"],[UIImage imageWithContentFileName:@"circle_btn_selected.png"],[UIImage imageWithContentFileName:@"buy_btn_selected.png"],[UIImage imageWithContentFileName:@"set_btn_selected.png"],nil];
    
    
    NSArray *tits = [NSArray arrayWithObjects:@"记录",@"圈子",@"购物",@"设置",nil];
    
    tabCtrl.viewControllers = ctrs;
    tabCtrl.images = imgs;
    tabCtrl.selectImages = sImgs;
    tabCtrl.titles = tits;

    self.window.rootViewController = tabCtrl;
    
    [self.window makeKeyAndVisible];
    
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
