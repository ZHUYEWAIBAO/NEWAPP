//
//  AdModal.m
//  WomenHealthApp
//
//  Created by 朱青 on 14/12/1.
//  Copyright (c) 2014年 WomenHealthApp. All rights reserved.
//

#import "AdModal.h"

@implementation AdModal

+ (AdModal *)parseDicToADObject:(NSDictionary *)dic
{
    AdModal *model = [[AdModal alloc]init];
    
    model.adSrc = CHECK_VALUE([dic objectForKey:@"src"]);
    model.adText = CHECK_VALUE([dic objectForKey:@"text"]);
    model.adType = CHECK_VALUE([dic objectForKey:@"type"]);
    model.adUrl = CHECK_VALUE([dic objectForKey:@"url"]);

    return model;
}

@end
