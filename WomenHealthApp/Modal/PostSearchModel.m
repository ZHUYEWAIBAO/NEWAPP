//
//  PostSearchModel.m
//  WomenHealthApp
//
//  Created by 朱青 on 15/1/12.
//  Copyright (c) 2015年 WomenHealthApp. All rights reserved.
//

#import "PostSearchModel.h"

@implementation PostSearchModel

+ (PostSearchModel *)parseDicToPostSearchObject:(NSDictionary*)dataDic
{
    PostSearchModel *model = [[PostSearchModel alloc]init];
    
    model.tid= CHECK_VALUE([dataDic objectForKey:@"tid"]);
    model.fid = CHECK_VALUE([dataDic objectForKey:@"fid"]);
    model.author = CHECK_VALUE([dataDic objectForKey:@"author"]);
    model.authorid = CHECK_VALUE([dataDic objectForKey:@"authorid"]);
    model.subject = CHECK_VALUE([dataDic objectForKey:@"subject"]);
    model.dateline = CHECK_VALUE([dataDic objectForKey:@"dateline"]);
    model.message = CHECK_VALUE([dataDic objectForKey:@"message"]);
    
    return model;
}

@end
