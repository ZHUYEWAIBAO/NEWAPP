//
//  ImageScrollVC.m
//  WomenHealthApp
//
//  Created by 朱青 on 15/1/14.
//  Copyright (c) 2015年 WomenHealthApp. All rights reserved.
//

#import "ImageScrollVC.h"

@interface ImageScrollVC ()<UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    BOOL isHiddenNav;
    
    UIImage *currentImage;
}

@end

@implementation ImageScrollVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewPress)];
    [self.view addGestureRecognizer:singleTap];
    
    if (!self.isFromPostDetail) {

        UIButton *rightButton=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
        [rightButton addTarget:self action:@selector(deleteTheImageAction:) forControlEvents:UIControlEventTouchUpInside];
        [rightButton setBackgroundImage:[UIImage imageWithContentFileName:@"cancel_btn"] forState:UIControlStateNormal];
        UIBarButtonItem *rightButtonItem=[[UIBarButtonItem alloc]initWithCustomView:rightButton];
        self.navigationItem.rightBarButtonItem = rightButtonItem;
    }

    [self layOutTheScrollView];
    
}

- (void)layOutTheScrollView
{
    [self.imagesScrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    [self.imagesScrollView setContentSize:CGSizeMake(SCREEN_SIZE.width * self.imagesArray.count, self.imagesScrollView.frame.size.height)];
    
    if (self.isFromPostDetail) {
        
        for (int i=0; i<self.imagesArray.count; i++) {
            UIImageView *imgV = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_SIZE.width * i, 0, SCREEN_SIZE.width, self.imagesScrollView.frame.size.height)];
            [self.imagesScrollView addSubview:imgV];
            imgV.contentMode = UIViewContentModeScaleAspectFit;
            NSString *imgUrl=[self.imagesArray objectAtIndex:i];
            
            //添加转圈
            UIActivityIndicatorView *ac=[[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
            ac.frame=CGRectMake(144, imgV.center.y-ac.frame.size.height/2, ac.frame.size.width, ac.frame.size.height);
            [imgV addSubview:ac];
            
            
            __block UIActivityIndicatorView *amyac = ac;
            __block UIImageView *imageView = imgV;
            [amyac startAnimating];
            [imgV setImageWithURL:[NSURL URLWithString:imgUrl] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
                [amyac stopAnimating];
                [amyac removeFromSuperview];
                
                [imageView setUserInteractionEnabled:YES];
                
                UILongPressGestureRecognizer *longPressGr = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressToDo:)];

                [imageView addGestureRecognizer:longPressGr];
                
                
            }];
            
        }

    }
    else{
        
        for (NSInteger i = 0; i < self.imagesArray.count; i++) {
            
            UIImageView *imgV = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_SIZE.width * i, 0, SCREEN_SIZE.width, self.imagesScrollView.frame.size.height)];
            [self.imagesScrollView addSubview:imgV];
            imgV.contentMode = UIViewContentModeScaleAspectFit;
            [imgV setImage:[self.imagesArray objectAtIndex:i]];
            
            
        }
        
    }

    [self.imagesScrollView scrollRectToVisible:CGRectMake(SCREEN_SIZE.width * self.selectIndex, 0, SCREEN_SIZE.width, self.imagesScrollView.frame.size.height) animated:NO];
    
    self.title = [NSString stringWithFormat:@"%ld/%ld",self.selectIndex+1,self.imagesArray.count];
}

- (void)viewPress
{

    if (isHiddenNav) {
        [self.navigationController setNavigationBarHidden:NO animated:YES];
        
    }
    else{
        [self.navigationController setNavigationBarHidden:YES animated:YES];
    }
    isHiddenNav = !isHiddenNav;
    

}

- (void)deleteTheImageAction:(id)sender
{
    [self.imagesArray removeObjectAtIndex:self.selectIndex];
    
    [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFICATION_IMAGE_DELETE object:[NSNumber numberWithInteger:self.selectIndex]];
    
    if (self.imagesArray.count > 0) {
        
        if (self.selectIndex > 0) {
            self.selectIndex--;
        }
        
        [self layOutTheScrollView];
    }
    else{
        [self.navigationController popViewControllerAnimated:YES];
    }

}

- (void)longPressToDo:(UILongPressGestureRecognizer *)recognizer
{
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        
        currentImage = [(UIImageView *)recognizer.view image];
        
        UIActionSheet *actionSheet = [[UIActionSheet alloc] init];
        actionSheet.delegate = self;
        [actionSheet addButtonWithTitle:NSLocalizedString(@"保存图片", nil)];
        [actionSheet addButtonWithTitle:NSLocalizedString(@"举报", nil)];
        actionSheet.cancelButtonIndex = [actionSheet addButtonWithTitle:NSLocalizedString(@"取消", nil)];
        [actionSheet showInView:self.view];
        
    }

}

#pragma mark UIScrolldelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSNumber *num = [NSNumber numberWithFloat:scrollView.contentOffset.x/SCREEN_SIZE.width];
    self.selectIndex = [num integerValue];
    self.title = [NSString stringWithFormat:@"%ld/%ld",self.selectIndex+1,self.imagesArray.count];
    
}

#pragma mark UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        
        UIImageWriteToSavedPhotosAlbum(currentImage, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
        

    }
    else if (buttonIndex == 1){
        [SVProgressHUD showSuccessWithStatus:@"已举报"];
    }
    
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{

    if (error == nil){
        
        [SVProgressHUD showSuccessWithStatus:@"已保存到相册"];
        
    }
 
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
