//
//  bbsTableCell.m
//  WomenHealthApp
//
//  Created by Daniel on 14/11/15.
//  Copyright (c) 2014年 WomenHealthApp. All rights reserved.
//

#import "bbsTableCell.h"

@implementation bbsTableCell

- (void)awakeFromNib {
    
    self.bbsCellImg.layer.cornerRadius = self.bbsCellImg.frame.size.width / 2;
    self.bbsCellImg.layer.masksToBounds = YES;
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
