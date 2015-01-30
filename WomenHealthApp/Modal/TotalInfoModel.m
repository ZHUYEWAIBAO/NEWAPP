//
//  TotalInfoModel.m
//  WomenHealthApp
//
//  Created by 朱青 on 15/1/26.
//  Copyright (c) 2015年 WomenHealthApp. All rights reserved.
//

#import "TotalInfoModel.h"

@implementation TotalInfoModel

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self) {
        self.shop_name = [aDecoder decodeObjectForKey:@"shop_name"];
        self.shop_title = [aDecoder decodeObjectForKey:@"shop_title"];
        self.shop_desc = [aDecoder decodeObjectForKey:@"shop_desc"];
        self.shop_keywords = [aDecoder decodeObjectForKey:@"shop_keywords"];
        self.shop_address = [aDecoder decodeObjectForKey:@"shop_address"];
        self.qq = [aDecoder decodeObjectForKey:@"qq"];
        self.ww = [aDecoder decodeObjectForKey:@"ww"];
        self.service_email = [aDecoder decodeObjectForKey:@"service_email"];
        self.service_phone = [aDecoder decodeObjectForKey:@"service_phone"];
        self.shop_closed = [aDecoder decodeObjectForKey:@"shop_closed"];
        self.close_comment = [aDecoder decodeObjectForKey:@"close_comment"];
        self.shop_logo = [aDecoder decodeObjectForKey:@"shop_logo"];
        self.shop_notice = [aDecoder decodeObjectForKey:@"shop_notice"];
        self.icp_number = [aDecoder decodeObjectForKey:@"icp_number"];

    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.shop_name forKey:@"shop_name"];
    [aCoder encodeObject:self.shop_title forKey:@"shop_title"];
    [aCoder encodeObject:self.shop_desc forKey:@"shop_desc"];
    [aCoder encodeObject:self.shop_keywords forKey:@"shop_keywords"];
    [aCoder encodeObject:self.shop_address forKey:@"shop_address"];
    [aCoder encodeObject:self.qq forKey:@"qq"];
    [aCoder encodeObject:self.ww forKey:@"ww"];
    [aCoder encodeObject:self.service_email forKey:@"service_email"];
    [aCoder encodeObject:self.service_phone forKey:@"service_phone"];
    [aCoder encodeObject:self.close_comment forKey:@"close_comment"];
    [aCoder encodeObject:self.shop_closed forKey:@"shop_closed"];
    [aCoder encodeObject:self.shop_logo forKey:@"shop_logo"];
    [aCoder encodeObject:self.shop_notice forKey:@"shop_notice"];
    [aCoder encodeObject:self.icp_number forKey:@"icp_number"];
}

+ (TotalInfoModel *)parseDicToTotalInfoModelObject:(NSDictionary*)dic
{
    TotalInfoModel *model = [[TotalInfoModel alloc]init];
    
    model.shop_name = CHECK_VALUE([dic objectForKey:@"shop_name"]);
    model.shop_title = CHECK_VALUE([dic objectForKey:@"shop_title"]);
    model.shop_desc = CHECK_VALUE([dic objectForKey:@"shop_desc"]);
    model.shop_keywords = CHECK_VALUE([dic objectForKey:@"shop_keywords"]);
    model.shop_address = CHECK_VALUE([dic objectForKey:@"shop_address"]);
    model.qq = CHECK_VALUE([dic objectForKey:@"qq"]);
    model.ww = CHECK_VALUE([dic objectForKey:@"ww"]);
    model.service_email = CHECK_VALUE([dic objectForKey:@"service_email"]);
    model.service_phone = CHECK_VALUE([dic objectForKey:@"service_phone"]);
    model.shop_closed = CHECK_VALUE([dic objectForKey:@"shop_closed"]);
    model.close_comment = CHECK_VALUE([dic objectForKey:@"close_comment"]);
    model.shop_logo = CHECK_VALUE([dic objectForKey:@"shop_logo"]);
    model.shop_notice = CHECK_VALUE([dic objectForKey:@"shop_notice"]);
    model.icp_number = CHECK_VALUE([dic objectForKey:@"icp_number"]);
    
    return model;
}

@end
