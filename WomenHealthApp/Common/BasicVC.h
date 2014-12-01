//
//  BasicVC.h
//  YueDongApp
//
//  Created by 朱 青 on 14-7-28.
//  Copyright (c) 2014年 朱 青. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BasicVC : UIViewController


/**
*  返回一个包含自己的UINavigationController
*
*  @return UINavigationController
*/
+ (UINavigationController *)navigationControllerContainSelf;

@property (nonatomic,strong) NSMutableDictionary* params; //请求参数



/**
 *  给一个view附上边框颜色和圆角处理
 *
 *  @param view   待操作的view
 *  @param radius 边框圆角的角度
 *  @param color  边框颜色
 *  @param width  边框宽度
 */
-(void)setViewLayer:(UIView *)view andCornerRadius:(float)radius andBorderColor:(UIColor *)color andBorderWidth:(float)width;

/**
 *  弹出登录视图
 */
-(void)presentLoginVCAction;

@end
