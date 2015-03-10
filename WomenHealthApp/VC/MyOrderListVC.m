//
//  MyOrderListVC.m
//  WomenHealthApp
//
//  Created by 朱青 on 14/12/14.
//  Copyright (c) 2014年 WomenHealthApp. All rights reserved.
//

#import "MyOrderListVC.h"
#import "MyOrderListModel.h"
#import "MyOrderListCell.h"
#import "MyOrderDetailVC.h"
#import "LogisticsViewController.h"
#import "CommentOrderVC.h"
#import "OrderPayModel.h"
#import "DataSigner.h"
#import "ShoppingPaySuccessVC.h"
#import "CannelOrderVC.h"
#import <AlipaySDK/AlipaySDK.h>

@interface MyOrderListVC ()

@end

@implementation MyOrderListVC

- (void)loadView
{
    [super loadView];
    
    self.title = @"我的订单";
    
    //允许下拉刷新
    self.tableView = self.orderListTableView;
    
    //允许上拉分页加载
    self.isNeedLoadMore=YES;
    self.page = 1;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshTheListAction:) name:NOTIFICATION_REFRESH_ORDERRECORD object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(payCallBackAction:) name:NOTIFICATION_ALIPAY object:nil];
    
    _orderListArray = [[NSMutableArray alloc]initWithCapacity:0];
    
    [self getTheListData];
}

- (void)refreshTheListAction:(id)sender
{
    self.page = 1;
    [self getTheListData];
}

#pragma mark - 获取订单列表
- (void)getTheListData
{
    if (self.page == 1) {
        [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];
    }
    
    NSString *path = [NSString stringWithFormat:@"/api/ec/user.php?mod=order_list&uid=%@&page=%ld",USERINFO.uid,self.page];
    
    [NETWORK_ENGINE requestWithPath:path Params:nil CompletionHandler:^(MKNetworkOperation *completedOperation) {
        
        NSDictionary *dic = [completedOperation responseDecodeToDic];
        
        NSDictionary *statusDic = [dic objectForKey:@"status"];
        
        if ([@"1" isEqualToString:CHECK_VALUE([statusDic objectForKey:@"statu"])]) {
            
            NSDictionary *data = [dic objectForKey:@"data"];
            
            NSDictionary *totalData = [data objectForKey:@"total"];
            
            self.totalRowNum = [CHECK_VALUE([totalData objectForKey:@"total_count"]) integerValue];
            
            if (self.totalRowNum == 0) {
                [self showOrderEmptyView];
                [self.orderListArray removeAllObjects];
                self.footview.hidden=YES;
            }
 
            NSArray *ary = CHECK_ARRAY_VALUE([data objectForKey:@"list"]);
            
            if (ary.count>0) {
                //如果是第一页，清空数组
                if (self.page == 1) {
                    [self.orderListArray removeAllObjects];
                    self.footview.hidden=NO;
                }
                
                for (NSDictionary *dic in ary) {
                    MyOrderListModel *model = [MyOrderListModel parseDicToMyOrderListObject:dic];
                    
                    [self.orderListArray addObject:model];
                }
                
                if(self.page == 1&&[self.orderListArray count]>0){
                    
                    //tableview返回第一行
                    self.orderListTableView.contentSize = CGSizeMake(SCREEN_SIZE.width, 0);
                    
                }
                //当前数据小于总数据的时候页数++
                if (self.orderListArray.count < self.totalRowNum) {
                    self.page++;
                }
                else{
                    self.footview.hidden=YES;
                }
                
            }
            [self.orderListTableView reloadData];
            
            [SVProgressHUD dismiss];
            
            [self doneLoadingTableViewData];
            [self.footview endRefreshing];
            
        }
        else{
            [SVProgressHUD showErrorWithStatus:CHECK_VALUE([statusDic objectForKey:@"msg"])];
        }
        
    } ErrorHandler:^(MKNetworkOperation *completedOperation, NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"服务器忙，请稍候再试"];
        [self doneLoadingTableViewData];
        [self.footview endRefreshing];
    }];
    
}

#pragma mark UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return self.orderListArray.count;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{

    MyOrderListModel *model = [self.orderListArray objectAtIndex:indexPath.row];

    return 90 * model.goodsArray.count + 142;

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    MyOrderListCell *cell = [tableView dequeueReusableCellWithIdentifier:[MyOrderListCell cellIdentifier]];
    if (cell == nil){
        
        NSArray *nibArr = [[NSBundle mainBundle] loadNibNamed:@"MyOrderListCell" owner:self options:nil];
        cell = [nibArr objectAtIndex:0];
        
    }
    [cell layOutTheHeadView];
    [cell layOutTheFootView];
    
    MyOrderListModel *model = [self.orderListArray objectAtIndex:indexPath.row];
    
    CGRect rect = cell.goodsTableView.frame;
    rect.size.height = 90 * model.goodsArray.count + 132;
    cell.goodsTableView.frame = rect;
    
    CGRect rect2 = cell.frame;
    rect2.size.height = cell.goodsTableView.frame.size.height + 10;
    cell.frame = rect2;
    
    CGRect rect3 = cell.orderButton.frame;
    rect3.size.height = cell.goodsTableView.frame.size.height - 44;
    cell.orderButton.frame = rect3;

    cell.orderButton.tag = indexPath.row;
    
    [cell setItemWithArray:model.goodsArray orderStatus:model.order_status currentRow:indexPath.row target:self detailAction:@selector(orderClickAction:) commentAction:@selector(commentTheOrderAction:)];
    
    NSInteger count = 0;
    for (NSInteger i = 0; i < model.goodsArray.count; i++) {
        MyOrderGoodsModel *goodModel = [model.goodsArray objectAtIndex:i];
        count+=[goodModel.goods_number integerValue];
    }
    cell.footView.numLabel.text = [NSString stringWithFormat:@"共计%ld件商品，实付(含运费)：",count];
    cell.footView.priceLabel.text = [NSString priceStringWithOneFloat:model.total_fee];
    
    [cell.footView.firstButton setTag:100 + indexPath.row];
    [cell.footView.secondButton setTag:200 + indexPath.row];
    
    [cell.footView.firstButton addTarget:self action:@selector(firstBtnClickAction:) forControlEvents:UIControlEventTouchUpInside];
    [cell.footView.secondButton addTarget:self action:@selector(secondBtnClickAction:) forControlEvents:UIControlEventTouchUpInside];
    
    switch ([model.order_status integerValue]) {
        case 2:{
            cell.headView.statusLabel.text = @"未付款";
            [cell.footView.firstButton setBackgroundImage:[UIImage imageWithContentFileName:@"order_qufukuan_btn"] forState:UIControlStateNormal];
            [cell.footView.secondButton setBackgroundImage:[UIImage imageWithContentFileName:@"order_quxiaodingdan_btn"] forState:UIControlStateNormal];
        }
            break;
            
        case 3:{
            cell.headView.statusLabel.text = @"待发货";
            [cell.footView.firstButton setBackgroundImage:[UIImage imageWithContentFileName:@"order_fahuo_btn"] forState:UIControlStateNormal];
            [cell.footView.secondButton setHidden:YES];
        }
            break;
            
        case 4:{
            cell.headView.statusLabel.text = @"已发货";
            [cell.footView.firstButton setBackgroundImage:[UIImage imageWithContentFileName:@"order_querenshouhuo_btn"] forState:UIControlStateNormal];
            [cell.footView.secondButton setBackgroundImage:[UIImage imageWithContentFileName:@"order_chakanwuliu_btn"] forState:UIControlStateNormal];
        }
            break;
            
        case 5:{
            cell.headView.statusLabel.text = @"交易关闭";
//            [cell.footView.firstButton setBackgroundImage:[UIImage imageWithContentFileName:@"order_delete_btn"] forState:UIControlStateNormal];
            [cell.footView.firstButton setHidden:YES];
            [cell.footView.secondButton setHidden:YES];
        }
            break;
            
        case 7:{
            cell.headView.statusLabel.text = @"已完成";
//            [cell.footView.firstButton setBackgroundImage:[UIImage imageWithContentFileName:@"order_delete_btn"] forState:UIControlStateNormal];
            [cell.footView.firstButton setHidden:YES];
            [cell.footView.secondButton setHidden:YES];
        }
            break;
            
        default:
            break;
    }
    return cell;
    
    
}

- (void)firstBtnClickAction:(id)sender
{
    MyOrderListModel *model = [self.orderListArray objectAtIndex:[(UIButton *)sender tag]-100];
    switch ([model.order_status integerValue]) {
        case 2:{
            [self continueToPayOrderAction:model.order_id withPrice:model.total_fee];
        }
            break;
            
        case 3:{
            [self alertTheShopAction];
        }
            break;
            
        case 4:{
            [self comfirmRecieveGoodsAction:model.order_id];
        }
            break;
            
        case 5:{
            [self deleteTheOrderAction:model.order_id];
        }
            break;
            
        case 7:{
            [self deleteTheOrderAction:model.order_id];
        }
            break;
            
        default:
            break;
    }

}

- (void)secondBtnClickAction:(id)sender
{
    MyOrderListModel *model = [self.orderListArray objectAtIndex:[(UIButton *)sender tag]-200];
    switch ([model.order_status integerValue]) {
        case 2:{
            [self cancelOrderAction:model.order_id];
        }
            break;

        case 4:{
            
            LogisticsViewController *vc = [[LogisticsViewController alloc]initWithNibName:@"LogisticsViewController" bundle:nil];
            vc.logistisId = model.invoice_no;
            vc.logistisName = model.shipping_name;
            vc.orderId = model.order_id;
            [self.navigationController pushViewController:vc animated:YES];
            
        }
            break;
   
        default:
            break;
    }

}

#pragma mark - 按钮事件
//取消订单
- (void)cancelOrderAction:(NSString *)orderId
{
//    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];
//    
//    [self.params removeAllObjects];
//    
//    NSString *path = [NSString stringWithFormat:@"/api/ec/user.php?mod=cancel_order&uid=%@&order_id=%@",USERINFO.uid,orderId];
//    
//    [NETWORK_ENGINE requestWithPath:path Params:self.params CompletionHandler:^(MKNetworkOperation *completedOperation) {
//        
//        NSDictionary *dic=[completedOperation responseDecodeToDic];
//        
//        NSDictionary *statusDic = [dic objectForKey:@"status"];
//        
//        if ([@"1" isEqualToString:CHECK_VALUE([statusDic objectForKey:@"statu"])]) {
//            
//            [SVProgressHUD dismiss];
//            
//            self.page = 1;
//            [self getTheListData];
//            
//        }
//        else{
//            
//            [SVProgressHUD showErrorWithStatus:CHECK_VALUE([statusDic objectForKey:@"msg"])];
//        }
//        
//        
//    } ErrorHandler:^(MKNetworkOperation *completedOperation, NSError *error) {
//        
//        [SVProgressHUD showErrorWithStatus:@"服务器忙，请稍候再试"];
//        
//    }];
    CannelOrderVC *vc = [[CannelOrderVC alloc]initWithNibName:@"CannelOrderVC" bundle:nil];
    vc.orderId = orderId;
    [self.navigationController pushViewController:vc animated:YES];
    
}

//继续支付
- (void)continueToPayOrderAction:(NSString *)orderId withPrice:(NSString *)price
{
    
    /*
     *生成订单信息及签名
     */
    //将商品信息赋予AlixPayOrder的成员变量
    OrderPayModel *order = [[OrderPayModel alloc] init];
    order.tradeNO = orderId; //订单ID（由商家自行制定）
    order.amount = price; //商品价格
    
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
            
            //如果没安装支付宝客户端走这边
            NSLog(@"reslut = %@",resultDic);
            
            if (resultDic){
                if ([@"9000" isEqualToString:[resultDic objectForKey:@"resultStatus"]]){
                    
                    [SVProgressHUD showSuccessWithStatus:@"支付成功"];
                    
                    ShoppingPaySuccessVC *vc = [[ShoppingPaySuccessVC alloc]initWithNibName:@"ShoppingPaySuccessVC" bundle:nil];
                    [self.navigationController pushViewController:vc animated:YES];
                    
                }
                else{
                    //交易失败
                    [SVProgressHUD showErrorWithStatus:@"支付失败"];
                }
            }
            else{
                //交易失败
                [SVProgressHUD showErrorWithStatus:@"支付失败"];
                
            }
            
        }];
        
    }

}

//安装支付宝客户端走这边
- (void)payCallBackAction:(NSNotification *)notifi
{
    ShoppingPaySuccessVC *vc = [[ShoppingPaySuccessVC alloc]initWithNibName:@"ShoppingPaySuccessVC" bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
}

//提醒发货
- (void)alertTheShopAction
{
    [NETWORK_ENGINE requestWithPath:@"/api/ec/notice.php" Params:self.params CompletionHandler:^(MKNetworkOperation *completedOperation) {
        
        [SVProgressHUD showSuccessWithStatus:@"提醒成功"];
        
        
    } ErrorHandler:^(MKNetworkOperation *completedOperation, NSError *error) {
        
        [SVProgressHUD showErrorWithStatus:@"服务器忙，请稍候再试"];
        
    }];
    
}


//确认收货
- (void)comfirmRecieveGoodsAction:(NSString *)orderId
{
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];
    
    [self.params removeAllObjects];
    
    NSString *path = [NSString stringWithFormat:@"/api/ec/user.php?mod=affirm_received&uid=%@&order_id=%@",USERINFO.uid,orderId];
    
    [NETWORK_ENGINE requestWithPath:path Params:self.params CompletionHandler:^(MKNetworkOperation *completedOperation) {
        
        NSDictionary *dic=[completedOperation responseDecodeToDic];
        
        NSDictionary *statusDic = [dic objectForKey:@"status"];
        
        if ([@"1" isEqualToString:CHECK_VALUE([statusDic objectForKey:@"statu"])]) {
            
            [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFICATION_REFRESH_ORDERRECORD object:nil];
           
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
    
    MyOrderListModel *model = [self.orderListArray objectAtIndex:button.tag/100 - 1];
    MyOrderGoodsModel *goodModel = [model.goodsArray objectAtIndex:button.tag % 100];
    
    CommentOrderVC *vc = [[CommentOrderVC alloc]initWithNibName:@"CommentOrderVC" bundle:nil];
    vc.goodsModel = goodModel;
    vc.orderId = model.order_id;
    vc.payTime = model.pay_time;
    [self.navigationController pushViewController:vc animated:YES];
}

//删除订单
- (void)deleteTheOrderAction:(NSString *)orderId
{
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];
    
    [self.params removeAllObjects];
    
    NSString *path = [NSString stringWithFormat:@"/api/ec/user.php?mod=delete_order&uid=%@&order_id=%@",USERINFO.uid,orderId];
    
    [NETWORK_ENGINE requestWithPath:path Params:self.params CompletionHandler:^(MKNetworkOperation *completedOperation) {
        
        NSDictionary *dic=[completedOperation responseDecodeToDic];
        
        NSDictionary *statusDic = [dic objectForKey:@"status"];
        
        if ([@"1" isEqualToString:CHECK_VALUE([statusDic objectForKey:@"statu"])]) {
            
            [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFICATION_REFRESH_ORDERRECORD object:nil];
            
            [SVProgressHUD dismiss];
        }
        else{
            
            [SVProgressHUD showErrorWithStatus:CHECK_VALUE([statusDic objectForKey:@"msg"])];
        }
        
        
    } ErrorHandler:^(MKNetworkOperation *completedOperation, NSError *error) {
        
        [SVProgressHUD showErrorWithStatus:@"服务器忙，请稍候再试"];
        
    }];
}

- (void)orderClickAction:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    
    MyOrderListModel *model = [self.orderListArray objectAtIndex:btn.tag];
    
    MyOrderDetailVC *vc = [[MyOrderDetailVC alloc]initWithNibName:@"MyOrderDetailVC" bundle:nil];
    vc.orderId = model.order_id;
    [self.navigationController pushViewController:vc animated:YES];
    
    
}

#pragma mark - 分页加载
//上拉分页加载
- (void)refreshViewBeginRefreshing:(MJRefreshBaseView *)refreshView
{
    if (refreshView == self.footview){
        [self getTheListData];
    }
}

#pragma mark - 下拉刷新
- (void)reloadTableViewDataSource
{
    if (self.isLoading) { return;}
    self.page = 1;
    [self getTheListData];
    [super reloadTableViewDataSource];
}

- (void)showOrderEmptyView
{
    [self.orderListTableView setHidden:YES];
    [self.orderEmptyView setHidden:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
