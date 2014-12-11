//
//  SelectCountCell.h
//  WomenHealthApp
//
//  Created by 朱青 on 14/12/9.
//  Copyright (c) 2014年 WomenHealthApp. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SelectCountCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (strong, nonatomic) NSMutableArray *buttonArray;

@end
