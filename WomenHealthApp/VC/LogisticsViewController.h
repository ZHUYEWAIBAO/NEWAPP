//
//  LogisticsViewController.h
//  WomenHealthApp
//
//  Created by 朱青 on 14/12/17.
//  Copyright (c) 2014年 WomenHealthApp. All rights reserved.
//

#import "BasicVC.h"

@interface LogisticsViewController : BasicVC

@property (strong, nonatomic) NSMutableArray *logisticsArray;

@property (strong, nonatomic) NSString *orderId;

@property (strong, nonatomic) NSString *logistisName;
@property (strong, nonatomic) NSString *logistisId;

@property (strong, nonatomic) IBOutlet UIView *headView;

@property (weak, nonatomic) IBOutlet UITableView *logisticsTableView;
@property (weak, nonatomic) IBOutlet UILabel *logisticsIdLabel;
@property (weak, nonatomic) IBOutlet UILabel *logisticsNameLabel;

@end
