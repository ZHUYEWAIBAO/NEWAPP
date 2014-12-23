//
//  LogisticsModel.m
//  WomenHealthApp
//
//  Created by 朱青 on 14/12/17.
//  Copyright (c) 2014年 WomenHealthApp. All rights reserved.
//

#import "LogisticsModel.h"

@implementation LogisticsModel

+ (LogisticsModel *)parseDicToLogisticsObject:(NSDictionary*)dataDic
{
    LogisticsModel *model = [[LogisticsModel alloc]init];
    
    model.time = CHECK_VALUE([dataDic objectForKey:@"time"]);
    model.location = CHECK_VALUE([dataDic objectForKey:@"location"]);
    model.context = CHECK_VALUE([dataDic objectForKey:@"context"]);
    model.ftime = CHECK_VALUE([dataDic objectForKey:@"ftime"]);
    
    return model;
}

@end
