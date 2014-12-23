//
//  LogisticsModel.h
//  WomenHealthApp
//
//  Created by 朱青 on 14/12/17.
//  Copyright (c) 2014年 WomenHealthApp. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LogisticsModel : NSObject

@property (strong, nonatomic) NSString * time;
@property (strong, nonatomic) NSString * location;
@property (strong, nonatomic) NSString * context;
@property (strong, nonatomic) NSString * ftime;

+ (LogisticsModel *)parseDicToLogisticsObject:(NSDictionary*)dataDic;

@end
