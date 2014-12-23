//
//  CommentGoodsCell.m
//  WomenHealthApp
//
//  Created by 朱青 on 14/12/21.
//  Copyright (c) 2014年 WomenHealthApp. All rights reserved.
//

#import "CommentGoodsCell.h"

@implementation CommentGoodsCell

- (void)awakeFromNib {
    //设置UIImageView显示为圆形
    self.userImageView.layer.cornerRadius = self.userImageView.frame.size.width / 2;
    self.userImageView.layer.masksToBounds = YES;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
