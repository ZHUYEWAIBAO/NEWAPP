//
//  SearchResultVC.h
//  WomenHealthApp
//
//  Created by 朱青 on 14/12/4.
//  Copyright (c) 2014年 WomenHealthApp. All rights reserved.
//

#import "RefreshTableVC.h"

@interface SearchResultVC : RefreshTableVC

@property (weak, nonatomic) IBOutlet UITableView *searchTableView;
@property (weak, nonatomic) IBOutlet UIImageView *priceSortLogoImageView;

@property (weak, nonatomic) IBOutlet UIView *searchEmptyView;
@property (weak, nonatomic) IBOutlet UIView *sortView;

@property (strong, nonatomic) NSMutableArray *shopArray;

@property (strong, nonatomic) NSString *currentKeyWords;

@end
