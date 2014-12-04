//
//  GoodsListModel.h
//  WomenHealthApp
//
//  Created by 朱青 on 14/12/3.
//  Copyright (c) 2014年 WomenHealthApp. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GoodsListModel : NSObject

@property (strong, nonatomic) NSString * goods_id;
@property (strong, nonatomic) NSString * sales_number;
@property (strong, nonatomic) NSString * is_best;
@property (strong, nonatomic) NSString * goods_name;
@property (strong, nonatomic) NSString * type;
@property (strong, nonatomic) NSString * market_price;
@property (strong, nonatomic) NSString * shop_price;
@property (strong, nonatomic) NSString * promote_price;
@property (strong, nonatomic) NSString * goods_img;
@property (strong, nonatomic) NSString * recommend_tag_pic;

//列表请求
+(GoodsListModel *)parseDicToB2CGoodModelObject:(NSDictionary*)dic;

@end
