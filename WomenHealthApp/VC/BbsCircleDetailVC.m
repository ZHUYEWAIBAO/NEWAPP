//
//  BbsCircleDetailVC.m
//  WomenHealthApp
//
//  Created by 朱青 on 15/1/8.
//  Copyright (c) 2015年 WomenHealthApp. All rights reserved.
//

#import "BbsCircleDetailVC.h"

@interface BbsCircleDetailVC ()

@end

@implementation BbsCircleDetailVC

- (void)loadView
{
    [super loadView];
    
    //允许下拉刷新
    self.tableView = self.circleTableView;
    
    //允许上拉分页加载
    self.isNeedLoadMore=YES;
    self.page = 1;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    UIButton *signBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    signBtn.frame = CGRectMake(0,0,30,30);
    [signBtn setImage:[UIImage imageWithContentFileName:@"publish_btn"] forState:UIControlStateNormal];
    [signBtn addTarget:self action:@selector(signClickAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:signBtn];
    self.navigationItem.rightBarButtonItem = rightItem;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    [_titleView setFrame:CGRectMake(67, 0, _titleView.frame.size.width, _titleView.frame.size.height)];
    [self.navigationController.navigationBar addSubview:_titleView];
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    
    [_titleView removeFromSuperview];
}

#pragma mark - 按钮事件
- (void)signClickAction:(id)sender
{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
