//
//  MyOrderDetailVC.m
//  WomenHealthApp
//
//  Created by 朱青 on 14/12/14.
//  Copyright (c) 2014年 WomenHealthApp. All rights reserved.
//

#import "MyOrderDetailVC.h"
#import "ShoppingDetailVC.h"
#import "OrderGoodsCell.h"
#import "MyOrderListModel.h"
#import "LineImageView.h"
#import "LogisticsViewController.h"
#import "CommentOrderVC.h"

@interface MyOrderDetailVC ()

@end

@implementation MyOrderDetailVC

- (void)loadView
{
    [super loadView];
    
    self.title = @"订单详情";
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self getTheOrderInfo:self.orderId];
}

- (void)getTheOrderInfo:(NSString *)string
{
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];
    
    [self.params removeAllObjects];
    [self.params setObject:CHECK_VALUE(self.orderId) forKey:@"rec_ids"];
    
    NSString *path = [NSString stringWithFormat:@"/api/ec/user.php?mod=order_detail&uid=%@&order_id=%@",USERINFO.uid,self.orderId];
    
    [NETWORK_ENGINE requestWithPath:path Params:self.params CompletionHandler:^(MKNetworkOperation *completedOperation) {
        
        NSDictionary *dic=[completedOperation responseDecodeToDic];
        
        NSDictionary *statusDic = [dic objectForKey:@"status"];
        
        if ([@"1" isEqualToString:CHECK_VALUE([statusDic objectForKey:@"statu"])]) {
            
            MyOrderDetailModel *model = [MyOrderDetailModel parseDicToMyOrderDetailObject:[dic objectForKey:@"data"]];
            self.orderDetailModel = model;
            
            NSMutableArray *array = [[NSMutableArray alloc]initWithObjects:_addressView,_payTypeView,_goodsDetailView,_orderView, nil];
        
            [self layOutMainView:array];
            [SVProgressHUD dismiss];
        }
        else{
            
            [SVProgressHUD showErrorWithStatus:CHECK_VALUE([statusDic objectForKey:@"msg"])];
        }
        
        
    } ErrorHandler:^(MKNetworkOperation *completedOperation, NSError *error) {
        
        [SVProgressHUD showErrorWithStatus:@"服务器忙，请稍候再试"];
        
    }];
    
}

//布局整体页面
-(void)layOutMainView:(NSMutableArray *)viewArr
{
    
    [self layOutAddressView];
    [self layOutPayTyeView];
    [self layOutTheTableView];
    [self layOutTheOrderView];

    //最外层
    _layOutView.orientation = CSLinearLayoutViewOrientationVertical;
    _layOutView.scrollEnabled = YES;
    _layOutView.showsVerticalScrollIndicator = NO;
    _layOutView.showsVerticalScrollIndicator = YES;
    _layOutView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    for (UIView *view in viewArr) {
        
        CSLinearLayoutItem *item = [CSLinearLayoutItem layoutItemForView:view];
        item.padding = CSLinearLayoutMakePadding(0.0, 0.0, 10.0, 0.0);  //各个view距上下左右的边距长度
        item.horizontalAlignment = CSLinearLayoutItemHorizontalAlignmentCenter;
        
        [_layOutView addItem:item];
    }
    
}

- (void)layOutAddressView
{
    
    self.addressLabel.text = self.orderDetailModel.address;
    self.phoneLabel.text = self.orderDetailModel.mobile;
    self.nameLabel.text = [NSString stringWithFormat:@"收货人：%@",self.orderDetailModel.consignee];

    switch ([self.orderDetailModel.order_status integerValue]) {
        case 2:{
            self.statusLabel.text = @"未付款";
            [self.firstButton setBackgroundImage:[UIImage imageWithContentFileName:@"pay_btn"] forState:UIControlStateNormal];
            [self.secondButton setBackgroundImage:[UIImage imageWithContentFileName:@"cancel_order_btn"] forState:UIControlStateNormal];
            [self.firstButton addTarget:self action:@selector(continueToPayOrderAction:) forControlEvents:UIControlEventTouchUpInside];
            [self.secondButton addTarget:self action:@selector(cancelOrderAction:) forControlEvents:UIControlEventTouchUpInside];
        }
            break;
            
        case 3:{
            self.statusLabel.text = @"未发货";
            [self.firstButton setBackgroundImage:[UIImage imageWithContentFileName:@"fahuo_btn"] forState:UIControlStateNormal];
            [self.secondButton setHidden:YES];
            [self.firstButton addTarget:self action:@selector(alertTheShopAction:) forControlEvents:UIControlEventTouchUpInside];
        }
            break;
            
        case 4:{
            self.statusLabel.text = @"已发货";
            [self.firstButton setBackgroundImage:[UIImage imageWithContentFileName:@"shouhuo_btn"] forState:UIControlStateNormal];
            [self.secondButton setBackgroundImage:[UIImage imageWithContentFileName:@"wuliu_btn"] forState:UIControlStateNormal];
            [self.firstButton addTarget:self action:@selector(comfirmRecieveGoodsAction:) forControlEvents:UIControlEventTouchUpInside];
            [self.secondButton addTarget:self action:@selector(lookForLogisticsAction:) forControlEvents:UIControlEventTouchUpInside];
        }
            break;
            
        case 5:{
            self.statusLabel.text = @"交易关闭";
            [self.firstButton setBackgroundImage:[UIImage imageWithContentFileName:@"delete_order_btn"] forState:UIControlStateNormal];
            [self.secondButton setHidden:YES];
            [self.firstButton addTarget:self action:@selector(deleteTheOrderAction:) forControlEvents:UIControlEventTouchUpInside];
            
        }
            break;
            
        case 7:{
            self.statusLabel.text = @"已完成";
            [self.firstButton setBackgroundImage:[UIImage imageWithContentFileName:@"delete_order_btn"] forState:UIControlStateNormal];
 
            [self.firstButton addTarget:self action:@selector(deleteTheOrderAction:) forControlEvents:UIControlEventTouchUpInside];

        }
            break;
            
        default:
            break;
    }

}

- (void)layOutPayTyeView
{
    if ([@"4" isEqualToString:self.orderDetailModel.pay_id]) {
        self.payTypeLabel.text = @"支付宝支付";
        
    }
    else{
        self.payTypeLabel.text = @"微信支付";
    }
}

- (void)layOutTheTableView
{
    NSArray *nibArr = [[NSBundle mainBundle] loadNibNamed:@"OrderGoodsCell" owner:self options:nil];
    OrderGoodsCell *cell = [nibArr objectAtIndex:0];
    
    CGRect rect = self.goodsTableView.frame;
    rect.size.height = cell.frame.size.height * self.orderDetailModel.goodsArray.count;
    self.goodsTableView.frame = rect;
    
    CGRect rect3 = self.goodsFootView.frame;
    rect3.origin.y = rect.size.height;
    self.goodsFootView.frame = rect3;
    
    CGRect rect2 = self.goodsDetailView.frame;
    rect2.size.height = rect.size.height + rect.size.height;
    self.goodsDetailView.frame = rect2;
    
    [self.goodsTableView reloadData];
    
    self.shippingFeeLabel.text = [NSString priceStringWithOneFloat:self.orderDetailModel.shipping_fee];
    self.totalPriceLabel.text = [NSString priceStringWithOneFloat:self.orderDetailModel.order_amount];
    self.scoreLabel.text = [NSString priceStringWithOneFloat:self.orderDetailModel.integral_str];
}

#pragma mark UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return self.orderDetailModel.goodsArray.count;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *nibArr = [[NSBundle mainBundle] loadNibNamed:@"OrderGoodsCell" owner:self options:nil];
    OrderGoodsCell *cell = [nibArr objectAtIndex:0];
    
    return cell.frame.size.height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    OrderGoodsCell *cell = [tableView dequeueReusableCellWithIdentifier:[OrderGoodsCell cellIdentifier]];
    if (cell == nil){
        
        NSArray *nibArr = [[NSBundle mainBundle] loadNibNamed:@"OrderGoodsCell" owner:self options:nil];
        cell = [nibArr objectAtIndex:0];
        
        LineImageView *lineImgV=[[LineImageView alloc]initWithFrame:CGRectMake(10, cell.frame.size.height-1, cell.frame.size.width - 20, 0.5)];
        [cell.contentView addSubview:lineImgV];
        
    }
    
    MyOrderGoodsModel *model = [self.orderDetailModel.goodsArray objectAtIndex:indexPath.row];
    cell.nameLabel.text = model.goods_name;
    cell.numLabel.text = [NSString stringWithFormat:@"数量:%@",model.goods_number];
    cell.attrTypeLabel.text = model.goods_attr;
    cell.priceLabel.text = [NSString priceStringWithOneFloat:model.shop_price];
    
    [cell.goodsImageView setImageWithURL:[NSURL URLWithString:model.goods_thumb]];
  
    
    if ([@"7" isEqualToString:self.orderDetailModel.order_status]) {
        
        [cell.commentBtn setHidden:NO];
        [cell.commentBtn setTag:indexPath.row];
        [cell.commentBtn addTarget:self action:@selector(commentTheOrderAction:) forControlEvents:UIControlEventTouchUpInside];
        
    }

    
    return cell;
    
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    ShoppingDetailVC *vc = [[ShoppingDetailVC alloc]initWithNibName:@"ShoppingDetailVC" bundle:nil];
    
    vc.goodsId = [[self.orderDetailModel.goodsArray objectAtIndex:indexPath.row]goods_id];
    
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)layOutTheOrderView
{
    self.orderIdLabel.text = [NSString stringWithFormat:@"订单编号：%@",self.orderDetailModel.order_sn];
    self.orderTimeLabel.text = [NSString stringWithFormat:@"下单时间：%@",[self.orderDetailModel.add_time switchDateReturnType:3]];
}

#pragma mark - 按钮事件
//取消订单
- (void)cancelOrderAction:(id)sender
{
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];
    
    [self.params removeAllObjects];

    NSString *path = [NSString stringWithFormat:@"/api/ec/user.php?mod=cancel_order&uid=%@&order_id=%@",USERINFO.uid,self.orderId];
    
    [NETWORK_ENGINE requestWithPath:path Params:self.params CompletionHandler:^(MKNetworkOperation *completedOperation) {
        
        NSDictionary *dic=[completedOperation responseDecodeToDic];
        
        NSDictionary *statusDic = [dic objectForKey:@"status"];
        
        if ([@"1" isEqualToString:CHECK_VALUE([statusDic objectForKey:@"statu"])]) {
            
            [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFICATION_REFRESH_ORDERRECORD object:nil];
            [self.navigationController popViewControllerAnimated:YES];
            [SVProgressHUD dismiss];
        }
        else{
            
            [SVProgressHUD showErrorWithStatus:CHECK_VALUE([statusDic objectForKey:@"msg"])];
        }
        
        
    } ErrorHandler:^(MKNetworkOperation *completedOperation, NSError *error) {
        
        [SVProgressHUD showErrorWithStatus:@"服务器忙，请稍候再试"];
        
    }];

}

//继续支付
- (void)continueToPayOrderAction:(id)sender
{
    
}

//提醒发货
- (void)alertTheShopAction:(id)sender
{
    [NETWORK_ENGINE requestWithPath:@"/api/ec/notice.php" Params:self.params CompletionHandler:^(MKNetworkOperation *completedOperation) {
        
        NSString *str = [completedOperation responseDecodeToDic];
        

        [SVProgressHUD showSuccessWithStatus:str];
        
        
    } ErrorHandler:^(MKNetworkOperation *completedOperation, NSError *error) {
        
        [SVProgressHUD showErrorWithStatus:@"服务器忙，请稍候再试"];
        
    }];

}

//查看物流
- (void)lookForLogisticsAction:(id)sender
{
    LogisticsViewController *vc = [[LogisticsViewController alloc]initWithNibName:@"LogisticsViewController" bundle:nil];
    vc.logistisId = self.orderDetailModel.invoice_no;
    vc.logistisName = self.orderDetailModel.shipping_name;
    vc.orderId = self.orderId;
    [self.navigationController pushViewController:vc animated:YES];
    
}

//确认收货
- (void)comfirmRecieveGoodsAction:(id)sender
{
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];
    
    [self.params removeAllObjects];

    NSString *path = [NSString stringWithFormat:@"/api/ec/user.php?mod=affirm_received&uid=%@&order_id=%@",USERINFO.uid,self.orderId];
    
    [NETWORK_ENGINE requestWithPath:path Params:self.params CompletionHandler:^(MKNetworkOperation *completedOperation) {
        
        NSDictionary *dic=[completedOperation responseDecodeToDic];
        
        NSDictionary *statusDic = [dic objectForKey:@"status"];
        
        if ([@"1" isEqualToString:CHECK_VALUE([statusDic objectForKey:@"statu"])]) {
            
            [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFICATION_REFRESH_ORDERRECORD object:nil];
            [self.navigationController popViewControllerAnimated:YES];
            
            [SVProgressHUD dismiss];
        }
        else{
            
            [SVProgressHUD showErrorWithStatus:CHECK_VALUE([statusDic objectForKey:@"msg"])];
        }
        
        
    } ErrorHandler:^(MKNetworkOperation *completedOperation, NSError *error) {
        
        [SVProgressHUD showErrorWithStatus:@"服务器忙，请稍候再试"];
        
    }];

}

//评价订单
- (void)commentTheOrderAction:(id)sender
{
    UIButton *button = (UIButton *)sender;
    
    MyOrderGoodsModel *model = [self.orderDetailModel.goodsArray objectAtIndex:button.tag];
    
    CommentOrderVC *vc = [[CommentOrderVC alloc]initWithNibName:@"CommentOrderVC" bundle:nil];
    vc.goodsModel = model;
    vc.payTime = self.orderDetailModel.pay_time;
    [self.navigationController pushViewController:vc animated:YES];
}

//删除订单
- (void)deleteTheOrderAction:(id)sender
{
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];
    
    [self.params removeAllObjects];
    
    NSString *path = [NSString stringWithFormat:@"/api/ec/user.php?mod=delete_order&uid=%@&order_id=%@",USERINFO.uid,self.orderId];
    
    [NETWORK_ENGINE requestWithPath:path Params:self.params CompletionHandler:^(MKNetworkOperation *completedOperation) {
        
        NSDictionary *dic=[completedOperation responseDecodeToDic];
        
        NSDictionary *statusDic = [dic objectForKey:@"status"];
        
        if ([@"1" isEqualToString:CHECK_VALUE([statusDic objectForKey:@"statu"])]) {
            
            [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFICATION_REFRESH_ORDERRECORD object:nil];
            [self.navigationController popViewControllerAnimated:YES];
            [SVProgressHUD dismiss];
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
