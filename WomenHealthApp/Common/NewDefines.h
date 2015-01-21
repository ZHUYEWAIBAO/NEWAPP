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
#define NOTIFICATION_ALIPAY                          @"NOTIFICATION_ALIPAY"     //支付宝支付完成回调
#define NOTIFICATION_USER_LOGIN                      @"NOTIFICATION_USER_LOGIN" //用户登录之后
#define NOTIFICATION_DETAIL_CHANGE                   @"NOTIFICATION_DETAIL_CHANGE" //编辑个人信息
#define NOTIFICATION_REFRESH_ORDERRECORD             @"NOTIFICATION_REFRESH_ORDERRECORD" //刷新订单记录列表
#define NOTIFICATION_SHOP_SELECT                     @"NOTIFICATION_SHOP_SELECT" //购物筛选
#define NOTIFICATION_ADDRESS_REQUEST                 @"NOTIFICATION_ADDRESS_REQUEST" //收货地址保存
#define NOTIFICATION_ADDRESS_SELECT                  @"NOTIFICATION_ADDRESS_SELECT" //收货地址选择
#define NOTIFICATION_PAYTYPE_SELECT                  @"NOTIFICATION_PAYTYPE_SELECT" //支付方式选择
#define NOTIFICATION_IMAGE_DELETE                    @"NOTIFICATION_IMAGE_DELETE" //删除图片
//====================================




//===============支付宝支付================
#define ALI_PARTNER                                  @"2088711759508470"
#define ALI_SELLTER                                  @"najitian@163.com"
#define ALI_PRIVATE_KEY                           @"MIICeAIBADANBgkqhkiG9w0BAQEFAASCAmIwggJeAgEAAoGBAMJqjq1anScc/rW4WBdtqw4v11xsHd487Dbd13El3qvE/QM0v9l7Q5le1SlJGz0bF4NJl3xOf7wTLujnhkt7TdKUCmqp97YJsafcKk+/n67i7I1M5SBo2UjBvleL+FgCBbb5lWTxZcFN+lKk2xc6IETvrAWrpAhav+KSdfxlYXvJAgMBAAECgYARmOuJLWaEH8++Sw1OMZMGGbZ4myCo+QK4hKP3jeH10kLEg4XJ/apEu5y3u/JHOaiLLaIUklZlg6b/VdWGB4cnm+HBUtBlGgi0uNuQBdC3wMNJj5QTIavCAWag/KQ2Xssr7/YtR9ayu9sYPTMOZGlXak73UwgRZqwVsiMW5az+wQJBAOyrDYCvsnrYtz+/iSNkPuvKA8K0KPp6nPZ4ICaQ1vVkgY6pTJ0GbFaOjgEUHyRWyCXw2Zr6VxTyDw+eB6KIlx0CQQDSS/plc90hf79YkF6huWJv1wAuSQRNcl0zVq9mj5hldsxT30RvIT/L107l7BnFAs5H/QsuNSc6hPahXS0tA9udAkEAwUeIxXm3lx/5t/QieWbbBBF9NLuRY85S9e5ww04yX0HvlKSqzup5+858JmFadYDyABpMfIbKK27r4eM7dP97+QJBAKdPtZbz2LInPehLbE7E/JE4gDdS9m5bl9UZmZFCm5/WJXhxQLQdwvD9ixMYheQdeFsD8to/hcdkNAhr5l5THG0CQQCHTdfLQFE5yv0eq2uIemCNv/nzRzliD7siZy3uF/9Nmx+TH/p7aEysT61zsDaiJ5vPxzSA6TI7mCGBdCpEFx9M"

#define ALI_CALLBACK_URL                             @"http://123.57.46.174/api/ec/alipay/notify_url.php"
//=======================================

#define RecordHealthId  @"RecordHealthId"

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

