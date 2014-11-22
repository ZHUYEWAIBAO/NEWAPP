//
//  RecordDetailContentView.h
//  WomenHealthApp
//
//  Created by 朱 青 on 14-11-17.
//  Copyright (c) 2014年 WomenHealthApp. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RecordDetailContentView : UIView

@property (weak, nonatomic) IBOutlet UIButton *typeBtn0;
@property (weak, nonatomic) IBOutlet UIButton *typeBtn1;
@property (weak, nonatomic) IBOutlet UIButton *typeBtn2;


@property (weak, nonatomic) IBOutlet UIButton *typeBtnNew0;
@property (weak, nonatomic) IBOutlet UIButton *typeBtnNew1;
@property (weak, nonatomic) IBOutlet UIButton *typeBtnNew2;
@property (weak, nonatomic) IBOutlet UIButton *typeBtnNew3;
@property (weak, nonatomic) IBOutlet UIButton *typeBtnNew4;



- (IBAction)tocalClcik:(id)sender;

- (IBAction)tocalClcikTwo:(id)sender;

@end
