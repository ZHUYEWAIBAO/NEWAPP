//
//  OrderComfirmModel.h
//  WomenHealthApp
//
//  Created by 朱青 on 14/12/13.
//  Copyright (c) 2014年 WomenHealthApp. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OrderComfirmModel : NSObject

@property (strong, nonatomic) NSString * goods_price;
@property (strong, nonatomic) NSString * market_price;
@property (strong, nonatomic) NSString * saving;
@property (strong, nonatomic) NSString * save_rate;
@property (strong, nonatomic) NSString * order_max_integral;
@property (strong, nonatomic) NSString * order_reduce_moeny;
@property (strong, nonatomic) NSString * order_max_integral_str;
@property (strong, nonatomic) NSString * your_integral;
@property (strong, nonatomic) NSString * allow_use_integral;
@property (strong, nonatomic) NSString * shipping_fee;
@property (strong, nonatomic) NSString * rec_ids;
@property (strong, nonatomic) NSString * consignee_exist;

@property (strong, nonatomic) NSString * address_id;
@property (strong, nonatomic) NSString * address;
@property (strong, nonatomic) NSString * zipcode;
@property (strong, nonatomic) NSString * mobile;
@property (strong, nonatomic) NSString * consignee;
@property (strong, nonatomic) NSString * province_id;
@property (strong, nonatomic) NSString * province_name;
@property (strong, nonatomic) NSString * city_id;
@property (strong, nonatomic) NSString * city_name;
@property (strong, nonatomic) NSString * area_id;
@property (strong, nonatomic) NSString * area_name;

@property (strong, nonatomic) NSMutableArray * goodListArray;

+ (OrderComfirmModel *)parseDicToOrderComfirmObject:(NSDictionary*)dic;

@end

@interface OrderListModel : NSObject

@property (strong, nonatomic) NSString * rec_id;
@property (strong, nonatomic) NSString * goods_id;
@property (strong, nonatomic) NSString * goods_name;
@property (strong, nonatomic) NSString * market_price;
@property (strong, nonatomic) NSString * goods_price;
@property (strong, nonatomic) NSString * goods_number;
@property (strong, nonatomic) NSString * goods_attr;
@property (strong, nonatomic) NSString * is_real;
@property (strong, nonatomic) NSString * subtotal;
@property (strong, nonatomic) NSString * goods_thumb;

+ (OrderListModel *)parseDicToOrderGoodsObject:(NSDictionary*)dic;

@end