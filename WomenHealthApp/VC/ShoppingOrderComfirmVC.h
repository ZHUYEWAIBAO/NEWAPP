//
//  ShoppingOrderComfirmVC.h
//  WomenHealthApp
//
//  Created by 朱青 on 14/12/12.
//  Copyright (c) 2014年 WomenHealthApp. All rights reserved.
//

#import "BasicVC.h"
#import "CSLinearLayoutView.h"
#import "OrderComfirmModel.h"
#import "UIPlaceHolderTextView.h"

@interface ShoppingOrderComfirmVC : BasicVC

@property (weak, nonatomic) IBOutlet CSLinearLayoutView *layOutView;

@property (strong, nonatomic) NSString  *jsonString;
@property (strong, nonatomic) NSString  *shopCarId;
@property (strong, nonatomic) OrderComfirmModel  *comfirmModel;

@property (assign, nonatomic) BOOL  isFromCar;
@property (weak, nonatomic) IBOutlet UILabel *totalTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalPriceLabel;


@property (strong, nonatomic) IBOutlet UIView *addressView;
@property (weak, nonatomic) IBOutlet UILabel *noneLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;

@property (strong, nonatomic) IBOutlet UIView *payTypeView;

@property (strong, nonatomic) IBOutlet UIView *scoreView;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UISwitch *scoreSwitch;

@property (strong, nonatomic) IBOutlet UITableView *goodsTableView;

@property (strong, nonatomic) IBOutlet UIView *speakView;
@property (weak, nonatomic) IBOutlet UIPlaceHolderTextView *speakTextView;

@property (strong, nonatomic) IBOutlet UIView *timeView;
@property (weak, nonatomic) IBOutlet UISwitch *timeSwitch;
@property (weak, nonatomic) IBOutlet UITextField *numTextField;
@property (weak, nonatomic) IBOutlet UITextField *monthsTextField;

@end
