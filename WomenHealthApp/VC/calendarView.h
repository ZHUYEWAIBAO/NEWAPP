//
//  calendar.h
//  RILIDemo
//
//  Created by Daniel on 14-11-13.
//  Copyright (c) 2014年 Daniel. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CalendarProtocal <NSObject>

-(void)gotoRecordDetailwith:(NSDate *)currenDateNew;

-(void)setCurrentdate:(NSDate *)curentDate;

-(void)setTitleLab:(NSString *)title1 withnumber:(int )numberDay;

@end

/**
 *  日历
 */
@interface calendarView : UIView

- (IBAction)leftBtnClick:(id)sender;

- (IBAction)rightBtnClick:(id)sender;

@property(nonatomic,weak) id<CalendarProtocal> CPdelegede;

@property (weak, nonatomic) IBOutlet UILabel *titleLab;


@end





@interface calendarItemBtn : UIButton

@property(nonatomic,strong) UIView *lineView;

@property(nonatomic,strong) UIImageView *tempImg;

@end