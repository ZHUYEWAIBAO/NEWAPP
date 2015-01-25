//
//  MyPostModel.m
//  WomenHealthApp
//
//  Created by 朱青 on 15/1/21.
//  Copyright (c) 2015年 WomenHealthApp. All rights reserved.
//

#import "MyPostModel.h"

@implementation MyPostModel

+ (MyPostModel *)parseDicToMyPostObject:(NSDictionary*)dataDic
{
    MyPostModel *model = [[MyPostModel alloc]init];
    
    model.fid = CHECK_VALUE([dataDic objectForKey:@"fid"]);
    model.tid = CHECK_VALUE([dataDic objectForKey:@"tid"]);
    model.fid_name = CHECK_VALUE([dataDic objectForKey:@"fid_name"]);
    model.author = CHECK_VALUE([dataDic objectForKey:@"author"]);
    model.subject = CHECK_VALUE([dataDic objectForKey:@"subject"]);
    model.lastpost = CHECK_VALUE([dataDic objectForKey:@"lastpost"]);
    model.replies = CHECK_VALUE([dataDic objectForKey:@"replies"]);
    model.thread_pids = CHECK_VALUE([dataDic objectForKey:@"thread_pids"]);

    return model;
}

@end
