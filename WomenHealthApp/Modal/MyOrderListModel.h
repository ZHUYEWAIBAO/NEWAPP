//
//  MyOrderListModel.h
//  WomenHealthApp
//
//  Created by 朱青 on 14/12/15.
//  Copyright (c) 2014年 WomenHealthApp. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyOrderListModel : NSObject

@property (strong, nonatomic) NSString * order_id;
@property (strong, nonatomic) NSString * order_sn;
@property (strong, nonatomic) NSString * order_time;
@property (strong, nonatomic) NSString * order_status;
@property (strong, nonatomic) NSString * total_fee;
@property (strong, nonatomic) NSString * invoice_no;
@property (strong, nonatomic) NSString * shipping_name;
@property (strong, nonatomic) NSString * shipping_id;
@property (strong, nonatomic) NSString * shipping_time;
@property (strong, nonatomic) NSString * pay_time;
@property (strong, nonatomic) NSString * affirm_time;

@property (strong, nonatomic) NSMutableArray * goodsArray;

+ (MyOrderListModel *)parseDicToMyOrderListObject:(NSDictionary*)dic;

@end

@interface MyOrderGoodsModel : NSObject

@property (strong, nonatomic) NSString * goods_name;
@property (strong, nonatomic) NSString * market_price;
@property (strong, nonatomic) NSString * shop_price;
@property (strong, nonatomic) NSString * goods_thumb;
@property (strong, nonatomic) NSString * goods_img;
@property (strong, nonatomic) NSString * goods_number;
@property (strong, nonatomic) NSString * goods_attr;
@property (strong, nonatomic) NSString * goods_id;

+ (MyOrderGoodsModel *)parseDicToMyOrderGoodObject:(NSDictionary*)dic;

@end
