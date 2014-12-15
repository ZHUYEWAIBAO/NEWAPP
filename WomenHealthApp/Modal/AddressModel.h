//
//  AddressModel.h
//  CMCCMall
//
//  Created by 朱 青 on 14-11-10.
//  Copyright (c) 2014年 cmcc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AddressModel : NSObject

@property(strong,nonatomic)NSString *province_Id;
@property(strong,nonatomic)NSString *province_Name;
@property(strong,nonatomic)NSMutableArray *cityArray;

+(AddressModel *)parseDicToAddressProvinceObject:(NSDictionary*)dic; 

@end

@interface CityModel : NSObject

@property(strong,nonatomic)NSString *city_Id;
@property(strong,nonatomic)NSString *city_Name;
@property(strong,nonatomic)NSMutableArray *areaArray;

+(CityModel *)parseDicToAddressCityObject:(NSDictionary*)dic;

@end

@interface AreaModel : NSObject

@property(strong,nonatomic)NSString *area_Id;
@property(strong,nonatomic)NSString *area_Name;

+(AreaModel *)parseDicToAddressAreaObject:(NSDictionary*)dic;

@end