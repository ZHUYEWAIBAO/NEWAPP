//
//  PostSearchVC.h
//  WomenHealthApp
//
//  Created by 朱青 on 15/1/12.
//  Copyright (c) 2015年 WomenHealthApp. All rights reserved.
//

#import "RefreshTableVC.h"

@interface PostSearchVC : RefreshTableVC

@property (strong, nonatomic) NSString *currentKeyWords;

@property (strong, nonatomic) NSMutableArray *postArray;

@property (weak, nonatomic) IBOutlet UITableView *searchTableView;

@property (weak, nonatomic) IBOutlet UIView *searchEmptyView;

@end
