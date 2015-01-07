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

/**
 *@日期格式转换函数
 *date所要转化的日期 输入date格式为"yyyyMMddHHmmss"
 *type转化的格式  1:输出@"yyyy-MM-dd HH:mm:ss"
 *              2:输出@"yyyy-MM-dd"
 *              3:距离1970的时间戳输入date为时间戳 输出@"yyyy-MM-dd"
 *              4:输出@"yyyy年MM月dd日"
 *              5:输出@"yyyy-MM-dd HH:mm"
 **/
- (NSString *)switchDateReturnType:(NSUInteger)type
{
    if(self.length ==0){
        return @"";
    }
    NSString* string = self;
    NSDateFormatter *inputFormatter = [[NSDateFormatter alloc] init];
    [inputFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"] ];
    [inputFormatter setDateFormat:@"yyyyMMddHHmmss"];
    NSDate* inputDate = [inputFormatter dateFromString:string];
    if (type == 3) {//时间戳转换成具体时间
        inputDate = [NSDate dateWithTimeIntervalSince1970:[string longLongValue]];
    }
    NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
    [outputFormatter setLocale:[NSLocale currentLocale]];
    if (type == 1) {
        [outputFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    }
    else if(type == 2){
        [outputFormatter setDateFormat:@"yyyy-MM-dd"];
    }
    else if(type == 3){
        [outputFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    }
    else if(type == 4){
        [outputFormatter setDateFormat:@"yyyy年MM月dd日"];
    }
    else if(type == 5){
        [outputFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    }
    else if(type == 6){
        [outputFormatter setDateFormat:@"M月dd日"];
    }
    else if(type == 7){
        [outputFormatter setDateFormat:@"HH:mm:ss"];
    }
    NSString *str = [outputFormatter stringFromDate:inputDate];
    return str;
    
}

@end
