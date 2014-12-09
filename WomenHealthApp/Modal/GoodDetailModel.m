//
//  GoodDetailModel.m
//  WomenHealthApp
//
//  Created by 朱青 on 14/12/8.
//  Copyright (c) 2014年 WomenHealthApp. All rights reserved.
//

#import "GoodDetailModel.h"


@implementation GoodInfoModel

+ (GoodInfoModel *)parseDicToB2CGoodInfoObject:(NSDictionary*)dic
{
    GoodInfoModel *model = [[GoodInfoModel alloc]init];
    
    model.goods_id = CHECK_VALUE([dic objectForKey:@"goods_id"]);
    model.goods_name = CHECK_VALUE([dic objectForKey:@"goods_name"]);
    model.goods_number = CHECK_VALUE([dic objectForKey:@"goods_number"]);
    model.sales_number = CHECK_VALUE([dic objectForKey:@"sales_number"]);
    model.goods_weight = CHECK_VALUE([dic objectForKey:@"goods_weight"]);
    model.market_price = CHECK_VALUE([dic objectForKey:@"market_price"]);
    model.shop_price = CHECK_VALUE([dic objectForKey:@"shop_price"]);
    model.promote_price = CHECK_VALUE([dic objectForKey:@"promote_price"]);
    model.goods_desc = CHECK_VALUE([dic objectForKey:@"goods_desc"]);
    model.is_shipping = CHECK_VALUE([dic objectForKey:@"is_shipping"]);
    
    model.integral = CHECK_VALUE([dic objectForKey:@"integral"]);
    model.is_best = CHECK_VALUE([dic objectForKey:@"is_best"]);
    model.is_promote = CHECK_VALUE([dic objectForKey:@"is_promote"]);
    
    model.give_integral = CHECK_VALUE([dic objectForKey:@"give_integral"]);
    model.bonus_money = CHECK_VALUE([dic objectForKey:@"bonus_money"]);
    model.comment_rank = CHECK_VALUE([dic objectForKey:@"comment_rank"]);
    
    return model;
    
}

@end

@implementation GoodPropertiesBigModel

- (id)init
{
    if (self = [super init]) {
        _propertiesArray = [[NSMutableArray alloc]initWithCapacity:0];
    }
    return self;
}

+ (GoodPropertiesBigModel *)parseDicToPropertiesBigModelObject:(NSDictionary*)dic
{
    GoodPropertiesBigModel *model = [[GoodPropertiesBigModel alloc]init];
    
    for (NSMutableDictionary *dictionary in CHECK_ARRAY_VALUE([dic objectForKey:@"list"])) {
        
        GoodPropertiesModel *value = [GoodPropertiesModel parseDicToPropertiesModelObject:dictionary];
        
        [model.propertiesArray addObject:value];
        
    }
    
    return model;
    
}

@end


@implementation GoodSpecificationBigModel

- (id)init
{
    if (self = [super init]) {
        _specificationArray = [[NSMutableArray alloc]initWithCapacity:0];
    }
    return self;
}

+ (GoodSpecificationBigModel *)parseDicToSpecificationBigModelObject:(NSDictionary*)dic
{
    GoodSpecificationBigModel *model = [[GoodSpecificationBigModel alloc]init];
 
    for (NSMutableDictionary *dictionary in CHECK_ARRAY_VALUE([dic objectForKey:@"list"])) {
        
        GoodSpecificationModel *value = [GoodSpecificationModel parseDicToSpecificationModelObject:dictionary];
        
        [model.specificationArray addObject:value];
        
    }
    return model;
    
}

@end

@implementation GoodPropertiesModel

+ (GoodPropertiesModel *)parseDicToPropertiesModelObject:(NSDictionary*)dic
{
    GoodPropertiesModel *model = [[GoodPropertiesModel alloc]init];
    
    model.name = CHECK_VALUE([dic objectForKey:@"name"]);
    model.value = CHECK_VALUE([dic objectForKey:@"value"]);
    
    return model;
    
}

@end

@implementation GoodSpecificationModel

- (id)init
{
    if (self = [super init]) {
        _valuesArray = [[NSMutableArray alloc]initWithCapacity:0];
    }
    return self;
}

+ (GoodSpecificationModel *)parseDicToSpecificationModelObject:(NSDictionary*)dic
{
    GoodSpecificationModel *model = [[GoodSpecificationModel alloc]init];
    
    model.name = CHECK_VALUE([dic objectForKey:@"name"]);
    model.attr_type = CHECK_VALUE([dic objectForKey:@"attr_type"]);
    
    for (NSMutableDictionary *dictionary in CHECK_ARRAY_VALUE([dic objectForKey:@"values"])) {
        
        GoodValuesModel *value = [GoodValuesModel parseDicToValuesModelObject:dictionary];
        
        [model.valuesArray addObject:value];
        
    }
    return model;
    
}

@end

@implementation GoodValuesModel

+ (GoodValuesModel *)parseDicToValuesModelObject:(NSDictionary*)dic
{
    GoodValuesModel *model = [[GoodValuesModel alloc]init];
    
    model.label = CHECK_VALUE([dic objectForKey:@"label"]);
    model.price = CHECK_VALUE([dic objectForKey:@"price"]);
    model.format_price = CHECK_VALUE([dic objectForKey:@"format_price"]);
    model.value_id = CHECK_VALUE([dic objectForKey:@"id"]);
    
    return model;
    
}

@end

@implementation GoodImageBigModel

- (id)init
{
    if (self = [super init]) {
        _imagesArray = [[NSMutableArray alloc]initWithCapacity:0];
    }
    return self;
}

+ (GoodImageBigModel *)parseDicToImageBigModelObject:(NSDictionary*)dic
{
    GoodImageBigModel *model = [[GoodImageBigModel alloc]init];
  
    for (NSMutableDictionary *dictionary in CHECK_ARRAY_VALUE([dic objectForKey:@"list"])) {
        
        GoodImageModel *value = [GoodImageModel parseDicToImageModelObject:dictionary];
        
        [model.imagesArray addObject:value];
        
    }
    return model;
    
}

@end

@implementation GoodImageModel

+ (GoodImageModel *)parseDicToImageModelObject:(NSDictionary*)dic
{
    GoodImageModel *model = [[GoodImageModel alloc]init];
    
    model.img_id = CHECK_VALUE([dic objectForKey:@"img_id"]);
    model.img_url = CHECK_VALUE([dic objectForKey:@"img_url"]);
    model.thumb_url = CHECK_VALUE([dic objectForKey:@"thumb_url"]);
    model.img_desc = CHECK_VALUE([dic objectForKey:@"img_desc"]);
    
    return model;
    
}

@end

@implementation GoodDiscussModel

- (id)init
{
    if (self = [super init]) {
        _discussArray = [[NSMutableArray alloc]initWithCapacity:0];
    }
    return self;
}

+ (GoodDiscussModel *)parseDicToDiscussModelObject:(NSDictionary*)dic
{
    GoodDiscussModel *model = [[GoodDiscussModel alloc]init];
    
    model.totals = CHECK_VALUE([dic objectForKey:@"totals"]);
    
    for (NSMutableDictionary *dictionary in CHECK_ARRAY_VALUE([dic objectForKey:@"list"])) {
        
        GoodDiscussValueModel *value = [GoodDiscussValueModel parseDicToDiscussValueModelObject:dictionary];
        
        [model.discussArray addObject:value];
        
    }
    
    return model;
    
}

@end

@implementation GoodDiscussValueModel

- (id)init
{
    if (self = [super init]) {
        _headArray = [[NSMutableArray alloc]initWithCapacity:0];
    }
    return self;
}

+ (GoodDiscussValueModel *)parseDicToDiscussValueModelObject:(NSDictionary*)dic
{
    GoodDiscussValueModel *model = [[GoodDiscussValueModel alloc]init];
    
    model.discuss_id = CHECK_VALUE([dic objectForKey:@"discuss_id"]);
    model.discuss_content = CHECK_VALUE([dic objectForKey:@"discuss_content"]);
    model.discuss_time = CHECK_VALUE([dic objectForKey:@"discuss_time"]);
    model.discuss_user_name = CHECK_VALUE([dic objectForKey:@"discuss_user_name"]);
    
    model.discuss_user_id = CHECK_VALUE([dic objectForKey:@"discuss_user_id"]);
    model.discuss_user_avatar = CHECK_VALUE([dic objectForKey:@"discuss_user_avatar"]);

    for (NSMutableDictionary *dictionary in CHECK_ARRAY_VALUE([dic objectForKey:@"discuss_imgs"])) {
        
        GoodHeadModel *value = [GoodHeadModel parseDicToHeadModelObject:dictionary];
        
        [model.headArray addObject:value];
        
    }
    
    return model;
    
}

@end

@implementation GoodHeadModel

+ (GoodHeadModel *)parseDicToHeadModelObject:(NSDictionary*)dic
{
    GoodHeadModel *model = [[GoodHeadModel alloc]init];
    
    model.img_path = CHECK_VALUE([dic objectForKey:@"img_path"]);

    return model;
    
}

@end


@implementation GoodDetailModel

+ (GoodDetailModel *)parseDicToB2CGoodDetailObject:(NSDictionary*)dic
{
    GoodDetailModel *model = [[GoodDetailModel alloc]init];
    
    model.infoModel = [GoodInfoModel parseDicToB2CGoodInfoObject:[dic objectForKey:@"goods"]];
    model.propertiesModel = [GoodPropertiesBigModel parseDicToPropertiesBigModelObject:[dic objectForKey:@"properties"]];
    model.specificationModel = [GoodSpecificationBigModel parseDicToSpecificationBigModelObject:[dic objectForKey:@"specification"]];
    model.imageModel = [GoodImageBigModel parseDicToImageBigModelObject:[dic objectForKey:@"pictures"]];
    model.discussModel = [GoodDiscussModel parseDicToDiscussModelObject:[dic objectForKey:@"discuss"]];
    
    return model;
    
}

@end

