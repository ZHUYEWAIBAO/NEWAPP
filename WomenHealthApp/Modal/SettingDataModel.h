//
//  SettingDataModel.h
//  YueDongApp
//
//  Created by 朱 青 on 14-8-7.
//  Copyright (c) 2014年 朱 青. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SettingDataModel : NSObject

@property (strong, nonatomic) NSString * settingName;              //设置模块名字
@property (assign, nonatomic) NSInteger settingTag;               //设置模块标识

/**
 *  创建设置页面数据数组
 *
 *  @param number tableview中section个数
 *
 *  @return 设置页面数据数组
 */
+ (NSMutableArray *)arrayForSectionNum:(NSInteger)number;

@end
