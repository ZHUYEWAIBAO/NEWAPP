//
//  MyOrderDetailModel.m
//  WomenHealthApp
//
//  Created by 朱青 on 14/12/17.
//  Copyright (c) 2014年 WomenHealthApp. All rights reserved.
//

#import "MyOrderDetailModel.h"
#import "MyOrderListModel.h"

@implementation MyOrderDetailModel

- (id)init
{
    if (self = [super init]) {
        _goodsArray = [[NSMutableArray alloc]initWithCapacity:0];
    }
    return self;
}

+ (MyOrderDetailModel *)parseDicToMyOrderDetailObject:(NSDictionary*)dataDic
{
    MyOrderDetailModel *model = [[MyOrderDetailModel alloc]init];
    
    NSDictionary *dic = [dataDic objectForKey:@"order"];
    model.order_id = CHECK_VALUE([dic objectForKey:@"order_id"]);
    model.order_sn = CHECK_VALUE([dic objectForKey:@"order_sn"]);
    model.shipping_id = CHECK_VALUE([dic objectForKey:@"shipping_id"]);
    model.shipping_name = CHECK_VALUE([dic objectForKey:@"shipping_name"]);
    model.goods_amount = CHECK_VALUE([dic objectForKey:@"goods_amount"]);
    model.shipping_fee = CHECK_VALUE([dic objectForKey:@"shipping_fee"]);
    model.order_amount = CHECK_VALUE([dic objectForKey:@"order_amount"]);
    model.add_time = CHECK_VALUE([dic objectForKey:@"add_time"]);
    model.pay_time = CHECK_VALUE([dic objectForKey:@"pay_time"]);
    model.shipping_time = CHECK_VALUE([dic objectForKey:@"shipping_time"]);
    model.timing = CHECK_VALUE([dic objectForKey:@"timing"]);
    model.buy_nums = CHECK_VALUE([dic objectForKey:@"buy_nums"]);
    model.month = CHECK_VALUE([dic objectForKey:@"month"]);
    model.timing_nums = CHECK_VALUE([dic objectForKey:@"timing_nums"]);
    model.order_status = CHECK_VALUE([dic objectForKey:@"order_status"]);
    model.invoice_no = CHECK_VALUE([dic objectForKey:@"invoice_no"]);
    model.pay_id = CHECK_VALUE([dic objectForKey:@"pay_id"]);
    model.integral_str = CHECK_VALUE([dic objectForKey:@"integral_str"]);
    
    NSDictionary *consigneeDic = [dataDic objectForKey:@"consignee"];
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
    
    for (NSDictionary *goodDic in CHECK_ARRAY_VALUE([dataDic objectForKey:@"goods_list"])) {
        
        MyOrderGoodsModel *subModel = [MyOrderGoodsModel parseDicToMyOrderGoodObject:goodDic];
        
        [model.goodsArray addObject:subModel];
    }
    
    return model;
}

@end
