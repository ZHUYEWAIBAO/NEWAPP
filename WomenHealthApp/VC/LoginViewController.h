//
//  LoginViewController.h
//  WomenHealthApp
//
//  Created by 朱青 on 14/11/27.
//  Copyright (c) 2014年 WomenHealthApp. All rights reserved.
//

#import "BasicVC.h"

//登录方式
typedef enum LoginType_
{
    loginType_qq = 1,     //qq登录
    loginType_sina,       //新浪微博登录
    loginType_mobile,     //手机号登录
}LoginType;

@interface LoginViewController : BasicVC

@property (strong, nonatomic) IBOutlet UIButton *forgetBtn;

@property (assign, nonatomic) LoginType loginType;

/**
 *  手机号输入框
 */
@property (weak,nonatomic) IBOutlet UITextField *userNumTextField;

/**
 *  密码输入框
 */
@property (weak,nonatomic) IBOutlet UITextField *userPwdTextField;

@end
