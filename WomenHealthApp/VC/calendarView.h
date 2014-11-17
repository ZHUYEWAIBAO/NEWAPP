//
//  calendar.h
//  RILIDemo
//
//  Created by Daniel on 14-11-13.
//  Copyright (c) 2014年 Daniel. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface calendarView : UIView

- (IBAction)leftBtnClick:(id)sender;

- (IBAction)rightBtnClick:(id)sender;

@property (weak, nonatomic) IBOutlet UILabel *titleLab;


@end





@interface calendarItemBtn : UIButton




@end