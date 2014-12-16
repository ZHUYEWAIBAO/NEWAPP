//
//  AddressListModel.m
//  CMCCMall
//
//  Created by 朱 青 on 14-11-11.
//  Copyright (c) 2014年 cmcc. All rights reserved.
//

#import "AddressListModel.h"

@implementation AddressListModel

+ (AddressListModel *)parseDicToAddressListObject:(NSDictionary*)dic
{
    AddressListModel *model = [[AddressListModel alloc]init];
    
    model.zipcode = CHECK_VALUE([dic objectForKey:@"zipcode"]);
    model.mobile = CHECK_VALUE([dic objectForKey:@"mobile"]);
    model.consignee = CHECK_VALUE([dic objectForKey:@"consignee"]);
    model.is_default = CHECK_VALUE([dic objectForKey:@"is_default"]);
    model.address_id = CHECK_VALUE([dic objectForKey:@"address_id"]);
    model.address = CHECK_VALUE([dic objectForKey:@"address"]);
    
    NSDictionary *proDic = [dic objectForKey:@"province"];
    model.province_name = CHECK_VALUE([proDic objectForKey:@"region_name"]);
    model.province_id = CHECK_VALUE([proDic objectForKey:@"region_id"]);

    NSDictionary *countyDic = [dic objectForKey:@"city"];
    model.city_name = CHECK_VALUE([countyDic objectForKey:@"region_name"]);
    model.city_id = CHECK_VALUE([countyDic objectForKey:@"region_id"]);
    
    NSDictionary *areaDic = [dic objectForKey:@"district"];
    model.county_name = CHECK_VALUE([areaDic objectForKey:@"region_name"]);
    model.county_id = CHECK_VALUE([areaDic objectForKey:@"region_id"]);

    
    return model;
    
}

@end
