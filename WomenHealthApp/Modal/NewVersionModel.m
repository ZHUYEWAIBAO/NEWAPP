//
//  NewVersionModel.m
//  YueDongApp
//
//  Created by 朱 青 on 14-8-21.
//  Copyright (c) 2014年 朱 青. All rights reserved.
//

#import "NewVersionModel.h"

@implementation NewVersionModel

+ (NewVersionModel *)parseDicToNewVersionModel:(NSDictionary*)dic
{
    NewVersionModel *model = [[NewVersionModel alloc]init];
    
    model.version = CHECK_VALUE([dic objectForKey:@"version"]);
    model.link = CHECK_VALUE([dic objectForKey:@"link"]);
    model.content = CHECK_VALUE([dic objectForKey:@"content"]);

    return model;
}

@end
