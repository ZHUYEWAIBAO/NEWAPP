//
//  PostSearchListCell.h
//  WomenHealthApp
//
//  Created by 朱青 on 15/1/12.
//  Copyright (c) 2015年 WomenHealthApp. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PostSearchListCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *authorLabel;
@property (weak, nonatomic) IBOutlet UILabel *postLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *messageLabel;

@end
