//
//  MyOrderDetailModel.h
//  WomenHealthApp
//
//  Created by 朱青 on 14/12/17.
//  Copyright (c) 2014年 WomenHealthApp. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyOrderDetailModel : NSObject

@property (strong, nonatomic) NSString * order_id;
@property (strong, nonatomic) NSString * order_sn;
@property (strong, nonatomic) NSString * shipping_id;
@property (strong, nonatomic) NSString * shipping_name;
@property (strong, nonatomic) NSString * pay_id;
@property (strong, nonatomic) NSString * pay_name;
@property (strong, nonatomic) NSString * goods_amount;
@property (strong, nonatomic) NSString * shipping_fee;
@property (strong, nonatomic) NSString * order_amount;
@property (strong, nonatomic) NSString * add_time;
@property (strong, nonatomic) NSString * pay_time;
@property (strong, nonatomic) NSString * shipping_time;
@property (strong, nonatomic) NSString * timing;
@property (strong, nonatomic) NSString * buy_nums;
@property (strong, nonatomic) NSString * month;
@property (strong, nonatomic) NSString * timing_nums;
@property (strong, nonatomic) NSString * order_status;
@property (strong, nonatomic) NSString * invoice_no;
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
@property (strong, nonatomic) NSString * integral_str;

@property (strong, nonatomic) NSMutableArray * goodsArray;

+ (MyOrderDetailModel *)parseDicToMyOrderDetailObject:(NSDictionary*)dataDic;

@end

