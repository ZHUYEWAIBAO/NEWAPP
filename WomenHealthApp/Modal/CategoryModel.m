//
//  CategoryModel.m
//  WomenHealthApp
//
//  Created by 朱青 on 14/12/5.
//  Copyright (c) 2014年 WomenHealthApp. All rights reserved.
//

#import "CategoryModel.h"

@implementation CategoryModel

+(CategoryModel *)parseDicToCategoryModelObject:(NSDictionary*)dic
{
    CategoryModel *model = [[CategoryModel alloc]init];
    
    model.category_cid = CHECK_VALUE([dic objectForKey:@"cid"]);
    model.category_name = CHECK_VALUE([dic objectForKey:@"name"]);
    
    return model;
}

@end
