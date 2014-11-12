//
//  UINavigationBar+customBar.m
//  cuntomNavigationBar
//
//  Created by Edward on 13-4-22.
//  Copyright (c) 2013年 Edward. All rights reserved.
//

#import "UINavigationBar+customBar.h"

@implementation UINavigationBar (customBar)
- (void)customNavigationBar:(UIViewController *)controller {

    //设置导航条背景图片
    //[self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithContentFileName:@"head_bg.png"] forBarMetrics:UIBarMetricsDefault];
    if ([self respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)]) {
//        NSString *classStr = NSStringFromClass([controller class]);

            if (IOS7) {

                [self setBackgroundImage:[UIImage imageWithContentFileName:@"top_bg.png"] forBarMetrics:UIBarMetricsDefault];

            }
            else{

                [self setBackgroundImage:[UIImage imageWithContentFileName:@"top_bg.png"] forBarMetrics:UIBarMetricsDefault];
            }
        
        
    } else {
//        [self drawRect:self.bounds controller:controller];
    }

}


@end
