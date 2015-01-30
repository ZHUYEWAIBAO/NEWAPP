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
     *  购买最大数量
     */
    NSUInteger maxNum;
}

/**
 *  显示商品信息的View
 */

@property (weak, nonatomic) IBOutlet UILabel *selectStockLabel;   //商品库存
@property (strong, nonatomic) GoodDetailModel *detailModel;
@property (assign, nonatomic) float oneTotalPrice;

@property (weak, nonatomic) IBOutlet UILabel *selectPriceLabel;

/**
 *  数量值
 */
@property (assign, nonatomic) NSInteger totalNum;;

/**
 *  数量输入框
 */
@property (weak, nonatomic) IBOutlet UITextField *countTextField;

@end

@class B2CSelectCountView;
@protocol B2CSelectCountViewDelegate <NSObject>
@optional

- (void)B2CSelectCountView:(B2CSelectCountView *)view params:(NSMutableDictionary *)dic isAddToCar:(BOOL)addToCar;

- (void)B2CSelectCountView:(B2CSelectCountView *)view dismiss:(BOOL)dismiss;

- (void)B2CSelectCountView:(B2CSelectCountView *)view pushToShopCart:(BOOL)isPush;

@end

@interface B2CSelectCountView : UIView

@property (weak, nonatomic) id <B2CSelectCountViewDelegate> delegate;

/**
 *  显示商品信息的View
 */
@property (weak, nonatomic) IBOutlet UIView *selectTopView;
@property (weak, nonatomic) IBOutlet UIButton *selectCloseBtn;    //关闭按钮
@property (weak, nonatomic) IBOutlet UITableView *selectTableView;
@property (strong, nonatomic) CountView *countView;
@property (strong, nonatomic) NSMutableDictionary *paramDic;
@property (strong, nonatomic) NSMutableDictionary *goodsDic;
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


