//
//  VericationCodeVC.m
//  YueDongApp
//
//  Created by 朱 青 on 14-8-5.
//  Copyright (c) 2014年 朱 青. All rights reserved.
//

#import "VericationCodeVC.h"
#import "PasswordSetVC.h"

#define btn_regetvericationcode 100      //重新获取验证码
#define btn_checkvericationcode 101      //提交验证码

#define APP_VERCODE_LIMIT 60             //验证码倒计时60s

@interface VericationCodeVC ()
{
    NSTimer *verTimer;              //验证码计时器
    
    NSUInteger verTimeLimit;        //验证码计数
}
@end

@implementation VericationCodeVC

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
    self.verificationTextField.tag = 1;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setViewLayer:self.textBgImageView andCornerRadius:3 andBorderColor:[UIColor lightGrayColor] andBorderWidth:0.6f];
    
    [self setViewLayer:self.verificationBtn andCornerRadius:3 andBorderColor:[UIColor lightGrayColor] andBorderWidth:0.0f];
    
    verTimeLimit = APP_VERCODE_LIMIT;
    verTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateTimer) userInfo:nil repeats:YES];

    [self.alertLabel setText:[NSString stringWithFormat:@"验证码短信已发送到%@",NSStringShowUserPhoneNumber(self.registerModel.registerPhoneNum)]];
    
    //为了释放定时器，自定义返回按钮
    UIButton *leftButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 46, 25)];
    [leftButton addTarget:self action:@selector(leftBackClick:) forControlEvents:UIControlEventTouchUpInside];
    [leftButton setImage:[UIImage imageWithContentFileName:@"back_bt.png"] forState:UIControlStateNormal];
    UIBarButtonItem *leftButtonItem=[[UIBarButtonItem alloc]initWithCustomView:leftButton];
    self.navigationItem.leftBarButtonItem = leftButtonItem;
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)leftBackClick:(id)sender
{
    [verTimer invalidate];
    verTimer=nil;
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)btnClickAction:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    
    switch (btn.tag) {
        case btn_regetvericationcode:{
            [self getVerificationCodeAction];
        }
            break;
        
        case btn_checkvericationcode:{
            [self.verificationTextField resignFirstResponder];
            [self checkVericationCodeAction];
        }
            break;
            
        default:
            break;
    }
}

//校验验证码
- (void)checkVericationCodeAction
{
    if (self.verificationTextField.text.length == 0) {
        
        [SVProgressHUD showErrorWithStatus:@"请输入验证码"];
        
    }
    else{
        
        PasswordSetVC *vc = [[PasswordSetVC alloc]initWithNibName:@"PasswordSetVC" bundle:nil];
        vc.registerModel = self.registerModel;
        vc.vertifiCode = self.verificationTextField.text;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

//获取验证码
- (void)getVerificationCodeAction
{

    [SVProgressHUD showWithStatus:@"正在获取验证码" maskType:SVProgressHUDMaskTypeClear];
    
    [NETWORK_ENGINE requestWithPath:[GLOBALSHARE.CIRCLE_BIGMENU_PATH stringByAppendingFormat:@"?mod=code&phone=%@",self.registerModel.registerPhoneNum] Params:self.params CompletionHandler:^(MKNetworkOperation *completedOperation) {
        
        NSDictionary *dic=[completedOperation responseDecodeToDic];
        
        NSDictionary *statusDic = [dic objectForKey:@"status"];
        
        if ([@"1" isEqualToString:CHECK_VALUE([statusDic objectForKey:@"statu"])]){
 
            [SVProgressHUD showSuccessWithStatus:CHECK_VALUE([statusDic objectForKey:@"msg"])];
            
            verTimeLimit = APP_VERCODE_LIMIT;
            verTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateTimer) userInfo:nil repeats:YES];
            
        }
        else{
            [SVProgressHUD showErrorWithStatus:CHECK_VALUE([statusDic objectForKey:@"msg"])];
        }
        
    } ErrorHandler:^(MKNetworkOperation *completedOperation, NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"服务器忙，请稍候再试"];
    }];

}

//更新计时器
- (void)updateTimer
{
    if (verTimeLimit == 0) {
        if ([verTimer isValid]) {
            [verTimer invalidate];
            verTimer = nil;
            [self.verificationBtn setEnabled:YES];
            [self.verificationBtn setTitle:@"重新获取" forState:UIControlStateNormal];
        }
    }
    else{
        [self.verificationBtn setEnabled:NO];
        NSString *str = [NSString stringWithFormat:@"重新获取(%ld)",verTimeLimit];
        [self.verificationBtn setTitle:str forState:UIControlStateDisabled];
        
    }
    verTimeLimit--;
}

#pragma mark --UITextFiled的观察者方法
-(void)textFiledEditChanged:(NSNotification *)obj
{
    UITextField *textField = (UITextField *)obj.object;
    
    NSString *str = textField.text;
    
    if (textField == self.verificationTextField) {
        
        //验证码默认是最多输入6位
        if (str.length >= 6){
            textField.text = [str substringToIndex:6];
        }
        
    }

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
