//
//  OrderCellDetailView.m
//  CMCCMall
//
//  Created by 朱 青 on 14-9-18.
//  Copyright (c) 2014年 cmcc. All rights reserved.
//

#import "OrderCellDetailView.h"

@implementation OrderCellDetailView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    //顶部加一条线
    UIImageView *topLineImgV = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, 0.5)];
    [topLineImgV setBackgroundColor:[UIColor colorWithRed:199.0/255.0 green:199.0/255.0 blue:204.0/255.0 alpha:1.0]];
    [self addSubview:topLineImgV];
    
    //底部加一条线
    UIImageView *bottomLineImgV = [[UIImageView alloc]initWithFrame:CGRectMake(0, self.frame.size.height - 0.5, self.frame.size.width, 0.5)];
    [bottomLineImgV setBackgroundColor:[UIColor colorWithRed:199.0/255.0 green:199.0/255.0 blue:204.0/255.0 alpha:1.0]];
    [self addSubview:bottomLineImgV];

}

@end
