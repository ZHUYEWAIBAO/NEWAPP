//
//  FirstRecordVC.h
//  WomenHealthApp
//
//  Created by 朱 青 on 14-11-13.
//  Copyright (c) 2014年 WomenHealthApp. All rights reserved.
//

#import "BasicVC.h"

@interface FirstRecordVC : BasicVC

@property (weak, nonatomic) IBOutlet UIView *recentView;    //上次例假开始时间
@property (weak, nonatomic) IBOutlet UITextField *recentTextField;


@property (weak, nonatomic) IBOutlet UIView *menstrualView; //平均例假天数
@property (weak, nonatomic) IBOutlet UITextField *menstrualTextField;

@property (weak, nonatomic) IBOutlet UIView *cycleView;     //周期天数
@property (weak, nonatomic) IBOutlet UITextField *cycleTextField;   

@property (strong, nonatomic) IBOutlet UIView *actionView;
@property (weak, nonatomic) IBOutlet UIPickerView *pickerView;

@end
