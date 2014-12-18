//
//  ShopCartTabCell.h
//  WomenHealthApp
//
//  Created by Daniel on 14/12/9.
//  Copyright (c) 2014年 WomenHealthApp. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShopCartTabCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *selectBtnClick;
@property (weak, nonatomic) IBOutlet UILabel *shopNameLab;
@property (weak, nonatomic) IBOutlet UILabel *colorTypeLab;
@property (weak, nonatomic) IBOutlet UILabel *shopCountLab;

@property (weak, nonatomic) IBOutlet UIImageView *shopImageView;
@property (weak, nonatomic) IBOutlet UILabel *xiaoJiMoneyLab;

- (IBAction)subtractionClick:(id)sender;
- (IBAction)addClick:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *shoptotalCountLab;


@end
