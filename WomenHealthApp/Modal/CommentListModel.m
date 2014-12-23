//
//  CommentListModel.m
//  WomenHealthApp
//
//  Created by 朱青 on 14/12/19.
//  Copyright (c) 2014年 WomenHealthApp. All rights reserved.
//

#import "CommentListModel.h"

@implementation CommentListModel

- (id)init
{
    if (self = [super init]) {
        _imageArray = [[NSMutableArray alloc]initWithCapacity:0];
    }
    return self;
}

+ (CommentListModel *)parseDicToLogisticsObject:(NSDictionary*)dataDic
{
    CommentListModel *model = [[CommentListModel alloc]init];
    
    model.discuss_id= CHECK_VALUE([dataDic objectForKey:@"discuss_id"]);
    model.discuss_content = CHECK_VALUE([dataDic objectForKey:@"discuss_content"]);
    model.discuss_time = CHECK_VALUE([dataDic objectForKey:@"discuss_time"]);
    model.discuss_user_name = CHECK_VALUE([dataDic objectForKey:@"discuss_user_name"]);
    model.discuss_user_id = CHECK_VALUE([dataDic objectForKey:@"discuss_user_id"]);
    model.discuss_user_avatar = CHECK_VALUE([dataDic objectForKey:@"discuss_user_avatar"]);
    
    for (NSDictionary *imgDic in CHECK_ARRAY_VALUE([dataDic objectForKey:@"discuss_imgs"])) {
        [model.imageArray addObject:CHECK_VALUE([imgDic objectForKey:@"img_path"])];
    }
    
    return model;
}

@end
