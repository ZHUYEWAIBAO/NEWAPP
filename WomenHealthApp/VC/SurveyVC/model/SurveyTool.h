//
//  SurveyTool.h
//  WomenHealthApp
//
//  Created by Daniel on 15/1/16.
//  Copyright (c) 2015年 WomenHealthApp. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SurveyTool : NSObject


/**
 *  根据服务器数据 解析出要使用的数据源
 *
 *  @param dic 服务器数据
 *
 *  @return 封装好的数据源数组
 */
+(NSMutableArray *)getDataAryWithDic:(NSDictionary *)dic;


@end
