//
//  B2CShopItemView.m
//  CMCCMall
//
//  Created by 朱 青 on 14-7-22.
//  Copyright (c) 2014年 cmcc. All rights reserved.
//

#import "B2CShopItemView.h"

@implementation B2CGoodsButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}
@end

@implementation B2CShopItemView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {

    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];

    self.layer.shadowColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.1].CGColor;
    self.layer.shadowOffset = CGSizeMake(0, 1);
    self.layer.shadowOpacity = 1;
    self.layer.shadowRadius = 1.0;
    self.layer.masksToBounds = NO;
}

- (void)setBtnModel:(GoodsListModel *)dataModel
{
    if (nil != dataModel) {
        
        self.goodsBtn.model = dataModel;
   
    }
    
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
