//
//  ShoppingViewController.h
//  WomenHealthApp
//
//  Created by 朱 青 on 14-10-23.
//  Copyright (c) 2014年 WomenHealthApp. All rights reserved.
//

#import "RefreshTableVC.h"
#import "CycleScrollView.h"

@interface ShoppingViewController : RefreshTableVC

@property (weak, nonatomic) IBOutlet UITableView *shopTableView;

@property (strong, nonatomic) IBOutlet UIView *headView;
@property (weak, nonatomic) IBOutlet UIScrollView *hotKeyScrollView;
@property (weak, nonatomic) IBOutlet UIImageView *priceSortLogoImageView;

@property (strong, nonatomic) NSMutableArray *shopArray;

@property (strong, nonatomic) CycleScrollView *mainScorllView;

@property (weak, nonatomic) IBOutlet UIView *searchEmptyView;


@end
