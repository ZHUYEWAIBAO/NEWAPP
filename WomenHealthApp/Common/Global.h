//
//  Global.h
//  YueDongApp
//
//  Created by 朱 青 on 14-8-1.
//  Copyright (c) 2014年 朱 青. All rights reserved.
//

#import <Foundation/Foundation.h>

#define REAL_SERVER_HOST @"123.57.46.174"

@interface Global : NSObject

//正式服务器地址
@property (nonatomic,strong) NSString * SERVER_HOST;

//=======================圈子模块=============================
//圈子大分类
@property (nonatomic,strong) NSString * CIRCLE_BIGMENU_PATH;


//调查问卷题目
@property(nonatomic,strong)   NSString *CIRCLE_SURVEY;
//调查问卷答案
@property(nonatomic,strong)   NSString *CIRCLE_ASNWER;
//===========================================================

//=======================订单模块=============================
//单个订单
@property (nonatomic,strong) NSString * ORDER_SCAN_PATH;

//订单信息
@property (nonatomic,strong) NSString * ORDER_DETAIL_PATH;

//订单支付
@property (nonatomic,strong) NSString * ORDER_PAY_PATH;

//银联支付回调
@property (nonatomic,strong) NSString * ORDER_PAY_BACK_PATH;

//订单记录
@property (nonatomic,strong) NSString * ORDER_RECORD_PATH;

//申请退款
@property (nonatomic,strong) NSString * ORDER_REFUND_PATH;

//团购券
@property (nonatomic,strong) NSString * GB_LIST_PATH;
//===========================================================

//=======================用户模块=============================
//注册校验手机号
@property (nonatomic,strong) NSString * USER_CHECKPHONENUM_PATH;

//注册验证码请求
@property (nonatomic,strong) NSString * USER_VERIFICATIONCODE_PATH;

//用户注册
@property (nonatomic,strong) NSString * USER_REGISTER_PATH;

//用户登录
@property (nonatomic,strong) NSString * USER_LOGIN_PATH;

//获取用户信息
@property (nonatomic,strong) NSString * USER_INFO_PATH;

//用户退出登录
@property (nonatomic,strong) NSString * USER_LOGINOUT_PATH;

//修改昵称
@property (nonatomic,strong) NSString * USER_CHANGENAME_PATH;

//修改密码
@property (nonatomic,strong) NSString * USER_CHANGEPASSWORD_PATH;

//上传用户头像
@property (nonatomic,strong) NSString * USER_HEADPIC_PATH;

//找回密码验证码请求
@property (nonatomic,strong) NSString * USER_FINDVERIFICATIONCODE_PATH;

//重设密码
@property (nonatomic,strong) NSString * USER_RESETPASSWORD_PATH;



//============================================================

//获取最新版本信息
@property (nonatomic,strong) NSString * SET_NEWVERSION_PATH;

/**
 单例
 @returns
 */
+(Global *)share;

@end
