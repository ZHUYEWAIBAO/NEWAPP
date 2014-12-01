//
//  UserInfo.h
//  YueDongApp
//
//  Created by 朱 青 on 14-8-5.
//  Copyright (c) 2014年 朱 青. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserInfo : NSObject

@property (strong, nonatomic) NSString * uid;            //用户id
@property (strong, nonatomic) NSString * username;       //用户名(手机号)
@property (strong, nonatomic) NSString * user_icon;       //用户头像
//@property (strong, nonatomic) NSString * nicheng;        //用户昵称
//@property (strong, nonatomic) NSString * lastlogintime;  //用户最后登录时间
//@property (strong, nonatomic) NSString * email;          //用户邮箱
//@property (strong, nonatomic) NSString * realname;       //用户真实姓名
//@property (strong, nonatomic) NSString * money;          //用户悦动币余额
@property (assign, nonatomic) BOOL isLogin;              //判断用户是否登录

/**
 单例
 @returns
 */
+(UserInfo *) share;

/**
 *  解析用户数据
 *
 *  @param dic 登录接口返回的json数据
 */
- (void)parseDicToUserInfoModel:(NSDictionary*)dic;

/**
 *  退出登录时，清除用户信息
 */
- (void)loginOutForUserInfoModel;

@end
