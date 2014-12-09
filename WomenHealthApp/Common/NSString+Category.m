//
//  NSString+Category.m
//  YueDongApp
//
//  Created by 朱 青 on 14-8-5.
//  Copyright (c) 2014年 朱 青. All rights reserved.
//

#import "NSString+Category.h"

@implementation NSString (Category)

//昵称表达式
- (BOOL)isValidatePhoneNum
{

    NSString *niChengRegex =[NSString stringWithFormat:@"^(13[0-9]|15[0|1|2|3|5|6|7|8|9]|18[0|5|6|7|8|9])\\d{8}$"];
    
    NSPredicate *regex = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",niChengRegex];
    
    return [regex evaluateWithObject:self];
}

- (NSString *)priceStringWithUnit:(BOOL)unit
{
    if (self.length == 0) {
        return @"";
    }
    CGFloat price = [self floatValue];
    if (unit) {
        return [NSString stringWithFormat:@"¥%g",price];
    }
    else{
        return [NSString stringWithFormat:@"%g",price];
    }
}

//是否包含特殊字符
- (BOOL)contains:(NSString *)subString
{
    NSRange range = [self rangeOfString:subString];
    return range.location != NSNotFound;
}

+ (NSString *)priceStringWithOneFloat:(NSString *)priceStr
{
    if (priceStr.length == 0) {
        return @"";
    }
    CGFloat price = [priceStr floatValue];
    
    return [NSString stringWithFormat:@"¥%.1f",price];
    
}

@end
