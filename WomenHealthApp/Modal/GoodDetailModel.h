//
//  GoodDetailModel.h
//  WomenHealthApp
//
//  Created by 朱青 on 14/12/8.
//  Copyright (c) 2014年 WomenHealthApp. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GoodInfoModel : NSObject

@property (strong, nonatomic) NSString * goods_id;
@property (strong, nonatomic) NSString * goods_name;
@property (strong, nonatomic) NSString * goods_number;
@property (strong, nonatomic) NSString * sales_number;
@property (strong, nonatomic) NSString * goods_weight;
@property (strong, nonatomic) NSString * market_price;
@property (strong, nonatomic) NSString * shop_price;
@property (strong, nonatomic) NSString * promote_price;
@property (strong, nonatomic) NSString * goods_desc;
@property (strong, nonatomic) NSString * is_shipping;
@property (strong, nonatomic) NSString * integral;
@property (strong, nonatomic) NSString * is_best;
@property (strong, nonatomic) NSString * is_promote;
@property (strong, nonatomic) NSString * give_integral;
@property (strong, nonatomic) NSString * bonus_money;
@property (strong, nonatomic) NSString * comment_rank;

@property (strong, nonatomic) NSString * totals;

+(GoodInfoModel *)parseDicToB2CGoodInfoObject:(NSDictionary*)dic;

@end

@interface GoodPropertiesBigModel : NSObject

@property (strong, nonatomic) NSMutableArray *propertiesArray;

+(GoodPropertiesBigModel *)parseDicToPropertiesBigModelObject:(NSDictionary*)dic;

@end

@interface GoodPropertiesModel : NSObject

@property (strong, nonatomic) NSString * name;
@property (strong, nonatomic) NSString * value;


+(GoodPropertiesModel *)parseDicToPropertiesModelObject:(NSDictionary*)dic;

@end

@interface GoodSpecificationBigModel : NSObject

@property (strong, nonatomic) NSMutableArray * specificationArray;

+(GoodSpecificationBigModel *)parseDicToSpecificationBigModelObject:(NSDictionary*)dic;

@end

@interface GoodSpecificationModel : NSObject

@property (strong, nonatomic) NSString * attr_type;
@property (strong, nonatomic) NSString * name;

@property (strong, nonatomic) NSMutableArray * valuesArray;

+(GoodSpecificationModel *)parseDicToSpecificationModelObject:(NSDictionary*)dic;

@end

@interface GoodValuesModel : NSObject

@property (strong, nonatomic) NSString * label;
@property (strong, nonatomic) NSString * price;
@property (strong, nonatomic) NSString * format_price;
@property (strong, nonatomic) NSString * value_id;

+(GoodValuesModel *)parseDicToValuesModelObject:(NSDictionary*)dic;

@end

@interface GoodImageBigModel : NSObject

@property (strong, nonatomic) NSMutableArray * imagesArray;

+(GoodImageBigModel *)parseDicToImageBigModelObject:(NSDictionary*)dic;

@end

@interface GoodImageModel : NSObject

@property (strong, nonatomic) NSString * img_id;
@property (strong, nonatomic) NSString * img_url;
@property (strong, nonatomic) NSString * thumb_url;
@property (strong, nonatomic) NSString * img_desc;

+(GoodImageModel *)parseDicToImageModelObject:(NSDictionary*)dic;

@end

@interface GoodDiscussModel : NSObject

@property (strong, nonatomic) NSString * totals;

@property (strong, nonatomic) NSMutableArray * discussArray;

+(GoodDiscussModel *)parseDicToDiscussModelObject:(NSDictionary*)dic;

@end

@interface GoodDiscussValueModel : NSObject

@property (strong, nonatomic) NSString * discuss_id;
@property (strong, nonatomic) NSString * discuss_content;
@property (strong, nonatomic) NSString * discuss_time;
@property (strong, nonatomic) NSString * discuss_user_name;
@property (strong, nonatomic) NSString * discuss_user_id;
@property (strong, nonatomic) NSString * discuss_user_avatar;

@property (strong, nonatomic) NSMutableArray * headArray;

+(GoodDiscussValueModel *)parseDicToDiscussValueModelObject:(NSDictionary*)dic;

@end

@interface GoodHeadModel : NSObject

@property (strong, nonatomic) NSString * img_path;

+(GoodHeadModel *)parseDicToHeadModelObject:(NSDictionary*)dic;

@end


@interface GoodDetailModel : NSObject

@property (strong, nonatomic) GoodInfoModel * infoModel;
@property (strong, nonatomic) GoodSpecificationBigModel * specificationModel;
@property (strong, nonatomic) GoodPropertiesBigModel * propertiesModel;
@property (strong, nonatomic) GoodImageBigModel * imageModel;
@property (strong, nonatomic) GoodDiscussModel * discussModel;

+(GoodDetailModel *)parseDicToB2CGoodDetailObject:(NSDictionary*)dic;

@end
