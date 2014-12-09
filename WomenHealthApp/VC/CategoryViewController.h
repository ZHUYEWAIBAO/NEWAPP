//
//  CategoryViewController.h
//  WomenHealthApp
//
//  Created by 朱青 on 14/12/3.
//  Copyright (c) 2014年 WomenHealthApp. All rights reserved.
//

#import "BasicVC.h"
#import "CSLinearLayoutView.h"

#define catebuttonInSetx 8
#define catebuttonInSety 8
#define catebuttonHeight 30
#define catebuttonWidth  96

@interface CategoryViewController : BasicVC

@property (strong, nonatomic) IBOutlet UIView *goodsMenuView;
@property (strong, nonatomic) IBOutlet UIView *priceHeadView;
@property (strong, nonatomic) IBOutlet UIView *goodsTypeView;

@property (weak, nonatomic) IBOutlet UITextField *minTextField;
@property (weak, nonatomic) IBOutlet UITextField *maxTextField;

@property (weak, nonatomic) IBOutlet CSLinearLayoutView *linearLayoutView;

@end
