//
//  PayTypeModel.m
//  WomenHealthApp
//
//  Created by 朱青 on 14/12/14.
//  Copyright (c) 2014年 WomenHealthApp. All rights reserved.
//

#import "PayTypeModel.h"

@implementation PayTypeModel

+ (NSMutableArray *)arrayForPayType
{

    PayTypeModel *sevenModel = [[PayTypeModel alloc]init];
    sevenModel.payTypeId = @"4";
    sevenModel.payTypeName = @"支付宝支付";
    
    PayTypeModel *sixthModel = [[PayTypeModel alloc]init];
    sixthModel.payTypeId = @"5";
    sixthModel.payTypeName = @"微信支付";

    
    NSMutableArray *secondArray = [NSMutableArray arrayWithObjects:sevenModel,sixthModel,nil];

    
    return secondArray;

}

@end
