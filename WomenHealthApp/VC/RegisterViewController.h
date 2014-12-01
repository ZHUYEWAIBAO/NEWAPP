//
//  RegisterViewController.h
//  YueDongApp
//
//  Created by 朱 青 on 14-8-5.
//  Copyright (c) 2014年 朱 青. All rights reserved.
//

#import "BasicVC.h"

@interface RegisterViewController : BasicVC

/**
 *  手机号输入框
 */
@property (weak,nonatomic) IBOutlet UITextField *phoneNumTextField;

/**
 *  阅读协议按钮
 */
@property (weak,nonatomic) IBOutlet UIButton *readProtocolBtn;

@property (weak,nonatomic) IBOutlet UIImageView *readProtocolImageView;

@property (weak,nonatomic) IBOutlet UIImageView *textBgImageView;

@end
