//
//  GuideViewController.m
//  WomenHealthApp
//
//  Created by 朱青 on 15/1/29.
//  Copyright (c) 2015年 WomenHealthApp. All rights reserved.
//

#import "GuideViewController.h"
#import "FirstRecordVC.h"

@interface GuideViewController ()

@end

@implementation GuideViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self showTheScrollImage];
}

- (void)showTheScrollImage
{
    NSArray *imagesArray = [NSArray arrayWithObjects:@"4s-1.png",@"4s-2.png",@"4s-3.png",@"4s-4.png", nil];
    if (RETINA_4) {
        imagesArray = [NSArray arrayWithObjects:@"5s-1.png", @"5s-2.png", @"5s-3.png",@"5s-4.png", nil];
    }
    
    NSInteger i = 0;
    for (NSString *img in imagesArray) {

        UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageWithContentFileName:img]];

        if (IOS7) {
            imageView.frame = CGRectMake(SCREEN_SIZE.width * i++, 0, SCREEN_SIZE.width, SCREEN_SIZE.height);
        }
        else{
            imageView.frame = CGRectMake(SCREEN_SIZE.width * i++, 0, SCREEN_SIZE.width, SCREEN_SIZE.height - 20);
        }
        
        [self.guideScrollView addSubview:imageView];
 
        if (i == imagesArray.count) {

            UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissTheGuide)];
            //设置成NO表示当前控件响应后会传播到其他控件上，默认为YES。
            imageView.userInteractionEnabled = YES;
            //将触摸事件添加到当前view
            [imageView addGestureRecognizer:tapGestureRecognizer];

        }
    }
    
    [self.guideScrollView setContentSize:CGSizeMake(self.guideScrollView.frame.size.width * imagesArray.count, self.guideScrollView.frame.size.height)];
    
}

- (void)dismissTheGuide
{
    [COMMONDSHARE saveTheGuideKey:YES];
    [UIView animateWithDuration:0.5f animations:^{
        [self.view setAlpha:0];
    } completion:^(BOOL finish){
        
        UINavigationController *record_vc = [FirstRecordVC navigationControllerContainSelf];
        [self presentViewController:record_vc animated:NO completion:nil];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
