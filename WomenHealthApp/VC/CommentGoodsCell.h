//
//  CommentGoodsCell.h
//  WomenHealthApp
//
//  Created by 朱青 on 14/12/21.
//  Copyright (c) 2014年 WomenHealthApp. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CommentGoodsCell : UITableViewCell


@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *contenLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@property (weak, nonatomic) IBOutlet UIView *secondView;

@property (weak, nonatomic) IBOutlet UIImageView *userImageView;


@property (weak, nonatomic) IBOutlet UIButton *commentButton0;
@property (weak, nonatomic) IBOutlet UIButton *commentButton1;
@property (weak, nonatomic) IBOutlet UIButton *commentButton2;
@property (weak, nonatomic) IBOutlet UIButton *commentButton3;
@property (weak, nonatomic) IBOutlet UIButton *commentButton4;

@end
