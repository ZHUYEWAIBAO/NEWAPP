//
//  TotalInfoModel.h
//  WomenHealthApp
//
//  Created by 朱青 on 15/1/26.
//  Copyright (c) 2015年 WomenHealthApp. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TotalInfoModel : NSObject

@property (strong, nonatomic) NSString * shop_name;
@property (strong, nonatomic) NSString * shop_title;
@property (strong, nonatomic) NSString * shop_desc;
@property (strong, nonatomic) NSString * shop_keywords;
@property (strong, nonatomic) NSString * shop_address;
@property (strong, nonatomic) NSString * qq;
@property (strong, nonatomic) NSString * ww;
@property (strong, nonatomic) NSString * service_email;
@property (strong, nonatomic) NSString * service_phone;
@property (strong, nonatomic) NSString * shop_closed;
@property (strong, nonatomic) NSString * close_comment;
@property (strong, nonatomic) NSString * shop_logo;
@property (strong, nonatomic) NSString * shop_notice;
@property (strong, nonatomic) NSString * icp_number;


+(TotalInfoModel *)parseDicToTotalInfoModelObject:(NSDictionary*)dic;

@end
