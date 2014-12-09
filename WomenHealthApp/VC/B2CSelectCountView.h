//
//  B2CSelectCountView.h
//  CMCCMall
//
//  Created by 朱 青 on 14-7-29.
//  Copyright (c) 2014年 cmcc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GoodDetailModel.h"


@interface CountView : UIView
{
    /**
     *  数量值
     */
    NSInteger totalNum;
    /**
     *  购买最大数量
     */
    NSUInteger maxNum;
}

/**
 *  显示商品信息的View
 */

@property (weak, nonatomic) IBOutlet UILabel *selectStockLabel;   //商品库存
@property (strong, nonatomic) GoodDetailModel *detailModel;

/**
 *  数量输入框
 */
@property (weak, nonatomic) IBOutlet UITextField *countTextField;

@end

@class B2CSelectCountView;
@protocol B2CSelectCountViewDelegate <NSObject>
@optional

- (void)B2CSelectCountView:(B2CSelectCountView *)view btnClick:(NSInteger)btnTag goodsCount:(NSInteger)num;


@end

@interface B2CSelectCountView : UIView
{
    /**
     *  数量值
     */
    NSInteger totalNum;
    /**
     *  购买最大数量
     */
    NSUInteger maxNum;
}
@property (weak, nonatomic) id <B2CSelectCountViewDelegate> delegate;

/**
 *  显示商品信息的View
 */
@property (weak, nonatomic) IBOutlet UIView *selectTopView;
@property (weak, nonatomic) IBOutlet UIButton *selectCloseBtn;    //关闭按钮
@property (weak, nonatomic) IBOutlet UITableView *selectTableView;
@property (strong, nonatomic) CountView *countView;
/**
 *  展示在view上的数据类
 */
@property (strong, nonatomic) GoodDetailModel *detailModel;

- (IBAction)btnClickAction:(id)sender;

/**
 *  布局顶部View
 *
 *  @param model 展示在view上的数据类
 */
- (void)layOutTopView:(GoodDetailModel *)model;

- (void)layOutTheCountView;

@end


