//
//  PostDetailCell.m
//  WomenHealthApp
//
//  Created by 朱青 on 15/1/14.
//  Copyright (c) 2015年 WomenHealthApp. All rights reserved.
//

#import "PostDetailCell.h"

@implementation PostDetailCell

- (void)awakeFromNib {
    // Initialization code
    self.headImageView.layer.cornerRadius = self.headImageView.frame.size.width / 2;
    self.headImageView.layer.masksToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
