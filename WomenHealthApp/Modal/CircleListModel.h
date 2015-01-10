//
//  CircleListModel.h
//  WomenHealthApp
//
//  Created by 朱青 on 15/1/9.
//  Copyright (c) 2015年 WomenHealthApp. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CircleListModel : NSObject

@property (strong, nonatomic) NSString *fid;
@property (strong, nonatomic) NSString *tid;
@property (strong, nonatomic) NSString *subject;
@property (strong, nonatomic) NSString *author;
@property (strong, nonatomic) NSString *lastpost;
@property (strong, nonatomic) NSString *dblastpost;
@property (strong, nonatomic) NSString *views;
@property (strong, nonatomic) NSString *replies;
@property (strong, nonatomic) NSString *digest;

+ (CircleListModel *)parseDicToCircleListObject:(NSDictionary*)dataDic;

@end
