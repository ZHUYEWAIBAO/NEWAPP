//
//  PostDetailModel.m
//  WomenHealthApp
//
//  Created by 朱青 on 15/1/14.
//  Copyright (c) 2015年 WomenHealthApp. All rights reserved.
//

#import "PostDetailModel.h"

@implementation PostDetailModel

- (id)init
{
    if (self = [super init]) {
        _listArray = [[NSMutableArray alloc]initWithCapacity:0];
    }
    return self;
}

+ (PostDetailModel *)parseDicToPostDetailObject:(NSDictionary*)dataDic
{
    PostDetailModel *model = [[PostDetailModel alloc]init];
    
    model.fid_name= CHECK_VALUE([dataDic objectForKey:@"fid_name"]);
    model.fid = CHECK_VALUE([dataDic objectForKey:@"fid"]);
    model.digest = CHECK_VALUE([dataDic objectForKey:@"digest"]);
    model.subject = CHECK_VALUE([dataDic objectForKey:@"subject"]);
    model.total_subject = CHECK_VALUE([dataDic objectForKey:@"total_subject"]);
    
    for (NSDictionary *imgDic in CHECK_ARRAY_VALUE([dataDic objectForKey:@"view_threadlist"])) {
        [model.listArray addObject:[PostListModel parseDicToPostListObject:imgDic]];
    }
    
    return model;
}

@end

@implementation PostListModel

+ (PostListModel *)parseDicToPostListObject:(NSDictionary*)dataDic
{
    PostListModel *model = [[PostListModel alloc]init];
    
    model.tid= CHECK_VALUE([dataDic objectForKey:@"tid"]);
    model.fid = CHECK_VALUE([dataDic objectForKey:@"fid"]);
    model.pid = CHECK_VALUE([dataDic objectForKey:@"pid"]);
    model.author = CHECK_VALUE([dataDic objectForKey:@"author"]);
    model.authorid = CHECK_VALUE([dataDic objectForKey:@"authorid"]);
    model.subject = CHECK_VALUE([dataDic objectForKey:@"subject"]);
    model.dateline = CHECK_VALUE([dataDic objectForKey:@"dateline"]);
    model.message = CHECK_VALUE([dataDic objectForKey:@"message"]);
    model.louzhu= CHECK_VALUE([dataDic objectForKey:@"louzhu"]);
    model.position = CHECK_VALUE([dataDic objectForKey:@"position"]);
    model.avatar = CHECK_VALUE([dataDic objectForKey:@"avatar"]);
    model.imgInfosArray = CHECK_ARRAY_VALUE([dataDic objectForKey:@"img_infos"]);
 
    return model;
}

@end
