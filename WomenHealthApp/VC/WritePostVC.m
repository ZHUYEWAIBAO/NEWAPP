//
//  WritePostVC.m
//  WomenHealthApp
//
//  Created by 朱青 on 15/1/10.
//  Copyright (c) 2015年 WomenHealthApp. All rights reserved.
//

#import "WritePostVC.h"
#import "ImageScrollVC.h"
#import "JSONKit.h"

@implementation CustomButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}
@end

#define photo_btn_width 90
#define photo_btn_inset 12.5
@interface WritePostVC ()<UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    NSInteger currentBtnTag;
    CustomButton *currentBtn;
}

@end

@implementation WritePostVC

- (void)loadView
{
    [super loadView];
    
    self.title = @"发表话题";
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deleteTheImage:) name:NOTIFICATION_IMAGE_DELETE object:nil];
    
    UIButton *sendBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    sendBtn.frame = CGRectMake(0,0,30,30);
    [sendBtn setImage:[UIImage imageWithContentFileName:@"send_btn"] forState:UIControlStateNormal];
    [sendBtn setImage:[UIImage imageWithContentFileName:@"send_btn_selected"] forState:UIControlStateHighlighted];
    [sendBtn addTarget:self action:@selector(sendPostAction:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:sendBtn];
    self.navigationItem.rightBarButtonItem = leftItem;
    
    self.postTextView.placeholder = @"请输入正文";
    
    _imageDataArray = [[NSMutableArray alloc]initWithCapacity:0];
    _imageTextArray = [[NSMutableArray alloc]initWithCapacity:0];
    _imageArray = [[NSMutableArray alloc]initWithCapacity:0];
    _imageIdArray = [[NSMutableArray alloc]initWithCapacity:0];
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyboardHide:)];
    //设置成NO表示当前控件响应后会传播到其他控件上，默认为YES。
    tapGestureRecognizer.cancelsTouchesInView = NO;
    //将触摸事件添加到当前view
    [self.view addGestureRecognizer:tapGestureRecognizer];


}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
//    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)deleteTheImage:(NSNotification *)notifi
{
    if (notifi.object) {
        NSNumber *number = (NSNumber *)notifi.object;
    
        NSInteger index = [number integerValue];
     
        [_imageDataArray removeObjectAtIndex:index];

        [self layOutTheButtons];
    }
    
}

#pragma mark - 发表话题
- (void)sendPostAction:(id)sender
{
    if ([@"" isEqualToString:self.postTextFiled.text]) {
        [SVProgressHUD showErrorWithStatus:@"请输入标题~"];
        return;
    }
    if ([@"" isEqualToString:self.postTextView.text]) {
        [SVProgressHUD showErrorWithStatus:@"请输入正文~"];
        return;
    }
    if (!USERINFO.isLogin) {
        [self presentLoginVCAction];
        return;
    }

    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];
    
    [self.params removeAllObjects];
    
    if (_imageDataArray.count > 0) {
        NSString *path = [NSString stringWithFormat:@"/api/dz/misc.php?mod=swfupload&action=swfupload&operation=upload&fid=%@&uid=%@",self.currentFid,USERINFO.uid];
        
        for (NSInteger i = 0;i < _imageDataArray.count;i++) {
            
            NSData *imageData = [_imageDataArray objectAtIndex:i];
            
            [NETWORK_ENGINE requestWithPath:path Params:self.params imageData:imageData keyString:@"Filedata" CompletionHandler:^(MKNetworkOperation *completedOperation) {
                
                NSDictionary *dic=[completedOperation responseDecodeToDic];
                
                NSDictionary *statusDic = [dic objectForKey:@"status"];
                
                if ([@"1" isEqualToString:CHECK_VALUE([statusDic objectForKey:@"statu"])]) {
                    
                    NSString *aidStr = [[dic objectForKey:@"data"] objectForKey:@"aid_str"];
                    [_imageTextArray addObject:aidStr];
                    
                    NSString *aid = [[dic objectForKey:@"data"] objectForKey:@"aid"];
                    [_imageIdArray addObject:aid];
                    
                    if (i == _imageDataArray.count - 1) {
                        
                        [self sendTheTextAction];
                        
                    }
                    
                }
                else{
                    
                    [SVProgressHUD showErrorWithStatus:CHECK_VALUE([statusDic objectForKey:@"msg"])];
                }
                
                
            } ErrorHandler:^(MKNetworkOperation *completedOperation, NSError *error) {
                [SVProgressHUD showErrorWithStatus:@"服务器忙，请稍候再试"];
            }];
            
        }

    }
    else{
        [self sendTheTextAction];
    }


}


- (void)sendTheTextAction
{

    [self.params removeAllObjects];
    [self.params setObject:CHECK_VALUE(self.postTextFiled.text) forKey:@"subject"];
    
    NSString *str = self.postTextView.text;
    
    if (_imageTextArray.count > 0) {
        for (NSString *aid in _imageTextArray) {
            str = [str stringByAppendingString:aid];
        }
        [self.params setObject:[_imageIdArray JSONString] forKey:@"attachnew"];
    }

    [self.params setObject:CHECK_VALUE(str) forKey:@"message"];
    
    NSString *path = [NSString stringWithFormat:@"/api/dz/index.php?mod=post&action=newthread&fid=%@&extra=&topicsubmit=yes&uid=%@",self.currentFid,USERINFO.uid];

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

- (IBAction)photoBtnAction:(id)sender
{
    CustomButton *button = (CustomButton *)sender;
    
    currentBtnTag = button.tag - 100;
    currentBtn = button;
    
    if (button.isLoadImage) {
        
        ImageScrollVC *vc = [[ImageScrollVC alloc]initWithNibName:@"ImageScrollVC" bundle:nil];
        vc.imagesArray = _imageArray;
        vc.selectIndex = currentBtnTag;
        [self.navigationController pushViewController:vc animated:YES];
        
    }
    else{

        UIActionSheet *actionSheet = [[UIActionSheet alloc] init];
        actionSheet.delegate = self;
        [actionSheet addButtonWithTitle:NSLocalizedString(@"拍照", nil)];
        [actionSheet addButtonWithTitle:NSLocalizedString(@"从相册中选取", nil)];
        actionSheet.cancelButtonIndex = [actionSheet addButtonWithTitle:NSLocalizedString(@"取消", nil)];
        [actionSheet showInView:self.view];
    }

}

#pragma mark UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSUInteger sourceType = 0;
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        switch (buttonIndex)
        {
            case 0:
                sourceType = UIImagePickerControllerSourceTypeCamera;
                
                
                break;
            case 1:
                sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                
                break;
                
            default:
                return;
                break;
        }
        
    }
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.delegate = self;
    imagePickerController.allowsEditing = NO;
    imagePickerController.sourceType = sourceType;
    
    [self presentViewController:imagePickerController animated:YES completion:nil];
    
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:nil];
    UIImage *photoImg = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    NSData *data = UIImageJPEGRepresentation(photoImg,0.5);
 
    [_imageDataArray addObject:data];
    
    [_imageArray addObject:photoImg];
    
    [currentBtn setBackgroundImage:photoImg forState:UIControlStateNormal];
    currentBtn.isLoadImage = YES;
    
    [self showTheLastButton];
    
}

- (void)layOutTheButtons
{
    [self.buttonView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    for (NSInteger i = 0; i < _imageArray.count; i++) {
        CustomButton *button = [CustomButton buttonWithType:UIButtonTypeCustom];
        [button setFrame:CGRectMake(i * photo_btn_width + (i + 1)*photo_btn_inset, 0, photo_btn_width, photo_btn_width)];
        button.tag = i + 100;
        button.isLoadImage = YES;
        [button setBackgroundImage:[_imageArray objectAtIndex:i] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(photoBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.buttonView addSubview:button];
    }
    [self showTheLastButton];

}

- (void)showTheLastButton
{
    if (_imageArray.count < 3) {
        CustomButton *button = [CustomButton buttonWithType:UIButtonTypeCustom];
        [button setFrame:CGRectMake(_imageArray.count * photo_btn_width +
                                    (_imageArray.count + 1)*photo_btn_inset,
                                    0, photo_btn_width, photo_btn_width)];
        button.tag = _imageArray.count + 100;
        [button setBackgroundImage:[UIImage imageWithContentFileName:@"sent_addphoto"] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(photoBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.buttonView addSubview:button];
    }
}

#pragma mark - UITextViewDelegate
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if (!RETINA_4) {
        [self animateTextField:50 up: YES];
    }
    
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    if (!RETINA_4) {
        [self animateTextField:50 up: NO];
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([text isEqualToString:@"\n"]){ //判断输入的字是否是回车，即按下return
        [self.view endEditing:YES];
        return NO; //这里返回NO，就代表return键值失效，即页面上按下return，不会出现换行，如果为yes，则输入页面会换行
    }
    
    return YES;
}

//键盘弹出或落下时，调整self.view的高度
- (void) animateTextField: (NSInteger)height up: (BOOL) up
{
    const NSInteger movementDistance = height; // tweak as needed
    
    const float movementDuration = 0.2f; // tweak as needed
    
    NSInteger movement = (up ? -movementDistance : movementDistance);
    
    [UIView beginAnimations: @"anim" context: nil];
    
    [UIView setAnimationBeginsFromCurrentState: YES];
    
    [UIView setAnimationDuration: movementDuration];
    
    self.view.frame = CGRectOffset(self.view.frame, 0, movement);
    
    [UIView commitAnimations];
    
}

- (IBAction)keyboardHide:(id)sender
{
    [self.view endEditing:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
