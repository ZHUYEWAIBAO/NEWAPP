//
//  PayTypeModel.h
//  WomenHealthApp
//
//  Created by 朱青 on 14/12/14.
//  Copyright (c) 2014年 WomenHealthApp. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PayTypeModel : NSObject

@property (strong, nonatomic) NSString * payTypeId;
@property (strong, nonatomic) NSString * payTypeName;

+ (NSMutableArray *)arrayForPayType;

@end
