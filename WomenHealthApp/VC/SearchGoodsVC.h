//
//  SearchGoodsVC.h
//  WomenHealthApp
//
//  Created by 朱青 on 14/12/4.
//  Copyright (c) 2014年 WomenHealthApp. All rights reserved.
//

#import "BasicVC.h"

@interface SearchGoodsVC : BasicVC

@property (strong, nonatomic) IBOutlet UIView *searchNavView;

@property (weak, nonatomic) IBOutlet UITextField *searchTextField;
@property (weak, nonatomic) IBOutlet UITableView *hisStoryTableView;
@property (weak, nonatomic) IBOutlet UIView *searchView;

@property (strong, nonatomic) IBOutlet UIView *clearSearchView;

@end
