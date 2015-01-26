//
//  CommonMethod.m
//  YueDongApp
//
//  Created by 朱 青 on 14-8-2.
//  Copyright (c) 2014年 朱 青. All rights reserved.
//

#import "CommonMethod.h"

NSString *NSStringExchangeTheReturnValueToString(id value)
{
    if ([value isKindOfClass:[NSString class]]) {
        if ([value isEqualToString:@"<null>"]||[value isEqualToString:@"<NULL>"]) {
            return @"";
        }
        else if([value isEqualToString:@"(null)"]||[value isEqualToString:@"(NULL)"]){
            return @"";
        }
        return (NSString *)value;
    }
    else if([value isKindOfClass:[NSNumber class]]) {
        return [value stringValue];
    }
    else if([value isKindOfClass:[NSNull class]]) {
        return @"";
    }
    else if(value == nil) {
        return @"";
    }
    else{
        return @"";
    }
}

//判断返回字段是否为Array类型  防止crash
NSArray *NSArrayexchangeTheReturnValueToArray(id value)
{
    if (value) {
        
        if ([value isKindOfClass:[NSNull class]]) {
            
            return [NSArray array];
            
        }
        
        return (NSArray *)value;
        
    }
    
    return [NSArray array];
    
}

float HeightForString(NSString *value,float fontSize,float width)
{
    CGSize sizeToFit = [value sizeWithFont:[UIFont systemFontOfSize:fontSize] constrainedToSize:CGSizeMake(width, CGFLOAT_MAX) lineBreakMode:NSLineBreakByWordWrapping];//此处的换行类型（lineBreakMode）可根据自己的实际情况进行设置

    return sizeToFit.height;
}

float WidthForString(NSString *value,float fontSize,float height)
{
    CGSize sizeToFit = [value sizeWithFont:[UIFont systemFontOfSize:fontSize] constrainedToSize:CGSizeMake(CGFLOAT_MAX, height) lineBreakMode:NSLineBreakByWordWrapping];//此处的换行类型（lineBreakMode）可根据自己的实际情况进行设置
    
    return sizeToFit.width;
}

NSString *NSStringShowUserPhoneNumber(NSString *numString)
{
    if (numString.length>7) {
        
        NSString *showNum = [numString stringByReplacingCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
        return showNum;
        
    }
    else{
        return numString;
    }
}

UIImage * UIImageScaleToSize(UIImage *img, CGSize size)
{
    // 创建一个bitmap的context
    // 并把它设置成为当前正在使用的context
    UIGraphicsBeginImageContext(size);
    // 绘制改变大小的图片
    [img drawInRect:CGRectMake(0, 0, size.width, size.height)];
    // 从当前context中创建一个改变大小后的图片
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    // 使当前的context出堆栈
    UIGraphicsEndImageContext();
    // 返回新的改变大小后的图片
    return scaledImage;
}

void SaveTheUserPhoneNumAndPassword(LoginDataModel *loginModel)
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:loginModel];
    [userDefaults setObject:data forKey:@"userLoginModel"];
    //将数据即时写入
    [userDefaults synchronize];
}

LoginDataModel * GetTheSavedUserPhoneNumAndPassword()
{
    NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
    
    NSData *data = [defaults objectForKey:@"userLoginModel"];
    
    LoginDataModel *loginInfo = (LoginDataModel *)[NSKeyedUnarchiver unarchiveObjectWithData:data];;
    
    return loginInfo;
    
}

void SaveTheAppTotalInfoModel(TotalInfoModel *loginModel)
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:loginModel];
    [userDefaults setObject:data forKey:@"totalInfoModel"];
    //将数据即时写入
    [userDefaults synchronize];
}

TotalInfoModel * GetTheAppTotalInfoModel()
{
    NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
    
    NSData *data = [defaults objectForKey:@"totalInfoModel"];
    
    TotalInfoModel *loginInfo = (TotalInfoModel *)[NSKeyedUnarchiver unarchiveObjectWithData:data];
    
    return loginInfo;
}

@implementation CommonMethod

+ (CommonMethod *)share
{
    static CommonMethod *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[CommonMethod alloc]init];
    });
    
    return manager;
}

- (void)saveTheRecordKey:(NSString *)recordKey
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:CHECK_VALUE(recordKey) forKey:RecordHealthId];
    //将数据即时写入
    [userDefaults synchronize];

}

- (NSString *)getTheLocalAddressKey
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];

    return [userDefaults objectForKey:@"RecordHealthId"];
}

- (NSInteger)getDayNumberWithYear:(NSInteger)year month:(NSInteger)month
{
    NSInteger days[] = { 31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31 };
    if (2 == month && 0 == (year % 4) && (0 != (year % 100) || 0 == (year % 400))) {
        days[1] = 29;
    }

    return (days[month - 1]);
}

@end
