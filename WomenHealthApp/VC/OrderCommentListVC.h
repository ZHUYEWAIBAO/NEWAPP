//
//  OrderCommentListVC.h
//  WomenHealthApp
//
//  Created by 朱青 on 14/12/18.
//  Copyright (c) 2014年 WomenHealthApp. All rights reserved.
//

#import "RefreshTableVC.h"

@interface OrderCommentListVC : RefreshTableVC

@property (weak, nonatomic) IBOutlet UITableView *commentTableView;

@property (strong, nonatomic) NSMutableArray *commentArray;

@property (strong, nonatomic) NSString *commentId;

@end
