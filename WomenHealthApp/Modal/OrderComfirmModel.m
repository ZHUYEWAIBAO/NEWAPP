//
//  OrderComfirmModel.m
//  WomenHealthApp
//
//  Created by 朱青 on 14/12/13.
//  Copyright (c) 2014年 WomenHealthApp. All rights reserved.
//

#import "OrderComfirmModel.h"

@implementation OrderComfirmModel

- (id)init
{
    if (self = [super init]) {
        _goodListArray = [[NSMutableArray alloc]initWithCapacity:0];
    }
    return self;
}

+ (OrderComfirmModel *)parseDicToOrderComfirmObject:(NSDictionary*)dic
{
    OrderComfirmModel *model = [[OrderComfirmModel alloc]init];
    
    NSDictionary *subDic = [dic objectForKey:@"total"];
    model.goods_price = CHECK_VALUE([subDic objectForKey:@"goods_price"]);
    model.market_price = CHECK_VALUE([subDic objectForKey:@"market_price"]);
    model.saving = CHECK_VALUE([subDic objectForKey:@"saving"]);
    model.save_rate = CHECK_VALUE([subDic objectForKey:@"save_rate"]);
    model.order_max_integral = CHECK_VALUE([subDic objectForKey:@"order_max_integral"]);
    model.order_reduce_moeny = CHECK_VALUE([subDic objectForKey:@"order_reduce_moeny"]);
    model.order_max_integral_str = CHECK_VALUE([subDic objectForKey:@"order_max_integral_str"]);
    model.your_integral = CHECK_VALUE([subDic objectForKey:@"your_integral"]);
    model.allow_use_integral = CHECK_VALUE([subDic objectForKey:@"allow_use_integral"]);
    model.shipping_fee = CHECK_VALUE([subDic objectForKey:@"shipping_fee"]);
    model.rec_ids = CHECK_VALUE([subDic objectForKey:@"rec_ids"]);
    
    NSDictionary *addressDic = [subDic objectForKey:@"consignee"];
    model.consignee_exist = CHECK_VALUE([addressDic objectForKey:@"consignee_exist"]);
    
    NSDictionary *consigneeDic = [addressDic objectForKey:@"consignee"];
    model.address_id = CHECK_VALUE([consigneeDic objectForKey:@"address_id"]);
    model.address = CHECK_VALUE([consigneeDic objectForKey:@"address"]);
    model.zipcode = CHECK_VALUE([consigneeDic objectForKey:@"zipcode"]);
    model.mobile = CHECK_VALUE([consigneeDic objectForKey:@"mobile"]);
    model.consignee = CHECK_VALUE([consigneeDic objectForKey:@"consignee"]);
    
    NSDictionary *provinceDic = [consigneeDic objectForKey:@"province"];
    model.province_id = CHECK_VALUE([provinceDic objectForKey:@"region_id"]);
    model.province_name = CHECK_VALUE([provinceDic objectForKey:@"region_name"]);
    
    NSDictionary *cityDic = [consigneeDic objectForKey:@"city"];
    model.city_id = CHECK_VALUE([cityDic objectForKey:@"region_id"]);
    model.city_name = CHECK_VALUE([cityDic objectForKey:@"region_name"]);
    
    NSDictionary *areaDic = [consigneeDic objectForKey:@"district"];
    model.area_id = CHECK_VALUE([areaDic objectForKey:@"region_id"]);
    model.area_name = CHECK_VALUE([areaDic objectForKey:@"region_name"]);
    
    for (NSDictionary *goodDic in CHECK_ARRAY_VALUE([dic objectForKey:@"goods_list"])) {
        
        OrderListModel *subModel = [OrderListModel parseDicToOrderGoodsObject:goodDic];
        
        [model.goodListArray addObject:subModel];
    }
    
    return model;
}

@end

@implementation OrderListModel

+ (OrderListModel *)parseDicToOrderGoodsObject:(NSDictionary*)dic
{
    OrderListModel *model = [[OrderListModel alloc]init];

    model.rec_id = CHECK_VALUE([dic objectForKey:@"rec_id"]);
    model.goods_id = CHECK_VALUE([dic objectForKey:@"goods_id"]);
    model.goods_name = CHECK_VALUE([dic objectForKey:@"goods_name"]);
    model.market_price = CHECK_VALUE([dic objectForKey:@"market_price"]);
    model.goods_price = CHECK_VALUE([dic objectForKey:@"goods_price"]);
    model.goods_number = CHECK_VALUE([dic objectForKey:@"goods_number"]);
    model.goods_attr = CHECK_VALUE([dic objectForKey:@"goods_attr"]);
    model.is_real = CHECK_VALUE([dic objectForKey:@"is_real"]);
    model.subtotal = CHECK_VALUE([dic objectForKey:@"subtotal"]);
    model.goods_thumb = CHECK_VALUE([dic objectForKey:@"goods_thumb"]);
    
    return model;
}

@end