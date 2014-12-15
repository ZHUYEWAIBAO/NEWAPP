//
//  ShoppingOrderSuccessVC.m
//  WomenHealthApp
//
//  Created by 朱青 on 14/12/14.
//  Copyright (c) 2014年 WomenHealthApp. All rights reserved.
//

#import "ShoppingOrderSuccessVC.h"

@interface ShoppingOrderSuccessVC ()

@end

@implementation ShoppingOrderSuccessVC

- (void)loadView
{
    [super loadView];
    
    self.title = @"下单成功";
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if ([@"4" isEqualToString:self.payTypeId]) {
        [self.payButton setImage:[UIImage imageWithContentFileName:@"zhifubao_btn"] forState:UIControlStateNormal];
    }
    else{
        [self.payButton setImage:[UIImage imageWithContentFileName:@"weixin_btn"] forState:UIControlStateNormal];
    }
    
    self.orderLabel.text = self.successModel.order_id;
    
    [self setViewLayer:self.orderBgImageView andCornerRadius:4 andBorderColor:nil andBorderWidth:0.0f];
}

- (IBAction)payButtonAction:(id)sender
{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
