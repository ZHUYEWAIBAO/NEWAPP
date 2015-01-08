//
//  BbsSearchResultVC.h
//  WomenHealthApp
//
//  Created by 朱青 on 15/1/8.
//  Copyright (c) 2015年 WomenHealthApp. All rights reserved.
//

#import "BasicVC.h"

@interface BbsSearchResultVC : BasicVC

@property (strong, nonatomic) NSString *currentKeyWords;

@property (strong, nonatomic) NSMutableArray *circleArray;

@property (weak, nonatomic) IBOutlet UITableView *searchTableView;

@property (weak, nonatomic) IBOutlet UIView *searchEmptyView;


@end
