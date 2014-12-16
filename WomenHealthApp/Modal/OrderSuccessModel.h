//
//  OrderSuccessModel.h
//  WomenHealthApp
//
//  Created by 朱青 on 14/12/15.
//  Copyright (c) 2014年 WomenHealthApp. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OrderSuccessModel : NSObject

@property (strong, nonatomic) NSString * order_amount;
@property (strong, nonatomic) NSString * integral;
@property (strong, nonatomic) NSString * goods_amount;
@property (strong, nonatomic) NSString * shipping_fee;
@property (strong, nonatomic) NSString * order_id;

+ (OrderSuccessModel *)parseDicToOrderSuccessObject:(NSDictionary*)dic;

@end
