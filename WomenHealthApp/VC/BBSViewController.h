//
//  BBSViewController.h
//  WomenHealthApp
//
//  Created by 朱 青 on 14-10-23.
//  Copyright (c) 2014年 WomenHealthApp. All rights reserved.
//

#import "BasicVC.h"

@interface BBSViewController : BasicVC<UIScrollViewDelegate,UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *menuBigTableView;
@property (weak, nonatomic) IBOutlet UITableView *secondMenuTableView;
@property (strong, nonatomic) IBOutlet UIView *secondMenuView;
@property (strong, nonatomic) IBOutlet UIImageView *cateArrowImgV;
@property (strong, nonatomic) IBOutlet UIImageView *lineImgV;

@property (strong, nonatomic) NSMutableArray *bigMenuArray;

@property (strong, nonatomic) NSMutableArray *subMenuArray;



@end
