//
//  RegisterViewController.m
//  YueDongApp
//
//  Created by 朱 青 on 14-8-5.
//  Copyright (c) 2014年 朱 青. All rights reserved.
//

#import "RegisterViewController.h"
#import "RegisterProtocolVC.h"
#import "VericationCodeVC.h"
#import "RegisterModel.h"

#define btn_getVericationCode 100      //获取验证码
#define btn_registerProtocol 101       //注册协议
#define btn_readProtocol 102           //已阅读协议

@interface RegisterViewController ()<UITextFieldDelegate>
{
    /**
     *  判断是否已阅读注册协议
     */
    BOOL isReadProtocol;
}

@end

@implementation RegisterViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)loadView
{
    [super loadView];
    
    self.title = @"注册";
    
//    self.textFieldNum = 1;
    self.phoneNumTextField.tag = 1;
    
    isReadProtocol = YES;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setViewLayer:self.textBgImageView andCornerRadius:3 andBorderColor:[UIColor lightGrayColor] andBorderWidth:0.6f];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    self.view.backgroundColor = [UIColor whiteColor];
}

//验证手机号码
- (void)checkPhoneNumberAndGetVericationCode
{
    if (self.phoneNumTextField.text.length == 0) {
        
        [SVProgressHUD showErrorWithStatus:@"手机号码不能为空"];
        
        return;
    }

    if (!isReadProtocol) {
        
        [SVProgressHUD showErrorWithStatus:@"您必须同意舒服用户协议才能进行下一步操作"];
        
        return;
    }
    
    [self getVerificationCodeAction];
    
}

//获取验证码
- (void)getVerificationCodeAction
{
    [SVProgressHUD showWithStatus:@"正在获取验证码" maskType:SVProgressHUDMaskTypeClear];
    
    NSString *path = [NSString stringWithFormat:@"/api/ec/user.php?mod=code&phone=%@&type=register",self.phoneNumTextField.text];
    
    [NETWORK_ENGINE requestWithPath:path Params:self.params CompletionHandler:^(MKNetworkOperation *completedOperation) {
        
        NSDictionary *dic=[completedOperation responseDecodeToDic];
        
        NSDictionary *statusDic = [dic objectForKey:@"status"];
        
        if ([@"1" isEqualToString:CHECK_VALUE([statusDic objectForKey:@"statu"])]){

            [SVProgressHUD showSuccessWithStatus:CHECK_VALUE([statusDic objectForKey:@"msg"])];
            
            RegisterModel *model = [[RegisterModel alloc]init];
            model.registerPhoneNum = self.phoneNumTextField.text;

            VericationCodeVC *vc = [[VericationCodeVC alloc]initWithNibName:@"VericationCodeVC" bundle:nil];
            vc.registerModel = model;
            [self.navigationController pushViewController:vc animated:YES];
            
        }
        else{
            [SVProgressHUD showErrorWithStatus:CHECK_VALUE([statusDic objectForKey:@"msg"])];
        }

    } ErrorHandler:^(MKNetworkOperation *completedOperation, NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"服务器忙，请稍候再试"];
    }];
}

- (IBAction)btnClickAction:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    
    switch (btn.tag) {
        case btn_getVericationCode:{
            [self.phoneNumTextField resignFirstResponder];
            [self checkPhoneNumberAndGetVericationCode];
        }
            break;
        
        case btn_registerProtocol:{
            
            RegisterProtocolVC *vc = [[RegisterProtocolVC alloc]initWithNibName:@"RegisterProtocolVC" bundle:nil];
            [self.navigationController pushViewController:vc animated:YES];
            
        }
            break;
        
        case btn_readProtocol:{
            
            if (!isReadProtocol) {
                isReadProtocol = YES;

                [self.readProtocolImageView setImage:[UIImage imageWithContentFileName:@"icon_choose_selected"]];
            }
            else{
                isReadProtocol = NO;
                
                [self.readProtocolImageView setImage:[UIImage imageWithContentFileName:@"icon_choose_normal"]];

            }
            
        }
            break;
            
        default:
            break;
    }

}

#pragma mark --UITextFiled的观察者方法
-(void)textFiledEditChanged:(NSNotification *)obj
{
    UITextField *textField = (UITextField *)obj.object;

    if (textField == self.phoneNumTextField) {
        
        if ([self.phoneNumTextField.text isValidatePhoneNum]) {
            [self.getVerCodeBtn setEnabled:YES];
        }
        else{
            [self.getVerCodeBtn setEnabled:NO];
        }
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
