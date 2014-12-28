//
//  shopCartListModel.h
//  WomenHealthApp
//
//  Created by Daniel on 14/12/10.
//  Copyright (c) 2014年 WomenHealthApp. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface shopCartListModel : NSObject

@property(nonatomic,strong) NSString *rec_id;
@property(nonatomic,strong) NSString *goods_id;
@property(nonatomic,strong) NSString *goods_name;
@property(nonatomic,strong) NSString *market_price;
@property(nonatomic,strong) NSString *goods_price;
@property(nonatomic,strong) NSString *goods_number;

@property(nonatomic,strong) NSString *goods_attr;
@property(nonatomic,strong) NSString *subtotal;
@property(nonatomic,strong) NSString *goods_thumb;

@property(nonatomic,assign)int selectIndex;


+ (shopCartListModel *)parseDicToShopCartListObject:(NSDictionary*)dic;
@end
