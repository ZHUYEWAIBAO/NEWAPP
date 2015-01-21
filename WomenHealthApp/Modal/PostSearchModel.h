//
//  PostSearchModel.h
//  WomenHealthApp
//
//  Created by 朱青 on 15/1/12.
//  Copyright (c) 2015年 WomenHealthApp. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PostSearchModel : NSObject

@property (strong, nonatomic) NSString *tid;
@property (strong, nonatomic) NSString *fid;
@property (strong, nonatomic) NSString *author;
@property (strong, nonatomic) NSString *authorid;
@property (strong, nonatomic) NSString *subject;
@property (strong, nonatomic) NSString *dateline;
@property (strong, nonatomic) NSString *message;

+ (PostSearchModel *)parseDicToPostSearchObject:(NSDictionary*)dataDic;

@end
