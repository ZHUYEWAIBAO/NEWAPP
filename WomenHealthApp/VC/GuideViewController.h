//
//  GuideViewController.h
//  WomenHealthApp
//
//  Created by 朱青 on 15/1/29.
//  Copyright (c) 2015年 WomenHealthApp. All rights reserved.
//

#import "BasicVC.h"

@interface GuideViewController : BasicVC

@property (weak, nonatomic) IBOutlet UIScrollView *guideScrollView;
@property (strong, nonatomic) NSMutableArray *guideArray;

@end
