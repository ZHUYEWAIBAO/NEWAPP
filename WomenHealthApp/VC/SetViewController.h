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

@property (strong,nonatomic) NSMutableArray *setDataArray;

@end
