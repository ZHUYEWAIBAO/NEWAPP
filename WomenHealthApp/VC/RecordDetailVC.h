//
//  RecordDetailVC.h
//  WomenHealthApp
//
//  Created by 朱 青 on 14-11-17.
//  Copyright (c) 2014年 WomenHealthApp. All rights reserved.
//

#import "BasicVC.h"
#import "RecordDetailContentView.h"

@interface RecordDetailVC : BasicVC

@property (weak, nonatomic) IBOutlet UITableView *detailTableView;
@property (weak, nonatomic) IBOutlet UIImageView *contentArrowImgView;

@property (strong, nonatomic) RecordDetailContentView *detailContentView;
@property (strong, nonatomic) IBOutlet UIView *headView;

@property (strong, nonatomic) NSMutableArray *dataArray;
@property (strong, nonatomic) NSMutableArray *imageArray;

@end