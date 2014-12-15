//
//  ShoppingOrderSuccessVC.h
//  WomenHealthApp
//
//  Created by 朱青 on 14/12/14.
//  Copyright (c) 2014年 WomenHealthApp. All rights reserved.
//

#import "BasicVC.h"
#import "OrderSuccessModel.h"

@interface ShoppingOrderSuccessVC : BasicVC

@property (strong, nonatomic) OrderSuccessModel *successModel;

@property (strong, nonatomic) NSString *payTypeId;
@property (weak, nonatomic) IBOutlet UIButton *payButton;
@property (weak, nonatomic) IBOutlet UILabel *orderLabel;

@property (weak, nonatomic) IBOutlet UIImageView *orderBgImageView;

@end
