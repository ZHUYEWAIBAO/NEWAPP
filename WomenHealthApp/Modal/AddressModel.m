//
//  AddressModel.m
//  CMCCMall
//
//  Created by 朱 青 on 14-11-10.
//  Copyright (c) 2014年 cmcc. All rights reserved.
//

#import "AddressModel.h"

@implementation AddressModel

- (id)init
{
    if (self = [super init]) {
        _cityArray = [[NSMutableArray alloc]initWithCapacity:0];
    }
    return self;
}

+ (AddressModel *)parseDicToAddressProvinceObject:(NSDictionary *)dic
{
    AddressModel *model = [[AddressModel alloc]init];
    
    model.province_Id = CHECK_VALUE([dic objectForKey:@"region_id"]);
    model.province_Name = CHECK_VALUE([dic objectForKey:@"region_name"]);
    
    for (NSDictionary *subDic in CHECK_ARRAY_VALUE([dic objectForKey:@"region_child"])) {
        
        CityModel *cityModel = [CityModel parseDicToAddressCityObject:subDic];
        
        [model.cityArray addObject:cityModel];
    }

    
    return model;
}

@end

@implementation CityModel

- (id)init
{
    if (self = [super init]) {
        _areaArray = [[NSMutableArray alloc]initWithCapacity:0];
    }
    return self;
}

+ (CityModel *)parseDicToAddressCityObject:(NSDictionary *)dic
{
    CityModel *model = [[CityModel alloc]init];
    
    model.city_Id = CHECK_VALUE([dic objectForKey:@"region_id"]);
    model.city_Name = CHECK_VALUE([dic objectForKey:@"region_name"]);
    
    for (NSDictionary *subDic in CHECK_ARRAY_VALUE([dic objectForKey:@"region_child"])) {
        
        AreaModel *areaModel = [AreaModel parseDicToAddressAreaObject:subDic];
        
        [model.areaArray addObject:areaModel];
    }
    
    return model;
}

@end

@implementation AreaModel

+ (AreaModel *)parseDicToAddressAreaObject:(NSDictionary *)dic
{
    AreaModel *model = [[AreaModel alloc]init];
    
    model.area_Id = CHECK_VALUE([dic objectForKey:@"region_id"]);
    model.area_Name = CHECK_VALUE([dic objectForKey:@"region_name"]);
    
    return model;
}

@end