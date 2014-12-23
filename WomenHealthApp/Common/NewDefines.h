//
//  NewDefines.h
//  WomenHealthApp
//
//  Created by 朱 青 on 14-11-15.
//  Copyright (c) 2014年 WomenHealthApp. All rights reserved.
//

#import "UIImage+imageContent.h"
#import "NSString+Category.h"
#import "UITableViewCell+Category.h"
#import "UINavigationBar+customBar.h"
#import "RequestNetworkEngine.h"
#import "Global.h"
#import "SVProgressHUD.h"
#import "CommonMethod.h"
#import "UIButton+WebCache.h"
#import "UIImageView+WebCache.h"
#import "CustomItoast.h"
#import "WHSinger.h"
#import "UserInfo.h"
#import "CMSinger.h"
#import "OMGToast.h"
#ifndef WomenHealthApp_NewDefines_h
#define WomenHealthApp_NewDefines_h

//在release版本禁止输出NSLog内容
//发布版本时注释 #define IOS_DEBUG
#define IOS_DEBUG
#ifdef IOS_DEBUG
#define NSLog(...) NSLog(__VA_ARGS__)
#else
#define NSLog(...){}
#endif

//当前屏幕大小
#define SCREEN_SIZE   [[UIScreen mainScreen] bounds].size

//判断设备为4寸屏幕
#define RETINA_4 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)

//判断ios7
#define IOS7 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)

//=============观察者==================
#define NOTIFICATION_ACTIVE                          @"NOTIFICATION_ACTIVE"     //从后台唤醒APP
#define NOTIFICATION_USER_LOGIN                      @"NOTIFICATION_USER_LOGIN" //用户登录之后
#define NOTIFICATION_DETAIL_CHANGE                   @"NOTIFICATION_DETAIL_CHANGE" //编辑个人信息
#define NOTIFICATION_REFRESH_ORDERRECORD             @"NOTIFICATION_REFRESH_ORDERRECORD" //刷新订单记录列表
#define NOTIFICATION_SHOP_SELECT                     @"NOTIFICATION_SHOP_SELECT" //购物筛选
#define NOTIFICATION_ADDRESS_REQUEST                 @"NOTIFICATION_ADDRESS_REQUEST" //收货地址保存
#define NOTIFICATION_ADDRESS_SELECT                  @"NOTIFICATION_ADDRESS_SELECT" //收货地址选择
#define NOTIFICATION_PAYTYPE_SELECT                  @"NOTIFICATION_PAYTYPE_SELECT" //支付方式选择
//====================================

//全局变量
#define GLOBALSHARE [Global share]

//公共方法
#define COMMONDSHARE [CommonMethod share]

//用户中心
#define USERINFO [UserInfo share]

//RGB取色值
#define RGBACOLOR(r,g,b,a) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:(a)]
//220 101  108
#define FENSERGB RGBACOLOR(220,101,108,1)

//当前屏幕大小
#define SCREEN_SIZE   [[UIScreen mainScreen] bounds].size

//获取当前APP版本
#define CLIENT_VERSION [[[NSBundle mainBundle] infoDictionary]objectForKey:@"CFBundleShortVersionString"]

#define MAIN_RED_COLOR RGBACOLOR(254,111,117,1.0)

//搜索本地保存的key
#define GOODS_SEARCH_KEY @"goodsSearchKey"

/**
 *  检查数据有效性
 */
#define CHECK_VALUE(value) NSStringExchangeTheReturnValueToString(value)

/**
 *  检查数组有效性
 */
#define CHECK_ARRAY_VALUE(value) NSArrayexchangeTheReturnValueToArray(value)

//网络请求
#define NETWORK_ENGINE ([RequestNetworkEngine share])

#define TEST_NETWORK_ENGINE ([totalTestNetworkEngine share])

#endif

