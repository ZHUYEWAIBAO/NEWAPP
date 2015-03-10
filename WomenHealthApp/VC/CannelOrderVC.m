//
//  CannelOrderVC.m
//  WomenHealthApp
//
//  Created by 朱青 on 15/3/6.
//  Copyright (c) 2015年 WomenHealthApp. All rights reserved.
//

#import "CannelOrderVC.h"

@interface CannelOrderVC ()

@end

@implementation CannelOrderVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"取消订单";
    
    UIButton *rightButton=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
    [rightButton addTarget:self action:@selector(cancelOrderAction:) forControlEvents:UIControlEventTouchUpInside];
    [rightButton setBackgroundImage:[UIImage imageWithContentFileName:@"Record_detail_sure_btn.png"] forState:UIControlStateNormal];
    UIBarButtonItem *rightButtonItem=[[UIBarButtonItem alloc]initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem = rightButtonItem;
}

//取消订单
- (void)cancelOrderAction:(id)sender
{
    if (self.contentTextView.text.length > 0) {
        [SVProgressHUD showErrorWithStatus:@"去输入取消理由"];
        return;
    }
    
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];
    
    [self.params removeAllObjects];
    
    NSString *path = [NSString stringWithFormat:@"/api/ec/user.php?mod=cancel_order&uid=%@&order_id=%@",USERINFO.uid,self.orderId];
    
    [NETWORK_ENGINE requestWithPath:path Params:self.params CompletionHandler:^(MKNetworkOperation *completedOperation) {
        
        NSDictionary *dic=[completedOperation responseDecodeToDic];
        
        NSDictionary *statusDic = [dic objectForKey:@"status"];
        
        if ([@"1" isEqualToString:CHECK_VALUE([statusDic objectForKey:@"statu"])]) {
            
            [SVProgressHUD dismiss];
            
            [self performSelector:@selector(backToMyOrderList) withObject:nil afterDelay:1.0f];

            
        }
        else{
            
            [SVProgressHUD showErrorWithStatus:CHECK_VALUE([statusDic objectForKey:@"msg"])];
        }
        
        
    } ErrorHandler:^(MKNetworkOperation *completedOperation, NSError *error) {
        
        [SVProgressHUD showErrorWithStatus:@"服务器忙，请稍候再试"];
        
    }];

}

- (void)backToMyOrderList
{
    
    [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFICATION_REFRESH_ORDERRECORD object:nil];

    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
