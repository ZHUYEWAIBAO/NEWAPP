//
//  ShoppingDetailVC.h
//  WomenHealthApp
//
//  Created by 朱青 on 14/12/1.
//  Copyright (c) 2014年 WomenHealthApp. All rights reserved.
//

#import "BasicVC.h"
#import "GoodDetailModel.h"
#import "CSLinearLayoutView.h"
#import "StrikeThroughLabel.h"

@interface ShoppingDetailVC : BasicVC

@property (weak, nonatomic) IBOutlet CSLinearLayoutView *layOutView;

/**
 *  商品id,由上级页面传入
 */
@property (strong, nonatomic)NSString *goodsId;

@property (weak, nonatomic) IBOutlet UIButton *gotoBuyBtn;
@property (weak, nonatomic) IBOutlet UIButton *addToCarBtn;
@property (weak, nonatomic) IBOutlet UILabel *downAlertLabel;

@property (strong, nonatomic)GoodDetailModel *detailModel;

@property (strong, nonatomic)IBOutlet UIView *headView;
@property (weak, nonatomic)IBOutlet UIScrollView *headScrollView;
@property (weak, nonatomic)IBOutlet UIPageControl *headPageControl;

@property (strong, nonatomic)IBOutlet UIView *priceView;
@property (weak, nonatomic)IBOutlet UILabel *nameLabel;
@property (weak, nonatomic)IBOutlet UILabel *nowLabel;
@property (weak, nonatomic)IBOutlet StrikeThroughLabel *preLabel;

@property (strong, nonatomic)IBOutlet UIView *parameterView;

@property (strong, nonatomic)IBOutlet UIView *commentView;
@property (weak, nonatomic)IBOutlet UILabel *commentLabel;

@property (strong, nonatomic)IBOutlet UIView *imageTextView;

@property (weak, nonatomic)IBOutlet UIButton *blackButton;


@end
