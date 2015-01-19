//
//  PostDetailModel.h
//  WomenHealthApp
//
//  Created by 朱青 on 15/1/14.
//  Copyright (c) 2015年 WomenHealthApp. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PostDetailModel : NSObject

@property (strong, nonatomic) NSString *fid_name;
@property (strong, nonatomic) NSString *fid;
@property (strong, nonatomic) NSString *digest;
@property (strong, nonatomic) NSString *subject;
@property (strong, nonatomic) NSString *total_subject;
@property (strong, nonatomic) NSMutableArray *listArray;

+ (PostDetailModel *)parseDicToPostDetailObject:(NSDictionary*)dataDic;

@end

@interface PostListModel : NSObject

@property (strong, nonatomic) NSString *tid;
@property (strong, nonatomic) NSString *fid;
@property (strong, nonatomic) NSString *pid;
@property (strong, nonatomic) NSString *author;
@property (strong, nonatomic) NSString *authorid;
@property (strong, nonatomic) NSString *subject;
@property (strong, nonatomic) NSString *dateline;
@property (strong, nonatomic) NSString *message;
@property (strong, nonatomic) NSString *louzhu;
@property (strong, nonatomic) NSString *position;
@property (strong, nonatomic) NSString *avatar;

@property (strong, nonatomic) NSArray *imgInfosArray;

+ (PostListModel *)parseDicToPostListObject:(NSDictionary*)dataDic;

@end