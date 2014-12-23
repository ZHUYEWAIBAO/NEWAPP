//
//  MyOrderListModel.m
//  WomenHealthApp
//
//  Created by 朱青 on 14/12/15.
//  Copyright (c) 2014年 WomenHealthApp. All rights reserved.
//

#import "MyOrderListModel.h"

@implementation MyOrderListModel

- (id)init
{
    if (self = [super init]) {
        _goodsArray = [[NSMutableArray alloc]initWithCapacity:0];
    }
    return self;
}

+ (MyOrderListModel *)parseDicToMyOrderListObject:(NSDictionary*)dic
{
    MyOrderListModel *model = [[MyOrderListModel alloc]init];
    
    model.order_id = CHECK_VALUE([dic objectForKey:@"order_id"]);
    model.order_sn = CHECK_VALUE([dic objectForKey:@"order_sn"]);
    model.order_time = CHECK_VALUE([dic objectForKey:@"order_time"]);
    model.order_status = CHECK_VALUE([dic objectForKey:@"order_status"]);
    model.total_fee = CHECK_VALUE([dic objectForKey:@"total_fee"]);
    model.invoice_no = CHECK_VALUE([dic objectForKey:@"invoice_no"]);
    model.shipping_name = CHECK_VALUE([dic objectForKey:@"shipping_name"]);
    model.shipping_id = CHECK_VALUE([dic objectForKey:@"shipping_id"]);
    model.shipping_time = CHECK_VALUE([dic objectForKey:@"shipping_time"]);
    model.pay_time = CHECK_VALUE([dic objectForKey:@"pay_time"]);
    model.affirm_time = CHECK_VALUE([dic objectForKey:@"affirm_time"]);

    for (NSDictionary *goodDic in CHECK_ARRAY_VALUE([dic objectForKey:@"g_goods"])) {
        
        MyOrderGoodsModel *subModel = [MyOrderGoodsModel parseDicToMyOrderGoodObject:goodDic];
        
        [model.goodsArray addObject:subModel];
    }
    
    return model;
}

@end

@implementation MyOrderGoodsModel

+ (MyOrderGoodsModel *)parseDicToMyOrderGoodObject:(NSDictionary*)dic
{
    MyOrderGoodsModel *model = [[MyOrderGoodsModel alloc]init];
    
    model.goods_name = CHECK_VALUE([dic objectForKey:@"goods_name"]);
    model.market_price = CHECK_VALUE([dic objectForKey:@"market_price"]);
    model.shop_price = CHECK_VALUE([dic objectForKey:@"shop_price"]);
    model.goods_thumb = CHECK_VALUE([dic objectForKey:@"goods_thumb"]);
    model.goods_img = CHECK_VALUE([dic objectForKey:@"goods_img"]);
    model.goods_number = CHECK_VALUE([dic objectForKey:@"goods_number"]);
    model.goods_attr = CHECK_VALUE([dic objectForKey:@"goods_attr"]);
    model.goods_id = CHECK_VALUE([dic objectForKey:@"goods_id"]);
    
    return model;
}

@end