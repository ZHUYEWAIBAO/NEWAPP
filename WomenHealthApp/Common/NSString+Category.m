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
- (BOOL)isValidateNiCheng
{

    NSString *niChengRegex =[NSString stringWithFormat:@"^[a-zA-Z0-9_\u4e00-\u9fa5]+$"];
    
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

@end
