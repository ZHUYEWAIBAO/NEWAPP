//
//  SetViewController.h
//  WomenHealthApp
//
//  Created by 朱 青 on 14-10-23.
//  Copyright (c) 2014年 WomenHealthApp. All rights reserved.
//

#import "BasicVC.h"

@interface SetViewController : BasicVC

/**
 *  设置页面TableView
 */
@property (weak,nonatomic) IBOutlet UITableView *setTableView;

@property (strong,nonatomic) IBOutlet UIView *loginView;
@property (weak,nonatomic) IBOutlet UIImageView *headImageView;
@property (weak,nonatomic) IBOutlet UILabel *headTitleLabel;

@property (strong,nonatomic) NSMutableArray *setDataArray;

/**
 *  退出登录View
 */
@property (strong,nonatomic) IBOutlet UIView *setExitView;

@end
