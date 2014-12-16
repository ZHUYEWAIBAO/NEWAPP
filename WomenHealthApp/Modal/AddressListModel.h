//
//  AddressListModel.h
//  CMCCMall
//
//  Created by 朱 青 on 14-11-11.
//  Copyright (c) 2014年 cmcc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AddressListModel : NSObject

@property(strong,nonatomic)NSString *address_id;
@property(strong,nonatomic)NSString *zipcode;                     //邮编
@property(strong,nonatomic)NSString *county_name;                 //地区
@property(strong,nonatomic)NSString *county_id;                   //地区code
@property(strong,nonatomic)NSString *consignee;                   //收货人姓名
@property(strong,nonatomic)NSString *is_default;                  //是否市默认地址
@property(strong,nonatomic)NSString *city_name;                   //城市名
@property(strong,nonatomic)NSString *city_id;                     //城市code
@property(strong,nonatomic)NSString *address;                     //详细地址
@property(strong,nonatomic)NSString *province_id;                 //省code
@property(strong,nonatomic)NSString *province_name;               //省名字
@property(strong,nonatomic)NSString *mobile;                      //手机号码

+ (AddressListModel *)parseDicToAddressListObject:(NSDictionary*)dic;

@end
