//
//  SurveyTool.m
//  WomenHealthApp
//
//  Created by Daniel on 15/1/16.
//  Copyright (c) 2015年 WomenHealthApp. All rights reserved.
//

#import "SurveyTool.h"
#import "SurveyModel.h"
@implementation SurveyTool

/**
 *  根据服务器数据 解析出要使用的数据源
 *
 *  @param dic 服务器数据
 *
 *  @return 封装好的数据源数组
 */
+(NSMutableArray *)getDataAryWithDic:(NSDictionary *)dic{
    
    NSMutableArray *tempAry =[NSMutableArray array];
    
    [[dic objectForKey:@"list"] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        
        [tempAry addObject:[SurveyModel getSurverFromDic:obj]];
    }];
    
    return tempAry;
    
    
}


@end
