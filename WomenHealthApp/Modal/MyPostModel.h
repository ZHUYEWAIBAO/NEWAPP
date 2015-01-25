//
//  MyPostModel.h
//  WomenHealthApp
//
//  Created by 朱青 on 15/1/21.
//  Copyright (c) 2015年 WomenHealthApp. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyPostModel : NSObject

@property (strong, nonatomic) NSString *fid;
@property (strong, nonatomic) NSString *fid_name;
@property (strong, nonatomic) NSString *tid;
@property (strong, nonatomic) NSString *subject;
@property (strong, nonatomic) NSString *author;
@property (strong, nonatomic) NSString *lastpost;
@property (strong, nonatomic) NSString *replies;
@property (strong, nonatomic) NSString *thread_pids;

+ (MyPostModel *)parseDicToMyPostObject:(NSDictionary*)dataDic;

@end
