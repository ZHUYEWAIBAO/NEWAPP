//
//  FeedBackVC.m
//  WomenHealthApp
//
//  Created by 朱青 on 15/1/21.
//  Copyright (c) 2015年 WomenHealthApp. All rights reserved.
//

#import "FeedBackVC.h"

@interface FeedBackVC ()

@end

@implementation FeedBackVC

- (void)loadView
{
    [super loadView];
    
//    self.inputView = self.suggestScrollView;
    self.title = @"意见反馈";
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.suggestScrollView setContentSize:CGSizeMake(SCREEN_SIZE.width, 500)];
//    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyboardHide)];
//    //设置成NO表示当前控件响应后会传播到其他控件上，默认为YES。
//    tapGestureRecognizer.cancelsTouchesInView = NO;
//    //将触摸事件添加到当前view
//    [self.layOutView addGestureRecognizer:tapGestureRecognizer];
    
    UIButton *sendBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    sendBtn.frame = CGRectMake(0,0,30,30);
    [sendBtn setImage:[UIImage imageWithContentFileName:@"send_btn"] forState:UIControlStateNormal];
    [sendBtn setImage:[UIImage imageWithContentFileName:@"send_btn_selected"] forState:UIControlStateHighlighted];
    [sendBtn addTarget:self action:@selector(sendSuggestAction:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:sendBtn];
    self.navigationItem.rightBarButtonItem = leftItem;
    
//    NSMutableArray *viewArr = [NSMutableArray arrayWithObjects:_titleView,_contentView,_emailView,_typeView, nil];
//    //最外层
//    _layOutView.orientation = CSLinearLayoutViewOrientationVertical;
//    _layOutView.scrollEnabled = YES;
//    _layOutView.showsVerticalScrollIndicator = NO;
//    _layOutView.showsVerticalScrollIndicator = YES;
//    _layOutView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
//    
//    for (UIView *view in viewArr) {
//        
//        CSLinearLayoutItem *item = [CSLinearLayoutItem layoutItemForView:view];
//        item.padding = CSLinearLayoutMakePadding(0.0, 0.0, 0.0, 0.0);  //各个view距上下左右的边距长度
//        item.horizontalAlignment = CSLinearLayoutItemHorizontalAlignmentCenter;
//        
//        [_layOutView addItem:item];
//    }
    
    self.contentTextView.placeholder = @"请输入留言内容";
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [[IQKeyboardManager sharedManager]setEnableAutoToolbar:YES];
 
}

- (IBAction)chooseTypeAction:(id)sender
{
    
}

- (void)sendSuggestAction:(id)sender
{
    if ([@"" isEqualToString:self.titleTextField.text]) {
        [SVProgressHUD showErrorWithStatus:@"请输入主题~"];
        return;
    }
    if ([@"" isEqualToString:self.contentTextView.text]) {
        [SVProgressHUD showErrorWithStatus:@"请输入留言内容~"];
        return;
    }
    if (![self.emailTextField.text isValidateEmail]) {
        [SVProgressHUD showErrorWithStatus:@"请输入正确的邮箱~"];
        return;
    }
    
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];
    
    [self.params removeAllObjects];
    [self.params setObject:self.titleTextField.text forKey:@"msg_title"];
    [self.params setObject:self.contentTextView.text forKey:@"msg_content"];
    [self.params setObject:self.emailTextField.text forKey:@"user_email"];
    [self.params setObject:@"1" forKey:@"msg_type"];

    NSString *path = [NSString stringWithFormat:@"/api/ec/message.php"];

    [NETWORK_ENGINE requestWithPath:path Params:self.params CompletionHandler:^(MKNetworkOperation *completedOperation) {
        
        NSDictionary *dic=[completedOperation responseDecodeToDic];
        
        NSDictionary *statusDic = [dic objectForKey:@"status"];
        
        if ([@"1" isEqualToString:CHECK_VALUE([statusDic objectForKey:@"statu"])]) {
            
            [SVProgressHUD showSuccessWithStatus:@"发表成功"];
            [self.navigationController popViewControllerAnimated:YES];
            
        }
        else{
            
            [SVProgressHUD showErrorWithStatus:CHECK_VALUE([statusDic objectForKey:@"msg"])];
        }
        
        
    } ErrorHandler:^(MKNetworkOperation *completedOperation, NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"服务器忙，请稍候再试"];
    }];
        
    

}

//#pragma mark - UITextFiledDelegate
//- (void)textFieldDidBeginEditing:(UITextField *)textField
//{
//    if (textField == self.emailTextField) {
//        [self animateTextField:150 up: YES];
//    }
//    
//}
//
//- (void)textFieldDidEndEditing:(UITextField *)textField
//{
//    if (textField == self.emailTextField) {
//        [self animateTextField:150 up: NO];
//    }
//    
//}
//#pragma mark - UITextViewDelegate
//- (void)textViewDidBeginEditing:(UITextView *)textView
//{
//    [self animateTextField:150 up: YES];
//}
//
//- (void)textViewDidEndEditing:(UITextView *)textView
//{
//    [self animateTextField:150 up: NO];
//}
////键盘弹出或落下时，调整self.view的高度
//- (void) animateTextField: (NSInteger)height up: (BOOL) up
//{
//    const NSInteger movementDistance = height; // tweak as needed
//    
//    const float movementDuration = 0.2f; // tweak as needed
//    
//    NSInteger movement = (up ? -movementDistance : movementDistance);
//    
//    
//    [UIView beginAnimations: @"anim" context: nil];
//    
//    [UIView setAnimationBeginsFromCurrentState: YES];
//    
//    [UIView setAnimationDuration: movementDuration];
//    
//    self.view.frame = CGRectOffset(self.view.frame, 0, movement);
//    
//    [UIView commitAnimations];
//    
//}

- (void)keyboardHide
{
    [self.view endEditing:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
