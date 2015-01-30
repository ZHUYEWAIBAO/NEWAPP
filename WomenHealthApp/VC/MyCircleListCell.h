//
//  MyCircleListCell.h
//  WomenHealthApp
//
//  Created by 朱青 on 15/1/21.
//  Copyright (c) 2015年 WomenHealthApp. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyCircleListCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *postDeleteImageView;
@property (weak, nonatomic) IBOutlet UILabel *fidLabel;
@property (weak, nonatomic) IBOutlet UILabel *postLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@property (weak, nonatomic) IBOutlet UIImageView *fidImageView;

@property (weak, nonatomic) IBOutlet UIButton *replyButton;

@end
