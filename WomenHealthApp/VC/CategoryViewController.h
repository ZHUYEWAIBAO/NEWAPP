//
//  CategoryViewController.h
//  WomenHealthApp
//
//  Created by 朱青 on 14/12/3.
//  Copyright (c) 2014年 WomenHealthApp. All rights reserved.
//

#import "BasicVC.h"
#import "CSLinearLayoutView.h"

#define buttonInSetx 8
#define buttonInSety 8
#define buttonHeight 30
#define buttonWidth  96

@interface CategoryViewController : BasicVC

@property (strong, nonatomic) IBOutlet UIView *goodsMenuView;
@property (strong, nonatomic) IBOutlet UIView *priceHeadView;
@property (strong, nonatomic) IBOutlet UIView *goodsTypeView;

@property (weak, nonatomic) IBOutlet UITextField *minTextField;
@property (weak, nonatomic) IBOutlet UITextField *maxTextField;

@property (weak, nonatomic) IBOutlet CSLinearLayoutView *linearLayoutView;

@end
