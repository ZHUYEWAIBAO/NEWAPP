//
//  PostDetailCell.h
//  WomenHealthApp
//
//  Created by 朱青 on 15/1/14.
//  Copyright (c) 2015年 WomenHealthApp. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PostDetailCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UIImageView *louZhuImageView;
@property (weak, nonatomic) IBOutlet UILabel *authorLabel;
@property (weak, nonatomic) IBOutlet UILabel *postLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *louZhuLabel;

@property (weak, nonatomic) IBOutlet UIButton *photoButton0;
@property (weak, nonatomic) IBOutlet UIButton *photoButton1;
@property (weak, nonatomic) IBOutlet UIButton *photoButton2;

@property (weak, nonatomic) IBOutlet UIView *postView;
@property (weak, nonatomic) IBOutlet UIView *buttonView;
@property (weak, nonatomic) IBOutlet UIView *replyView;
@property (weak, nonatomic) IBOutlet UIView *replyContentView;

@property (weak, nonatomic) IBOutlet UIView *bigView;

@property (weak, nonatomic) IBOutlet UIButton *replyButton;

@property (weak, nonatomic) IBOutlet UILabel *replyNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *replyContentLabel;
@property (weak, nonatomic) IBOutlet UILabel *replyTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *replyFloorLabel;

@property (weak, nonatomic) IBOutlet UIImageView *replyBgImageView;

@end
