//
//  ShopCartTabCell.m
//  WomenHealthApp
//
//  Created by Daniel on 14/12/9.
//  Copyright (c) 2014年 WomenHealthApp. All rights reserved.
//

#import "ShopCartTabCell.h"

@implementation ShopCartTabCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)subtractionClick:(id)sender {
    
    int temp =[self.shoptotalCountLab.text intValue] -1;
    
    self.shoptotalCountLab.text =[NSString stringWithFormat:@"%i",temp];
}

- (IBAction)addClick:(id)sender {
    int temp =[self.shoptotalCountLab.text intValue] +1;

    self.shoptotalCountLab.text =[NSString stringWithFormat:@"%i",temp];
}
@end
