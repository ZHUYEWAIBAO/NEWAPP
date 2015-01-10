//
//  UserInfo.h
//  YueDongApp
//
//  Created by 朱 青 on 14-8-5.
//  Copyright (c) 2014年 朱 青. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserInfo : NSObject

@property (strong, nonatomic) NSString * uid;             //用户id
@property (strong, nonatomic) NSString * username;        //用户名(手机号)
@property (strong, nonatomic) NSString * user_icon;       //用户头像
@property (strong, nonatomic) NSString * thirdId;         //如果是第三方登录，第三方登录的uid
@property (strong, nonatomic) NSString * loginType;       //登录方式
@property (assign, nonatomic) BOOL isLogin;               //判断用户是否登录

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
