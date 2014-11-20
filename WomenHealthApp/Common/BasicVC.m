//
//  BasicVC.m
//  YueDongApp
//
//  Created by 朱 青 on 14-7-28.
//  Copyright (c) 2014年 朱 青. All rights reserved.
//

#import "BasicVC.h"
#import "UITabbarCommonViewController.h"

@interface BasicVC ()

@end

@implementation BasicVC

+ (UINavigationController*)navigationControllerContainSelf
{
    return  nil;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        self.params=[NSMutableDictionary dictionaryWithCapacity:5];
        
        //UITextFiled输入监听
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textFiledEditChanged:) name:UITextFieldTextDidChangeNotification
                                                  object:nil];
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (IOS7){
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.extendedLayoutIncludesOpaqueBars = NO;
        self.modalPresentationCapturesStatusBarAppearance = NO;
    }

    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    //自定义导航
    [self.navigationController.navigationBar customNavigationBar:self];
    
    if (IOS7) {

        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
    }

    self.navigationController.navigationBar.titleTextAttributes = [NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:UITextAttributeTextColor];
    
    //返回按钮
    [self setTheBackItemButton];
//    [self setTabBarHiddenAction];
    self.view.backgroundColor =[UIColor colorWithRed:243/255.0f green:240/255.0f blue:234/255.0f alpha:1];
}


-(void)setTabBarHiddenAction
{
    BasicVC *control=(BasicVC *)[self.navigationController.viewControllers firstObject];
    if (![control isKindOfClass:[BasicVC class]]) {
        return;
    }
    
    if (control == self) {
        [UITabbarCommonViewController setTabbarViewShow];
    }else{
        [UITabbarCommonViewController setTabbarViewHidden];
    }
}
#pragma mark -
#pragma mark 定义返回按钮
/**
 *   @pragma返回按钮
 */
- (void)setTheBackItemButton
{
    UIImage* backImg;
    //自定义返回按钮
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        backImg=[[UIImage imageWithContentFileName:@"nav_back_bt.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 0)resizingMode:UIImageResizingModeStretch];
        //        UIButton *bt=[UIButton buttonWithType:UIButtonTypeCustom];
        //        [bt setBackgroundImage:backImg forState:UIControlStateNormal];
        //        bt.frame=CGRectMake(0, 0, 25, 25);
        UIBarButtonItem* backItem=[[UIBarButtonItem alloc] initWithTitle:@" " style:UIBarButtonItemStylePlain target:self action:nil];
        
        [backItem setBackButtonBackgroundImage:backImg forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
        //        UIBarButtonItem *backItem=[[UIBarButtonItem alloc]initWithCustomView:bt];
        self.navigationItem.backBarButtonItem = backItem;
    }else{
        backImg=[[UIImage imageWithContentFileName:@"back_bt.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 15, 0, 0)resizingMode:UIImageResizingModeStretch];
        UIBarButtonItem* backItem=[[UIBarButtonItem alloc] initWithTitle:@" " style:UIBarButtonItemStylePlain target:self action:nil];
        
        [backItem setBackButtonBackgroundImage:backImg forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
        backItem.enabled=YES;
        self.navigationItem.backBarButtonItem = backItem;
    }
}

-(void)setViewLayer:(UIView *)view andCornerRadius:(float)radius andBorderColor:(UIColor *)color andBorderWidth:(float)width
{
    [[view layer] setBorderWidth:width];
    [[view layer] setCornerRadius:radius];
    [[view layer] setBorderColor:color.CGColor];
}

#pragma mark --UITextFiled的观察者方法
-(void)textFiledEditChanged:(NSNotification *)obj
{
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
