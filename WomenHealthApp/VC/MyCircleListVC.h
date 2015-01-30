//
//  MyCircleListVC.h
//  WomenHealthApp
//
//  Created by 朱青 on 15/1/21.
//  Copyright (c) 2015年 WomenHealthApp. All rights reserved.
//

#import "RefreshTableVC.h"

//状态
typedef enum MyCircleType_
{
    circleType_myPost = 1,     //我发表的
    circleType_myReturn,       //我回复的
    
}MyCircleType;

@interface MyCircleListVC : RefreshTableVC

@property (strong, nonatomic) IBOutlet UIView *titleView;

@property (weak, nonatomic) IBOutlet UITableView *circleTableView;

@property (strong, nonatomic) IBOutlet UIButton *editBtn;
@property (assign, nonatomic) MyCircleType circleType;

@property (weak, nonatomic) IBOutlet UIButton *myPostBtn;
@property (weak, nonatomic) IBOutlet UIButton *myReturnBtn;

@property (strong, nonatomic) NSMutableArray *titeBtnArray;

@property (strong, nonatomic) NSMutableArray *circleArray1;//我发表的
@property (strong, nonatomic) NSMutableArray *circleArray2;//我回复的
@property (strong, nonatomic) NSMutableArray *circleArray;

@end
