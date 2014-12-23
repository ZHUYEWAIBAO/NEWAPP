//
//  MyOrderListVC.h
//  WomenHealthApp
//
//  Created by 朱青 on 14/12/14.
//  Copyright (c) 2014年 WomenHealthApp. All rights reserved.
//

#import "RefreshTableVC.h"

@interface MyOrderListVC : RefreshTableVC

@property (weak, nonatomic) IBOutlet UITableView *orderListTableView;
@property (weak, nonatomic) IBOutlet UIView *orderEmptyView;

@property (strong, nonatomic) NSMutableArray *orderListArray;

@end
