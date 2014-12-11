//
//  SelectCountCell.m
//  WomenHealthApp
//
//  Created by 朱青 on 14/12/9.
//  Copyright (c) 2014年 WomenHealthApp. All rights reserved.
//

#import "SelectCountCell.h"

@implementation SelectCountCell

- (void)awakeFromNib {
    
    _buttonArray = [[NSMutableArray alloc]initWithCapacity:0];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
