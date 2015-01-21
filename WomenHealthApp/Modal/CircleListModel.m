//
//  CircleListModel.m
//  WomenHealthApp
//
//  Created by 朱青 on 15/1/9.
//  Copyright (c) 2015年 WomenHealthApp. All rights reserved.
//

#import "CircleListModel.h"

@implementation CircleHeadModel

- (id)init
{
    if (self = [super init]) {
        _headArray = [[NSMutableArray alloc]initWithCapacity:0];
    }
    return self;
}

+ (CircleHeadModel *)parseDicToCircleHeadObject:(NSDictionary*)dataDic
{
    CircleHeadModel *model = [[CircleHeadModel alloc]init];
    
    model.total_subject= CHECK_VALUE([dataDic objectForKey:@"total_subject"]);
    model.circle_description = CHECK_VALUE([dataDic objectForKey:@"description"]);
    model.name = CHECK_VALUE([dataDic objectForKey:@"name"]);
    model.today_subject = CHECK_VALUE([dataDic objectForKey:@"today_subject"]);
    model.icon = CHECK_VALUE([dataDic objectForKey:@"icon"]);
    
    for (NSDictionary *imgDic in CHECK_ARRAY_VALUE([dataDic objectForKey:@"forum_threadlist"])) {
        [model.headArray addObject:[CircleListModel parseDicToCircleListObject:imgDic]];
    }
    
    return model;
}

@end

@implementation CircleListModel

+ (CircleListModel *)parseDicToCircleListObject:(NSDictionary*)dataDic
{
    CircleListModel *model = [[CircleListModel alloc]init];
    
    model.fid= CHECK_VALUE([dataDic objectForKey:@"fid"]);
    model.tid = CHECK_VALUE([dataDic objectForKey:@"tid"]);
    model.subject = CHECK_VALUE([dataDic objectForKey:@"subject"]);
    model.author = CHECK_VALUE([dataDic objectForKey:@"author"]);
    model.lastpost = CHECK_VALUE([dataDic objectForKey:@"lastpost"]);
    model.dblastpost = CHECK_VALUE([dataDic objectForKey:@"dblastpost"]);
    model.views = CHECK_VALUE([dataDic objectForKey:@"views"]);
    model.replies = CHECK_VALUE([dataDic objectForKey:@"replies"]);
    model.digest = CHECK_VALUE([dataDic objectForKey:@"digest"]);
 
    return model;
}

@end
