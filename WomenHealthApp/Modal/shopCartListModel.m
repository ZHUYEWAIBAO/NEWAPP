//
//  shopCartListModel.m
//  WomenHealthApp
//
//  Created by Daniel on 14/12/10.
//  Copyright (c) 2014年 WomenHealthApp. All rights reserved.
//

#import "shopCartListModel.h"

@implementation shopCartListModel
+ (shopCartListModel *)parseDicToShopCartListObject:(NSDictionary*)dic{
    
    
    shopCartListModel *model = [[shopCartListModel alloc]init];
    
    model.rec_id = CHECK_VALUE([dic objectForKey:@"rec_id"]);
    model.goods_id = CHECK_VALUE([dic objectForKey:@"goods_id"]);
    model.goods_name = CHECK_VALUE([dic objectForKey:@"goods_name"]);
    model.market_price = CHECK_VALUE([dic objectForKey:@"market_price"]);
    model.goods_price = CHECK_VALUE([dic objectForKey:@"goods_price"]);
    model.goods_number = CHECK_VALUE([dic objectForKey:@"goods_number"]);
    

    
    model.goods_attr = CHECK_VALUE([dic objectForKey:@"goods_attr"]);
    model.goods_thumb = CHECK_VALUE([dic objectForKey:@"goods_thumb"]);
    
    model.subtotal = CHECK_VALUE([dic objectForKey:@"subtotal"]);

    
    
    return model;
}



@end
