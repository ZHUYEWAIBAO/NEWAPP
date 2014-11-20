//
//  BBSMenuModal.h
//  WomenHealthApp
//
//  Created by 朱 青 on 14-11-20.
//  Copyright (c) 2014年 WomenHealthApp. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BBSMenuModal : NSObject

@property (strong, nonatomic) NSString *bbsFid;
@property (strong, nonatomic) NSString *bbsName;
@property (strong, nonatomic) NSString *bbsDescription;
@property (strong, nonatomic) NSString *bbsIcon;

+ (BBSMenuModal *)parseDicToMenuListObject:(NSDictionary*)dic;

@end
