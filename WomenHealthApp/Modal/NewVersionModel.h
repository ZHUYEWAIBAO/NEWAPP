//
//  NewVersionModel.h
//  YueDongApp
//
//  Created by 朱 青 on 14-8-21.
//  Copyright (c) 2014年 朱 青. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NewVersionModel : NSObject

@property(strong,nonatomic)NSString *version;           //版本号
@property(strong,nonatomic)NSString *link;              //地址
@property(strong,nonatomic)NSString *content;           //说明

+ (NewVersionModel *)parseDicToNewVersionModel:(NSDictionary*)dic;

@end
