//
//  NSString+Category.h
//  YueDongApp
//
//  Created by 朱 青 on 14-8-5.
//  Copyright (c) 2014年 朱 青. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Category)

/*
 *@prama 价格规范化 以元为单位
 *unit YES:带¥符号 NO:不带
 */
- (NSString *)priceStringWithUnit:(BOOL)unit;

/**
 *  是否包含substring字符
 */
- (BOOL)contains:(NSString *)subString;

//昵称表达式
- (BOOL)isValidateNiCheng;

@end
