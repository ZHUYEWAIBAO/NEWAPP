//
//  MyOrderDetailVC.h
//  WomenHealthApp
//
//  Created by 朱青 on 14/12/14.
//  Copyright (c) 2014年 WomenHealthApp. All rights reserved.
//

#import "BasicVC.h"
#import "MyOrderDetailModel.h"
#import "CSLinearLayoutView.h"

@interface MyOrderDetailVC : BasicVC

@property (weak, nonatomic) IBOutlet CSLinearLayoutView *layOutView;

@property (strong, nonatomic) NSString  *orderId;
@property (strong, nonatomic) MyOrderDetailModel  *orderDetailModel;

@property (strong, nonatomic) IBOutlet UIView *addressView;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;

@property (strong, nonatomic) IBOutlet UIView *payTypeView;
@property (weak, nonatomic) IBOutlet UILabel *payTypeLabel;

@property (strong, nonatomic) IBOutlet UIView *orderView;
@property (weak, nonatomic) IBOutlet UILabel *orderIdLabel;
@property (weak, nonatomic) IBOutlet UILabel *orderTimeLabel;


@property (strong, nonatomic) IBOutlet UIView *goodsDetailView;
@property (strong, nonatomic) IBOutlet UITableView *goodsTableView;

@property (weak, nonatomic) IBOutlet UIView *goodsFootView;
@property (weak, nonatomic) IBOutlet UILabel *totalPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *shippingFeeLabel;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;

@property (strong, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet UIButton *firstButton;
@property (weak, nonatomic) IBOutlet UIButton *secondButton;

@end
