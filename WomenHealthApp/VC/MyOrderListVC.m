//
//  MyOrderListVC.m
//  WomenHealthApp
//
//  Created by 朱青 on 14/12/14.
//  Copyright (c) 2014年 WomenHealthApp. All rights reserved.
//

#import "MyOrderListVC.h"

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
    // Do any additional setup after loading the view from its nib.
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
            
            self.totalRowNum = [CHECK_VALUE([data objectForKey:@"total_recode"]) integerValue];
            
            if (self.totalRowNum == 0) {
//                [self showNothingViewForView:self.shopTableView];
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
                
//                for (NSDictionary *dic in ary) {
//                    GoodsListModel *model = [GoodsListModel parseDicToB2CGoodModelObject:dic];
//                    
//                    [self.shopArray addObject:model];
//                }
                
                if(self.page == 1&&[self.orderListArray count]>0){
                    
                    //tableview返回第一行
                    self.orderListTableView.contentSize = CGSizeMake(320, 0);
                    
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
