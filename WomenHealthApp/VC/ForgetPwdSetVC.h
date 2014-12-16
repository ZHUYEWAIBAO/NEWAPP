//
//  ForgetPwdSetVC.h
//  WomenHealthApp
//
//  Created by 朱青 on 14/12/10.
//  Copyright (c) 2014年 WomenHealthApp. All rights reserved.
//

#import "BasicVC.h"

@interface ForgetPwdSetVC : BasicVC

@property (strong, nonatomic) NSString *phoneNum;

@property (weak, nonatomic) IBOutlet UIView *pwdView;

@property (weak,nonatomic) IBOutlet UITextField *codeTextField;
@property (weak,nonatomic) IBOutlet UITextField *firstPwdField;
@property (weak,nonatomic) IBOutlet UITextField *secondPwdField;

@end
