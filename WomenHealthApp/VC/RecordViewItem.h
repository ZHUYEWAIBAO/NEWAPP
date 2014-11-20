//
//  RecordViewItem.h
//  WomenHealthApp
//
//  Created by Daniel on 14/11/19.
//  Copyright (c) 2014年 WomenHealthApp. All rights reserved.
//

#import <UIKit/UIKit.h>
 /// ss


@interface RecordViewItem : UIView

@property (weak, nonatomic) IBOutlet UILabel *titleNameLab;

@property (weak, nonatomic) IBOutlet UILabel *tishiLab;

@property (weak, nonatomic) IBOutlet UIPickerView *pickerView;



@property (weak, nonatomic) IBOutlet UIScrollView *alterScrollview;

@end



