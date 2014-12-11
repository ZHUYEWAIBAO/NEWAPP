//
//  ForgetPwdCodeVC.h
//  WomenHealthApp
//
//  Created by 朱青 on 14/12/10.
//  Copyright (c) 2014年 WomenHealthApp. All rights reserved.
//

#import "BasicVC.h"

@interface ForgetPwdCodeVC : BasicVC

/**
 *  手机号输入框
 */
@property (weak,nonatomic) IBOutlet UITextField *phoneNumTextField;

@property (weak,nonatomic) IBOutlet UIButton *getVerCodeBtn;

@property (weak,nonatomic) IBOutlet UIImageView *textBgImageView;

@end
