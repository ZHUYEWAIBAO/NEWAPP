//
//  B2CShopItemView.h
//  CMCCMall
//
//  Created by 朱 青 on 14-7-22.
//  Copyright (c) 2014年 cmcc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StrikeThroughLabel.h"
#import "GoodsListModel.h"
/*
 自定义购物按钮button
 */
@interface B2CGoodsButton : UIButton


@property(strong,nonatomic)GoodsListModel *model;//对应的数据类

@property(strong,nonatomic)UIImageView *goodsImageView;//对应的商品图片

@end

@interface B2CShopItemView : UIView

/**
 *  商品图
 */
@property(weak,nonatomic)IBOutlet UIImageView *goodsImageView;

/**
 *  商品名
 */
@property(weak,nonatomic)IBOutlet UILabel *goodsNameLabel;

/**
 *  商品现价
 */
@property(weak,nonatomic)IBOutlet UILabel *nowPriceLabel;

/**
 *  商品市场价
 */
@property(weak,nonatomic)IBOutlet StrikeThroughLabel *marketPriceLabel;

/**
 *  商品按钮
 */
@property(weak,nonatomic)IBOutlet B2CGoodsButton *goodsBtn;

/**
 *  左上角推荐图标
 */
@property (weak, nonatomic) IBOutlet UIImageView *recommendImageV;

@property (weak, nonatomic) IBOutlet UIImageView *jingImageV;

/**
 *  设置按钮对应数据
 *
 *  @param dataModel 对应的数据类
 */
- (void)setBtnModel:(GoodsListModel *)dataModel;

@end
