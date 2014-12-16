//
//  PayTypeChooseVC.m
//  WomenHealthApp
//
//  Created by 朱青 on 14/12/13.
//  Copyright (c) 2014年 WomenHealthApp. All rights reserved.
//

#import "PayTypeChooseVC.h"
#import "PayTypeModel.h"
#import "PayTypeCell.h"

@interface PayTypeChooseVC ()
{
    NSString *currentPayTypeId;
}

@end

@implementation PayTypeChooseVC

- (void)loadView
{
    [super loadView];
    
    self.title = @"支付方式";
    currentPayTypeId = @"4";  //默认支付宝支付
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIButton *rightButton=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
    [rightButton addTarget:self action:@selector(payTypeSureAction:) forControlEvents:UIControlEventTouchUpInside];
    [rightButton setBackgroundImage:[UIImage imageWithContentFileName:@"Record_detail_sure_btn.png"] forState:UIControlStateNormal];
    UIBarButtonItem *rightButtonItem=[[UIBarButtonItem alloc]initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem = rightButtonItem;
    
    NSMutableArray *array = [PayTypeModel arrayForPayType];
    self.payTypeArray = array;
    [self.payTypeTableView reloadData];
                                     
}

- (void)payTypeSureAction:(id)sender
{
    [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFICATION_PAYTYPE_SELECT object:currentPayTypeId];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return self.payTypeArray.count;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *nibArr = [[NSBundle mainBundle] loadNibNamed:@"PayTypeCell" owner:self options:nil];
    PayTypeCell *cell = [nibArr objectAtIndex:0];
    
    return cell.frame.size.height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    PayTypeCell *cell = [tableView dequeueReusableCellWithIdentifier:[PayTypeCell cellIdentifier]];
    if (cell == nil){
        
        NSArray *nibArr = [[NSBundle mainBundle] loadNibNamed:@"PayTypeCell" owner:self options:nil];
        cell = [nibArr objectAtIndex:0];
        
    }
    
    PayTypeModel *model = [self.payTypeArray objectAtIndex:indexPath.row];
    cell.typeLabel.text = model.payTypeName;

    if ([@"4" isEqualToString:model.payTypeId]) {
        [cell.typeImageView setImage:[UIImage imageWithContentFileName:@"zhifubao_logo"]];
        [cell.typeBtn setImage:[UIImage imageWithContentFileName:@"pay_chose_yes"] forState:UIControlStateNormal];
    }
    else{
        [cell.typeImageView setImage:[UIImage imageWithContentFileName:@"weixing_logo"]];
        [cell.typeBtn setImage:[UIImage imageWithContentFileName:@"pay_chose"] forState:UIControlStateNormal];
    }
    [cell.typeBtn setTag:indexPath.row];
    [cell.typeBtn addTarget:self action:@selector(payTypeChoose:) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
    
    
}

- (void)payTypeChoose:(id)sender
{
    for (int i = 0; i < self.payTypeArray.count; i++) {
        PayTypeCell *cell = (PayTypeCell *)[self.payTypeTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
        [cell.typeBtn setImage:[UIImage imageWithContentFileName:@"pay_chose"] forState:UIControlStateNormal];
    }
    
    UIButton *button = (UIButton *)sender;
    PayTypeCell *cell = (PayTypeCell *)[self.payTypeTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:button.tag inSection:0]];
    [cell.typeBtn setImage:[UIImage imageWithContentFileName:@"pay_chose_yes"] forState:UIControlStateNormal];
    
    currentPayTypeId = [[self.payTypeArray objectAtIndex:button.tag]payTypeId];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
