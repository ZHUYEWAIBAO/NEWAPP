//
//  GoodsListModel.m
//  WomenHealthApp
//
//  Created by 朱青 on 14/12/3.
//  Copyright (c) 2014年 WomenHealthApp. All rights reserved.
//

#import "GoodsListModel.h"

@implementation GoodsListModel

+(GoodsListModel *)parseDicToB2CGoodModelObject:(NSDictionary*)dic
{
    GoodsListModel *model = [[GoodsListModel alloc]init];
    
    model.goods_id = CHECK_VALUE([dic objectForKey:@"goods_id"]);
    model.sales_number = CHECK_VALUE([dic objectForKey:@"sales_number"]);
    model.is_best = CHECK_VALUE([dic objectForKey:@"is_best"]);
    model.goods_name = CHECK_VALUE([dic objectForKey:@"goods_name"]);
    model.type = CHECK_VALUE([dic objectForKey:@"type"]);
    model.market_price = CHECK_VALUE([dic objectForKey:@"market_price"]);
    model.shop_price = CHECK_VALUE([dic objectForKey:@"shop_price"]);
    model.promote_price = CHECK_VALUE([dic objectForKey:@"promote_price"]);
    model.goods_img = CHECK_VALUE([dic objectForKey:@"goods_img"]);
    model.recommend_tag_pic = CHECK_VALUE([dic objectForKey:@"recommend_tag_pic"]);
    
    return model;
}

@end
