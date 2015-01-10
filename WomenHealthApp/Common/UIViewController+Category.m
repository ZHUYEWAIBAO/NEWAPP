//
//  UIViewController+Category.m
//  WomenHealthApp
//
//  Created by 朱青 on 14/11/27.
//  Copyright (c) 2014年 WomenHealthApp. All rights reserved.
//

#import "UIViewController+Category.h"
#import "AppDelegate.h"

@implementation UIViewController (Category)

- (UITabbarCommonViewController *)tabbarController
{
    

    return [WHSinger share].customTabbr;
    
}

@end
