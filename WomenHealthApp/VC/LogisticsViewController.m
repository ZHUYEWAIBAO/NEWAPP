//
//  LogisticsViewController.m
//  WomenHealthApp
//
//  Created by 朱青 on 14/12/17.
//  Copyright (c) 2014年 WomenHealthApp. All rights reserved.
//

#import "LogisticsViewController.h"
#import "LogisticsModel.h"
#import "LogisticsCell.h"
#import "LineImageView.h"

@interface LogisticsViewController ()

@end

@implementation LogisticsViewController

- (void)loadView
{
    [super loadView];
    
    self.title = @"物流详情";
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _logisticsArray = [[NSMutableArray alloc]initWithCapacity:0];
    
    self.logisticsIdLabel.text = [NSString stringWithFormat:@"物流单号：%@",self.logistisId];
    self.logisticsNameLabel.text = [NSString stringWithFormat:@"物流公司：%@",self.logistisName];
    
    [self getTheLogisticsDataWithOrderId:self.orderId];
}

- (void)getTheLogisticsDataWithOrderId:(NSString *)orderId
{
    
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];

    NSString *path = [NSString stringWithFormat:@"/api/ec/user.php?mod=express&uid=%@&order_id=%@",USERINFO.uid,self.orderId];
    
    [NETWORK_ENGINE requestWithPath:path Params:nil CompletionHandler:^(MKNetworkOperation *completedOperation) {
        
        NSDictionary *dic = [completedOperation responseDecodeToDic];
        
        NSDictionary *statusDic = [dic objectForKey:@"status"];
        
        if ([@"1" isEqualToString:CHECK_VALUE([statusDic objectForKey:@"statu"])]) {
            
            NSDictionary *data = [dic objectForKey:@"data"];
         
            NSArray *ary = CHECK_ARRAY_VALUE([data objectForKey:@"express"]);
            
            if (ary.count>0) {
      
                for (NSDictionary *dic in ary) {
                    LogisticsModel *model = [LogisticsModel parseDicToLogisticsObject:dic];
                    
                    [self.logisticsArray addObject:model];
                }

            }
            self.logisticsTableView.tableHeaderView = self.headView;
            [self.logisticsTableView reloadData];
            
            [SVProgressHUD dismiss];
    
        }
        else{
            [SVProgressHUD showErrorWithStatus:CHECK_VALUE([statusDic objectForKey:@"msg"])];
        }
        
    } ErrorHandler:^(MKNetworkOperation *completedOperation, NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"服务器忙，请稍候再试"];

    }];

}

#pragma mark UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return self.logisticsArray.count;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *nibArr = [[NSBundle mainBundle] loadNibNamed:@"LogisticsCell" owner:self options:nil];
    LogisticsCell *cell = [nibArr objectAtIndex:0];
    
    return cell.frame.size.height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    LogisticsCell *cell = [tableView dequeueReusableCellWithIdentifier:[LogisticsCell cellIdentifier]];
    if (cell == nil){
        
        NSArray *nibArr = [[NSBundle mainBundle] loadNibNamed:@"LogisticsCell" owner:self options:nil];
        cell = [nibArr objectAtIndex:0];
        
        LineImageView *lineImgV=[[LineImageView alloc]initWithFrame:CGRectMake(10, cell.frame.size.height-1, cell.frame.size.width - 20, 0.5)];
        [cell.contentView addSubview:lineImgV];
        
    }
    
    LogisticsModel *model = [self.logisticsArray objectAtIndex:indexPath.row];
    cell.contextLabel.text = model.context;
    cell.timeLabel.text = model.time;


    return cell;
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
