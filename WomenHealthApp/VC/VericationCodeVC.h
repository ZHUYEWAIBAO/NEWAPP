//
//  VericationCodeVC.h
//  YueDongApp
//
//  Created by 朱 青 on 14-8-5.
//  Copyright (c) 2014年 朱 青. All rights reserved.
//

#import "BasicVC.h"
#import "RegisterModel.h"

@interface VericationCodeVC : BasicVC

/**
 *  注册数据类
 */
@property (strong,nonatomic) RegisterModel *registerModel;

/**
 *  验证码输入框
 */
@property (weak,nonatomic) IBOutlet UITextField *verificationTextField;

/**
 *  获取验证码
 */
@property (weak,nonatomic) IBOutlet UIButton *verificationBtn;

/**
 *  验证码提示
 */
@property (weak,nonatomic) IBOutlet UILabel *alertLabel;

@property (weak,nonatomic) IBOutlet UIImageView *textBgImageView;

@end
