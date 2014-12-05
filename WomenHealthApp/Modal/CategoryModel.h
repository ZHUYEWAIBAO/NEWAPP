//
//  CategoryModel.h
//  WomenHealthApp
//
//  Created by 朱青 on 14/12/5.
//  Copyright (c) 2014年 WomenHealthApp. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CategoryModel : NSObject

@property (strong, nonatomic) NSString * category_cid;
@property (strong, nonatomic) NSString * category_name;

+(CategoryModel *)parseDicToCategoryModelObject:(NSDictionary*)dic;

@end
