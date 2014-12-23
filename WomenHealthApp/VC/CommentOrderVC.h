//
//  CommentOrderVC.h
//  WomenHealthApp
//
//  Created by 朱青 on 14/12/18.
//  Copyright (c) 2014年 WomenHealthApp. All rights reserved.
//

#import "BasicVC.h"
#import "MyOrderDetailModel.h"
#import "MyOrderListModel.h"
#import "UIPlaceHolderTextView.h"

@interface CommentOrderVC : BasicVC

@property (strong, nonatomic) NSString  *payTime;

@property (strong, nonatomic) MyOrderGoodsModel  *goodsModel;

@property (strong, nonatomic) NSMutableArray  *imageDataArray;

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIPlaceHolderTextView *commentTextView;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *attrTypeLabel;
@property (weak, nonatomic) IBOutlet UILabel *numLabel;
@property (weak, nonatomic) IBOutlet UIImageView *goodsImageView;

@end
