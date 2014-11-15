//
//  BBSViewController.h
//  WomenHealthApp
//
//  Created by 朱 青 on 14-10-23.
//  Copyright (c) 2014年 WomenHealthApp. All rights reserved.
//

#import "BasicVC.h"

@interface BBSViewController : BasicVC<UIScrollViewDelegate,UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *addScrollview;


@property (weak, nonatomic) IBOutlet UITableView *bbsTableView;

@end
