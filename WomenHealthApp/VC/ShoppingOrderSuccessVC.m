//
//  ShoppingOrderSuccessVC.m
//  WomenHealthApp
//
//  Created by 朱青 on 14/12/14.
//  Copyright (c) 2014年 WomenHealthApp. All rights reserved.
//

#import "ShoppingOrderSuccessVC.h"
#import "OrderPayModel.h"
#import "DataSigner.h"
#import <AlipaySDK/AlipaySDK.h>

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
    /*
     *生成订单信息及签名
     */
    //将商品信息赋予AlixPayOrder的成员变量
    OrderPayModel *order = [[OrderPayModel alloc] init];
    order.tradeNO = self.successModel.order_id; //订单ID（由商家自行制定）
    order.amount = self.successModel.order_amount; //商品价格
    order.productName = @"商品标题"; //商品标题
    order.productDescription = @"商品描述"; //商品描述
    //应用注册scheme,在AlixPayDemo-Info.plist定义URL types
    NSString *appScheme = @"WomenHealthApp";
    
    //将商品信息拼接成字符串
    NSString *orderSpec = [order description];

    //获取私钥并将商户信息签名,外部商户可以根据情况存放私钥和签名,只需要遵循RSA签名规范,并将签名字符串base64编码和UrlEncode
    id<DataSigner> signer = CreateRSADataSigner(ALI_PRIVATE_KEY);
    NSString *signedString = [signer signString:orderSpec];
    
    //将签名成功字符串格式化为订单字符串,请严格按照该格式
    NSString *orderString = nil;
    if (signedString != nil) {
        orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"",
                       orderSpec, signedString, @"RSA"];
        
        [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
            NSLog(@"reslut = %@",resultDic);
        }];
 
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
