//
//  CommentOrderVC.m
//  WomenHealthApp
//
//  Created by 朱青 on 14/12/18.
//  Copyright (c) 2014年 WomenHealthApp. All rights reserved.
//

#import "CommentOrderVC.h"
#import "CommentImageModel.h"
#import "JSONKit.h"

@interface CommentOrderVC ()<UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    NSInteger currentBtnTag;
    UIButton *currentBtn;
}

@end

@implementation CommentOrderVC

- (void)loadView
{
    [super loadView];
    self.title = @"评价商品";
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _imageDataArray = [[NSMutableArray alloc]initWithCapacity:0];
    
    self.timeLabel.text = [NSString stringWithFormat:@"成交时间:%@",[self.payTime switchDateReturnType:3]];
    self.nameLabel.text = self.goodsModel.goods_name;
    self.numLabel.text = [NSString stringWithFormat:@"数量:%@",self.goodsModel.goods_number];
    self.attrTypeLabel.text = self.goodsModel.goods_attr;

    [self.goodsImageView setImageWithURL:[NSURL URLWithString:self.goodsModel.goods_thumb]];
    
    self.commentTextView.placeholder = @"写点评价吧~";
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyboardHide)];
    //设置成NO表示当前控件响应后会传播到其他控件上，默认为YES。
    tapGestureRecognizer.cancelsTouchesInView = NO;
    //将触摸事件添加到当前view
    [self.view addGestureRecognizer:tapGestureRecognizer];
}

- (IBAction)photoBtnAction:(id)sender
{
    UIButton *button = (UIButton *)sender;
    currentBtnTag = button.tag - 100;
    currentBtn = button;
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc] init];
    actionSheet.delegate = self;
    [actionSheet addButtonWithTitle:NSLocalizedString(@"拍照", nil)];
    [actionSheet addButtonWithTitle:NSLocalizedString(@"从相册中选取", nil)];
    actionSheet.cancelButtonIndex = [actionSheet addButtonWithTitle:NSLocalizedString(@"取消", nil)];
    [actionSheet showInView:self.view];
}

//提交订单
- (IBAction)commitTheCommentAction:(id)sender
{
    if ([@"" isEqualToString:self.commentTextView.text]) {
        [SVProgressHUD showErrorWithStatus:@"亲，先写点评价吧~"];
        return;
    }
    
    NSMutableDictionary *dictionery = [NSMutableDictionary dictionary];
 
    [dictionery setObject:@"" forKey:@"email"];
    [dictionery setObject:@"0" forKey:@"type"];
    [dictionery setObject:CHECK_VALUE(self.goodsModel.goods_id) forKey:@"id"];
    [dictionery setObject:@"1" forKey:@"enabled_captcha"];
    [dictionery setObject:@"" forKey:@"captcha"];
    [dictionery setObject:@"5" forKey:@"rank"];
    
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];
    
    [self.params removeAllObjects];
    [self.params setObject:[dictionery JSONString] forKey:@"cmt"];
    
    NSString *path = [NSString stringWithFormat:@"/api/ec/comment.php?uid=%@",USERINFO.uid];
    
    NSMutableArray *dataArray = [[NSMutableArray alloc]initWithCapacity:0];
    
    for (CommentImageModel *model in _imageDataArray) {
        [dataArray addObject:model.commentImageData];
    }
    [NETWORK_ENGINE requestWithPath:path Params:self.params fileArray:dataArray keyString:@"Filedata" CompletionHandler:^(MKNetworkOperation *completedOperation) {
        
        NSDictionary *dic=[completedOperation responseDecodeToDic];
        
        NSDictionary *statusDic = [dic objectForKey:@"status"];
        
        if ([@"1" isEqualToString:CHECK_VALUE([statusDic objectForKey:@"statu"])]) {
            
            [SVProgressHUD showSuccessWithStatus:@"评价成功"];
            
            [self.navigationController popViewControllerAnimated:YES];
        }
        else{
            
            [SVProgressHUD showErrorWithStatus:CHECK_VALUE([statusDic objectForKey:@"msg"])];
        }
        
        
    } ErrorHandler:^(MKNetworkOperation *completedOperation, NSError *error) {
        
        [SVProgressHUD showErrorWithStatus:@"服务器忙，请稍候再试"];
        
    }];
    

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
    imagePickerController.allowsEditing = YES;
    imagePickerController.sourceType = sourceType;
    
    [self presentViewController:imagePickerController animated:YES completion:nil];
    
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:nil];
    UIImage *photoImg = [info objectForKey:UIImagePickerControllerEditedImage];
    
    NSData *data = UIImageJPEGRepresentation(UIImageScaleToSize(photoImg, CGSizeMake(200, 200)), 0.5);
  
    CommentImageModel *model = [[CommentImageModel alloc]init];
    model.commentImageData = data;
    model.commentImageTag = [NSString stringWithFormat:@"%ld",currentBtnTag];
    
    if (_imageDataArray.count > 0) {
        BOOL isReplace;
        for (NSInteger i=0;i<_imageDataArray.count; i++) {
            CommentImageModel *subModel = [_imageDataArray objectAtIndex:i];
            if ([subModel.commentImageTag isEqualToString:[NSString stringWithFormat:@"%ld",currentBtnTag]]) {
                [_imageDataArray replaceObjectAtIndex:i withObject:subModel];
                isReplace = YES;
                break;
            }
        }
        if (!isReplace) {
            [_imageDataArray addObject:model];
        }
    }
    else{
        [_imageDataArray addObject:model];
    }
    
    [currentBtn setBackgroundImage:photoImg forState:UIControlStateNormal];
}

- (void)upLoaduserPhoto:(NSData *)imgData
{

    
}

#pragma mark - UITextViewDelegate
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if (!RETINA_4) {
        [self animateTextField:100 up: YES];
    }
    
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    if (!RETINA_4) {
        [self animateTextField:100 up: NO];
    }
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

- (void)keyboardHide
{
    [self.commentTextView resignFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
