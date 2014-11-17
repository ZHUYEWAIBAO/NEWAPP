//
//  RecordDetailVC.m
//  WomenHealthApp
//
//  Created by 朱 青 on 14-11-17.
//  Copyright (c) 2014年 WomenHealthApp. All rights reserved.
//

#import "RecordDetailVC.h"
#import "RecordDetailCell.h"

@interface RecordDetailVC ()
{
    UIView *sectionView;
    BOOL isShowContentView;
}
@end

@implementation RecordDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIButton *rightButton=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
    [rightButton addTarget:self action:@selector(recordDetailSureAction:) forControlEvents:UIControlEventTouchUpInside];
    [rightButton setBackgroundImage:[UIImage imageWithContentFileName:@"Record_detail_sure_btn.png"] forState:UIControlStateNormal];
    UIBarButtonItem *rightButtonItem=[[UIBarButtonItem alloc]initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem = rightButtonItem;
    
    UIButton *leftButton=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
    [leftButton addTarget:self action:@selector(recordDetailBackAction:) forControlEvents:UIControlEventTouchUpInside];
    [leftButton setBackgroundImage:[UIImage imageWithContentFileName:@"Record_detail_date_btn.png"] forState:UIControlStateNormal];
    UIBarButtonItem *leftButtonItem=[[UIBarButtonItem alloc]initWithCustomView:leftButton];
    self.navigationItem.leftBarButtonItem = leftButtonItem;
    
    _imageArray = [[NSMutableArray alloc]initWithObjects:@"Record_detail_love_logo.png",@"Record_detail_tiwen_logo.png",@"Record_detail_zhengzhuang_logo.png",@"Record_detail_weight_logo.png", nil];
    _dataArray = [[NSMutableArray alloc]initWithObjects:@"爱爱",@"体温",@"症状",@"体重", nil];
 
    
//    _detailContentView = [[RecordDetailContentView alloc]initWithFrame:CGRectMake(0, 162, SCREEN_SIZE.width, 0)];
    _detailContentView  =(RecordDetailContentView *)[[[NSBundle mainBundle] loadNibNamed:@"RecordDetailContentView" owner:self options:nil] lastObject];
//    _detailContentView.backgroundColor = [UIColor blackColor];
    [self.headView addSubview:_detailContentView];
    [_detailContentView setFrame:CGRectMake(0, 162, _detailContentView.frame.size.width, 88)];
        _detailContentView.hidden =YES;


    
    self.detailTableView.tableHeaderView = self.headView;
 
}

- (void)recordDetailSureAction:(id)sender
{
    
}

- (void)recordDetailBackAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)showTheDetailContent:(id)sender
{
    if (isShowContentView) {
        [self contentViewReturnToTop];
        _detailContentView.hidden =YES;
    }
    else{
        [self contentViewShow];
        _detailContentView.hidden =NO;
    }
}

- (void)contentViewShow
{

    [UIView animateWithDuration:0.2f animations:^{
 
        [_detailContentView setHidden:NO];
//        [_detailContentView setFrame:CGRectMake(0, 162, _detailContentView.frame.size.width, 88)];
        
        [_headView setFrame:CGRectMake(0, _headView.frame.origin.y, _headView.frame.size.width, 250)];
        //箭头旋转
        self.contentArrowImgView.transform = CGAffineTransformMakeRotation(M_PI);
        self.detailTableView.tableHeaderView = self.headView;
    }];
    isShowContentView = YES;
}

- (void)contentViewReturnToTop
{
    
    [UIView animateWithDuration:0.2f animations:^{
        
       
//        [_detailContentView setFrame:CGRectMake(0, 162, _detailContentView.frame.size.width, 0)];
        
        [_headView setFrame:CGRectMake(0, _headView.frame.origin.y, _headView.frame.size.width, 162)];
        //箭头旋转
        self.contentArrowImgView.transform = CGAffineTransformMakeRotation(M_PI * 2);
        
        self.detailTableView.tableHeaderView = self.headView;
    }];
    
    isShowContentView = NO;

}

#pragma mark UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.dataArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSArray *nibArr = [[NSBundle mainBundle] loadNibNamed:@"RecordDetailCell" owner:self options:nil];
    RecordDetailCell *cell = [nibArr objectAtIndex:0];
    return cell.frame.size.height;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    RecordDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:[RecordDetailCell cellIdentifier]];
    
    if (cell == nil) {
        
        NSArray *nibArr = [[NSBundle mainBundle] loadNibNamed:@"RecordDetailCell" owner:self options:nil];
        cell = [nibArr objectAtIndex:0];
        
        UIImageView *lineImgV=[[UIImageView alloc]initWithFrame:CGRectMake(10, cell.frame.size.height-1, cell.frame.size.width, 0.5)];
        [cell.contentView addSubview:lineImgV];
        [lineImgV setBackgroundColor:RGBACOLOR(199, 199, 204, 1.0)];
        
    }
    cell.detailTitleLabel.text = [self.dataArray objectAtIndex:indexPath.row];
    [cell.detailImageView setImage:[UIImage imageWithContentFileName:[self.imageArray objectAtIndex:indexPath.row]]];
    
    return cell;
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{

    if (nil == sectionView) {
        sectionView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_SIZE.width, 30)];
        sectionView.tintColor=[UIColor clearColor];
    }

    //Title
    UILabel *label = (UILabel *)[sectionView viewWithTag:1002];
    if (label == nil) {
        label = [[UILabel alloc]initWithFrame:CGRectMake(9, 4, 71, 21)];
        label.textAlignment = NSTextAlignmentLeft;
        label.backgroundColor = [UIColor clearColor];
        label.font = [UIFont systemFontOfSize:15.0f];
        label.textColor = [UIColor darkGrayColor];
        label.text = @"日常";
        [label setTag:1002];
        [sectionView addSubview:label];
    }
    
    return sectionView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
