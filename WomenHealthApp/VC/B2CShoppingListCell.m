//
//  B2CShoppingListCell.m
//  CMCCMall
//
//  Created by 朱 青 on 14-7-22.
//  Copyright (c) 2014年 cmcc. All rights reserved.
//

#import "B2CShoppingListCell.h"
#import "GoodsListModel.h"

@implementation B2CShoppingListCell

- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setItemWithArray:(NSMutableArray *)goodsArray row:(NSInteger)row target:(id)target detailAction:(SEL)detailAction
{
    
    [self.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    
    for (int i = 0; i < MAXITEMCOUNT; i++){
        
        if ((row * MAXITEMCOUNT + i) < goodsArray.count){
            
            GoodsListModel *model = [goodsArray objectAtIndex:row * MAXITEMCOUNT + i];
            
            B2CShopItemView *view = (B2CShopItemView *)[[[NSBundle mainBundle] loadNibNamed:@"B2CShopItemView" owner:self options:nil] lastObject];
            
            float btnX = EDGELENGTH + (EDGELENGTH + view.frame.size.width) * (i % MAXITEMCOUNT);
            float btnY = EDGELENGTH;
            
            [view setFrame:CGRectMake(btnX,btnY ,view.frame.size.width, view.frame.size.height)];
            
            //商品图
            [view.goodsImageView setImageWithURL:[NSURL URLWithString:model.goods_img]];
            
            if (model.recommend_tag_pic.length > 0) {
                [view.recommendImageV setImageWithURL:[NSURL URLWithString:model.goods_img]];
            }
            
            if ([@"1" isEqualToString:model.is_best]) {
                [view.jingImageV setHidden:NO];
            }
            else{
                [view.jingImageV setHidden:YES];
            }
            
            //添加按钮事件
            [view setBtnModel:model];
            [view.goodsBtn addTarget:target action:detailAction forControlEvents:UIControlEventTouchUpInside];

            //商品名
            [view.goodsNameLabel setText:model.goods_name];
            
            //现价
            if (model.promote_price.length > 0) {
                
                view.nowPriceLabel.text = [self priceStringWithOneFloat:model.promote_price];
            }
            else{
                if(model.shop_price.length > 0){
                    
                    view.nowPriceLabel.text = [self priceStringWithOneFloat:model.shop_price];
                    
                }
            }
            view.nowPriceLabel.textColor = RGBACOLOR(254, 111, 117, 1.0);
            
            //原价
            view.marketPriceLabel.text= [self priceStringWithOneFloat:model.market_price];
            view.marketPriceLabel.strikeThroughEnabled=YES;
            view.marketPriceLabel.textColor=[UIColor darkGrayColor];
            
            
            [self.contentView addSubview:view];
        }
        
        
    }
    
}

- (NSString *)priceStringWithOneFloat:(NSString *)priceStr
{
    if (priceStr.length == 0) {
        return @"";
    }
    CGFloat price = [priceStr floatValue];

    return [NSString stringWithFormat:@"¥%.1f",price];

}

@end
