//
//  PasswordSetVC.h
//  YueDongApp
//
//  Created by 朱 青 on 14-8-5.
//  Copyright (c) 2014年 朱 青. All rights reserved.
//

#import "BasicVC.h"
#import "RegisterModel.h"

@interface PasswordSetVC : BasicVC

/**
 *  注册数据类
 */
@property (strong,nonatomic) RegisterModel *registerModel;

@property (strong,nonatomic) NSString *vertifiCode;

/**
 *  密码输入框
 */
@property (weak,nonatomic) IBOutlet UITextField *passwordTextField;

@property (weak,nonatomic) IBOutlet UIImageView *textBgImageView;

@end
