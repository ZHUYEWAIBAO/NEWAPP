//
//  CommonMethod.h
//  YueDongApp
//
//  Created by 朱 青 on 14-8-2.
//  Copyright (c) 2014年 朱 青. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LoginDataModel.h"
#import "TotalInfoModel.h"

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
float WidthForString(NSString *value,float fontSize,float height);

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

/**
 *  本地保存用户登录手机号和密码
 *
 *  @param numString 登录手机号码
 *  @param pwdString 登录密码
 */
void SaveTheUserPhoneNumAndPassword(LoginDataModel *loginModel);

/**
 *  获取本地保存的用户登录数据
 *
 *  @return 登录数据类
 */
LoginDataModel * GetTheSavedUserPhoneNumAndPassword();

void SaveTheAppTotalInfoModel(TotalInfoModel *loginModel);
TotalInfoModel * GetTheAppTotalInfoModel();

@interface CommonMethod : NSObject

+(CommonMethod *)share;
/**
 *  本地保存有记录过经期
 */
- (void)saveTheRecordKey:(NSString *)recordKey;
- (NSString *)getTheLocalAddressKey;

/**
 *  保存已展示引导图
 */
- (void)saveTheGuideKey:(BOOL)isShowGuide;
- (BOOL)getTheLocalGuideKey;

/**
 *  获取当前月份的天数
 *
 *  @param year  当前年数
 *  @param month 当前月数
 *
 *  @return 当前月份的天数
 */
- (NSInteger)getDayNumberWithYear:(NSInteger)year month:(NSInteger)month;

@end
