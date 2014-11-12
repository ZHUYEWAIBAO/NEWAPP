//
//  CommonMethod.h
//  YueDongApp
//
//  Created by 朱 青 on 14-8-2.
//  Copyright (c) 2014年 朱 青. All rights reserved.
//

#import <Foundation/Foundation.h>

//把返回字段转换成string类型
NSString * NSStringExchangeTheReturnValueToString(id value);

//把返回字段转换成NSArray类型
NSArray * NSArrayexchangeTheReturnValueToArray(id value);

/**
 @method 获取字符串value的宽度
 @param value 待计算的字符串
 @param fontSize 字体的大小
 @param andWidth 限制字符串显示区域的宽度
 @result float 返回的宽度
 */
float HeightForString(NSString *value,float fontSize,float width);

/**
 *  显示用户手机号，中间几位用星号代替
 *
 *  @param value 手机全号码
 *
 *  @return 显示用户手机号，中间几位用星号代替
 */
NSString * NSStringShowUserPhoneNumber(NSString *numString);

/**
 *  调整图片大小
 *
 *  @param img  选取的图片
 *  @param size 上传的尺寸
 *
 *  @return 返回一张上传到图片
 */
UIImage * UIImageScaleToSize(UIImage *img, CGSize size);

@interface CommonMethod : NSObject

@end
