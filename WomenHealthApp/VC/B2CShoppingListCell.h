//
//  B2CShoppingListCell.h
//  CMCCMall
//
//  Created by 朱 青 on 14-7-22.
//  Copyright (c) 2014年 cmcc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "B2CShopItemView.h"
#define MAXITEMCOUNT 2 //一行几个
#define EDGELENGTH 6 //边距
@interface B2CShoppingListCell : UITableViewCell

/**
 *  设置展示商品View
 *
 *  @param model  数据类
 *  @param target 单击事件响应的对象
 *  @param action 单击事件
 */
-(void)setItemWithArray:(NSMutableArray *)goodsArray row:(NSInteger)row target:(id)target detailAction:(SEL)detailAction;

@end
