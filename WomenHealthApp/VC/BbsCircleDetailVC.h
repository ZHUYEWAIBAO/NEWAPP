//
//  BbsCircleDetailVC.h
//  WomenHealthApp
//
//  Created by 朱青 on 15/1/8.
//  Copyright (c) 2015年 WomenHealthApp. All rights reserved.
//

#import "RefreshTableVC.h"

@interface BbsCircleDetailVC : RefreshTableVC

@property (strong, nonatomic) IBOutlet UIView *titleView;

@property (weak, nonatomic) IBOutlet UITableView *circleTableView;

@end
