//
//  UserDetailVC.m
//  WomenHealthApp
//
//  Created by 朱青 on 14/12/22.
//  Copyright (c) 2014年 WomenHealthApp. All rights reserved.
//

#import "UserDetailVC.h"

@interface UserDetailVC ()<UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    UIImage *photoImg;
}

@end

@implementation UserDetailVC

- (void)loadView
{
    [super loadView];
    
    self.title = @"编辑个人信息";
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.headImageView.layer.cornerRadius = self.headImageView.frame.size.width / 2;
    self.headImageView.layer.masksToBounds = YES;
    [self.headImageView setImageWithURL:[NSURL URLWithString:USERINFO.user_icon]];
    
    self.headTitleField.placeholder = USERINFO.username;
}

- (IBAction)changeTheUseNameAction:(id)sender
{
    [self.headTitleField resignFirstResponder];
    
    if ([USERINFO.username isEqualToString:_headTitleField.text]) {
        return;
    }
    if ([@"" isEqualToString:_headTitleField.text]) {
        [SVProgressHUD showErrorWithStatus:@"请输入新昵称"];
        return;
    }
    
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];
    
    [self.params removeAllObjects];
    [self.params setObject:CHECK_VALUE(self.headTitleField.text) forKey:@"username"];
    
    NSString *path = [NSString stringWithFormat:@"/dz/uc_server/index.php?m=user&uid=%@&a=updateusername",USERINFO.uid];
    
    [NETWORK_ENGINE requestWithPath:path Params:self.params CompletionHandler:^(MKNetworkOperation *completedOperation) {
        
        NSDictionary *dic=[completedOperation responseDecodeToDic];
        
        NSDictionary *statusDic = [dic objectForKey:@"status"];
        
        if ([@"1" isEqualToString:CHECK_VALUE([statusDic objectForKey:@"statu"])]) {
            
            USERINFO.username = self.headTitleField.text;
            [SVProgressHUD showSuccessWithStatus:@"设置成功"];
            
            [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFICATION_USER_LOGIN object:nil];
        
        }
        else{
            
            [SVProgressHUD showErrorWithStatus:CHECK_VALUE([statusDic objectForKey:@"msg"])];
        }
        
        
    } ErrorHandler:^(MKNetworkOperation *completedOperation, NSError *error) {
        
        [SVProgressHUD showErrorWithStatus:@"服务器忙，请稍候再试"];
        
    }];

}

//上传头像
- (IBAction)changeTheUseImageViewAction:(id)sender
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] init];
    actionSheet.delegate = self;
    [actionSheet addButtonWithTitle:NSLocalizedString(@"拍照", nil)];
    [actionSheet addButtonWithTitle:NSLocalizedString(@"从相册中选取", nil)];
    actionSheet.cancelButtonIndex = [actionSheet addButtonWithTitle:NSLocalizedString(@"取消", nil)];
    [actionSheet showInView:self.view];
    
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
    photoImg = [info objectForKey:UIImagePickerControllerEditedImage];
    
    NSData *data = UIImageJPEGRepresentation(UIImageScaleToSize(photoImg, CGSizeMake(200, 200)), 0.5);
    
    [self upLoaduserPhoto:data];
}

- (void)upLoaduserPhoto:(NSData *)imgData
{
    [self.params removeAllObjects];
  
    [SVProgressHUD showWithStatus:@"正在上传头像..." maskType:SVProgressHUDMaskTypeGradient];
    
    NSString *path = [NSString stringWithFormat:@"/dz/uc_server/index.php?m=user&uid=%@&a=uploadavatarapi",USERINFO.uid];
    
    [NETWORK_ENGINE requestWithPath:path Params:self.params imageData:imgData keyString:@"Filedata" CompletionHandler:^(MKNetworkOperation *completedOperation) {
        
        NSDictionary *dic=[completedOperation responseDecodeToDic];
        
        NSDictionary *statusDic = [dic objectForKey:@"status"];
        
        if ([@"1" isEqualToString:CHECK_VALUE([statusDic objectForKey:@"statu"])]) {
            
            [SVProgressHUD showSuccessWithStatus:@"上传成功"];
            
            [self.headImageView setImage:photoImg];
            
            NSDictionary *dataDic = [dic objectForKey:@"data"];
            NSArray *array = [dataDic objectForKey:@"list"];
            
            USERINFO.user_icon = [array objectAtIndex:0];
            
            [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFICATION_USER_LOGIN object:nil];
    
            
        }
        else{
            
            [SVProgressHUD showErrorWithStatus:CHECK_VALUE([statusDic objectForKey:@"msg"])];
        }
        
    } ErrorHandler:^(MKNetworkOperation *completedOperation, NSError *error) {
        
        [SVProgressHUD showErrorWithStatus:@"服务器忙，请稍候再试"];
        
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
