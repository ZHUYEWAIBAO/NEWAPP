//
//  OrderSuccessModel.m
//  WomenHealthApp
//
//  Created by 朱青 on 14/12/15.
//  Copyright (c) 2014年 WomenHealthApp. All rights reserved.
//

#import "OrderSuccessModel.h"

@implementation OrderSuccessModel

+ (OrderSuccessModel *)parseDicToOrderSuccessObject:(NSDictionary*)dic
{
    OrderSuccessModel *model = [[OrderSuccessModel alloc]init];
    
    model.order_amount = CHECK_VALUE([dic objectForKey:@"order_amount"]);
    model.integral = CHECK_VALUE([dic objectForKey:@"integral"]);
    model.goods_amount = CHECK_VALUE([dic objectForKey:@"goods_amount"]);
    model.shipping_fee = CHECK_VALUE([dic objectForKey:@"shipping_fee"]);
    model.order_id = CHECK_VALUE([dic objectForKey:@"order_id"]);
    
    return model;
}

@end
