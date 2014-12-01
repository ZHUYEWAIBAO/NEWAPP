//
//  AdModal.h
//  WomenHealthApp
//
//  Created by 朱青 on 14/12/1.
//  Copyright (c) 2014年 WomenHealthApp. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AdModal : NSObject

@property (strong, nonatomic) NSString * adSrc;               //图片
@property (strong, nonatomic) NSString * adText;              //内容
@property (strong, nonatomic) NSString * adType;              //方式
@property (strong, nonatomic) NSString * adUrl;               //链接

+ (AdModal *)parseDicToPanicADObject:(NSDictionary *)dic;

@end
