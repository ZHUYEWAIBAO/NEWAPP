//
//  CommentListModel.h
//  WomenHealthApp
//
//  Created by 朱青 on 14/12/19.
//  Copyright (c) 2014年 WomenHealthApp. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CommentListModel : NSObject

@property (strong, nonatomic) NSString *discuss_id;
@property (strong, nonatomic) NSString *discuss_content;
@property (strong, nonatomic) NSString *discuss_time;
@property (strong, nonatomic) NSString *discuss_user_name;
@property (strong, nonatomic) NSString *discuss_user_id;
@property (strong, nonatomic) NSString *discuss_user_avatar;

@property (strong, nonatomic) NSMutableArray *imageArray;

+ (CommentListModel *)parseDicToLogisticsObject:(NSDictionary*)dataDic;

@end
