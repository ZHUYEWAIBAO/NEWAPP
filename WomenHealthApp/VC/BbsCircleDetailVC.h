//
//  BbsCircleDetailVC.h
//  WomenHealthApp
//
//  Created by 朱青 on 15/1/8.
//  Copyright (c) 2015年 WomenHealthApp. All rights reserved.
//

#import "RefreshTableVC.h"

//圈子状态
typedef enum CircleType_
{
    circleType_all = 1,     //全部
    circleType_fresh,       //新鲜
    circleType_best,        //精华
}CircleType;

@interface BbsCircleDetailVC : RefreshTableVC

@property (strong, nonatomic) IBOutlet UIView *titleView;
@property (strong, nonatomic) IBOutlet UIView *headView;

@property (weak, nonatomic) IBOutlet UIView *nameView;
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameDesLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalLabel;
@property (weak, nonatomic) IBOutlet UILabel *todayLabel;
@property (weak, nonatomic) IBOutlet UIButton *searchBtn;

@property (weak, nonatomic) IBOutlet UIView *hotView;

@property (weak, nonatomic) IBOutlet UITableView *circleTableView;

@property (assign, nonatomic) CircleType circleType;

@property (strong, nonatomic) NSString *currentFid;

@property (weak, nonatomic) IBOutlet UIButton *allBtn;
@property (weak, nonatomic) IBOutlet UIButton *bestBtn;
@property (weak, nonatomic) IBOutlet UIButton *freshBtn;
@property (strong, nonatomic) NSMutableArray *titeBtnArray;

@property (strong, nonatomic) NSMutableArray *circleArray1;//全部数组
@property (strong, nonatomic) NSMutableArray *circleArray2;//新鲜数组
@property (strong, nonatomic) NSMutableArray *circleArray3;//精华数组
@property (strong, nonatomic) NSMutableArray *circleArray;

@end
