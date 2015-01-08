//
//  BbsSearchVC.h
//  WomenHealthApp
//
//  Created by Daniel on 14/11/15.
//  Copyright (c) 2014年 WomenHealthApp. All rights reserved.
//

#import "BasicVC.h"

@interface BbsSearchVC : BasicVC

@property (strong, nonatomic) IBOutlet UIView *searchNavView;

@property (weak, nonatomic) IBOutlet UITextField *searchTextField;
@property (weak, nonatomic) IBOutlet UITableView *hisStoryTableView;
@property (weak, nonatomic) IBOutlet UIView *searchView;

@property (strong, nonatomic) IBOutlet UIView *clearSearchView;

@end
