//
//  PostDetailVC.h
//  WomenHealthApp
//
//  Created by 朱青 on 15/1/14.
//  Copyright (c) 2015年 WomenHealthApp. All rights reserved.
//

#import "RefreshTableVC.h"

@interface PostDetailVC : RefreshTableVC

@property (weak, nonatomic) IBOutlet UITableView *postTableView;

@property (strong, nonatomic) IBOutlet UIView *headView;

@property (weak, nonatomic) IBOutlet UIImageView *jingImageView;
@property (weak, nonatomic) IBOutlet UIImageView *lineImageView;
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalLabel;
@property (weak, nonatomic) IBOutlet UILabel *circleLabel;
@property (weak, nonatomic) IBOutlet UIButton *circleBtn;

@property (strong, nonatomic) NSMutableArray *postListArray;

@property (strong, nonatomic) NSString *currentTid;

@property (assign, nonatomic) BOOL isFromMyCircle; //从我的圈子列表进入

@end
