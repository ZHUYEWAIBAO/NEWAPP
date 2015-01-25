//
//  SurveyTableViewCell.h
//  WomenHealthApp
//
//  Created by Daniel on 15/1/16.
//  Copyright (c) 2015年 WomenHealthApp. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SurveyTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIButton *selectBtn;

@property (weak, nonatomic) IBOutlet UIImageView *selectImg;


@property (weak, nonatomic) IBOutlet UILabel *nameLab;

@end
