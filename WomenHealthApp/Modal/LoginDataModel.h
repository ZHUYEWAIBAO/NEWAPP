//
//  LoginDataModel.h
//  YueDongApp
//
//  Created by 朱 青 on 14-8-7.
//  Copyright (c) 2014年 朱 青. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LoginDataModel : NSObject

@property (strong, nonatomic) NSString * loginPhoneNum;              //登录手机号码
@property (strong, nonatomic) NSString * loginPassword;              //登录密码
@property (strong, nonatomic) NSString * thirdUid;                   
@property (strong, nonatomic) NSString * loginType;

/**
 *  根据是否记住手机号和密码字段保存登录数据
 *
 *  @param phoneNum   登录手机号码
 *  @param password   登录密码
 *  @param isRemember 是否记住手机号和密码字段
 *
 *  @return 登录数据
 */
+ (LoginDataModel *)rememberLoginPhoneNum:(NSString *)phoneNum andPassword:(NSString *)password andThirdUid:(NSString *)thirdUid andLoginType:(NSString *)loginType remember:(BOOL)isRemember;

@end
