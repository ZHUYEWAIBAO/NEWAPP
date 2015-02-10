//
//  ShoppingPaySuccessVC.m
//  WomenHealthApp
//
//  Created by 朱青 on 15/1/5.
//  Copyright (c) 2015年 WomenHealthApp. All rights reserved.
//

#import "ShoppingPaySuccessVC.h"

@interface ShoppingPaySuccessVC ()

@end

@implementation ShoppingPaySuccessVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"支付成功";

    UIButton *leftButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 46, 25)];
    [leftButton addTarget:self action:@selector(leftBackClick:) forControlEvents:UIControlEventTouchUpInside];
    [leftButton setImage:[UIImage imageWithContentFileName:@"back_bt.png"] forState:UIControlStateNormal];
    UIBarButtonItem *leftButtonItem=[[UIBarButtonItem alloc]initWithCustomView:leftButton];
    self.navigationItem.leftBarButtonItem = leftButtonItem;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)goToShopAction:(id)sender
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)leftBackClick:(id)sender
{

    [self.navigationController popToRootViewControllerAnimated:YES];
}

@end
