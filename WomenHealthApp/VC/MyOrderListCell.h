//
//  MyOrderListCell.h
//  WomenHealthApp
//
//  Created by 朱青 on 14/12/14.
//  Copyright (c) 2014年 WomenHealthApp. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HeadView : UIView

@property (weak, nonatomic) IBOutlet UILabel *statusLabel;

@end

@interface FootView : UIView

@property (weak, nonatomic) IBOutlet UILabel *numLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UIButton *firstButton;
@property (weak, nonatomic) IBOutlet UIButton *secondButton;

@end

@interface MyOrderListCell : UITableViewCell
{
    SEL currentAction;
    id currentTarget;
}

@property (weak, nonatomic) IBOutlet UITableView *goodsTableView;

@property (weak, nonatomic) IBOutlet UIButton *orderButton;

@property (strong, nonatomic) HeadView *headView;
@property (strong, nonatomic) FootView *footView;
@property (strong, nonatomic) NSString *currentStatus;
@property (assign, nonatomic) NSInteger currentRow;
@property (strong, nonatomic) NSMutableArray *goodsArray;

- (void)layOutTheHeadView;
- (void)layOutTheFootView;

-(void)setItemWithArray:(NSMutableArray *)goodsArray orderStatus:(NSString *)status currentRow:(NSInteger)row target:(id)target detailAction:(SEL)detailAction commentAction:(SEL)commentAction;

@end

@interface MyOrderGoodsCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *numLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UIImageView *goodsImageView;

@property (weak, nonatomic) IBOutlet UIButton *commentBtn;

@end

