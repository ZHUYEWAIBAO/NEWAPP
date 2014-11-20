//
//  SettingDataModel.m
//  YueDongApp
//
//  Created by 朱 青 on 14-8-7.
//  Copyright (c) 2014年 朱 青. All rights reserved.
//

#import "SettingDataModel.h"

@implementation SettingDataModel

+ (NSMutableArray *)arrayForSectionNum:(NSInteger)number
{
    NSMutableArray *firstArray;
    
    if (number == 2) {
        //已登录情况
        SettingDataModel *firstModel = [[SettingDataModel alloc]init];
        firstModel.settingName = @"我的订单";
        firstModel.settingTag = 100;
        
        SettingDataModel *secondModel = [[SettingDataModel alloc]init];
        secondModel.settingName = @"我的购物车";
        secondModel.settingTag = 101;
        
        SettingDataModel *thirdModel = [[SettingDataModel alloc]init];
        thirdModel.settingName = @"我的圈子";
        thirdModel.settingTag = 103;
        
        firstArray = [NSMutableArray arrayWithObjects:firstModel,secondModel,thirdModel,nil];
    }

    SettingDataModel *sevenModel = [[SettingDataModel alloc]init];
    sevenModel.settingName = @"意见反馈";
    sevenModel.settingTag = 104;
    
    SettingDataModel *sixthModel = [[SettingDataModel alloc]init];
    sixthModel.settingName = @"关于我们";
    sixthModel.settingTag = 105;
    
    SettingDataModel *fifthModel = [[SettingDataModel alloc]init];
    fifthModel.settingName = @"版本更新";
    fifthModel.settingTag = 106;
    
    SettingDataModel *fourthModel = [[SettingDataModel alloc]init];
    fourthModel.settingName = @"清除缓存";
    fourthModel.settingTag = 107;
    
    NSMutableArray *secondArray = [NSMutableArray arrayWithObjects:sevenModel,sixthModel,fifthModel,fourthModel ,nil];
   
    if (number == 2) {
        //已登录情况
        NSMutableArray *bigArray = [NSMutableArray arrayWithObjects:firstArray,secondArray,nil];
        
        return bigArray;
    }
    
    NSMutableArray *array = [NSMutableArray arrayWithObjects:secondArray,nil];
    
    return array;
}

@end
