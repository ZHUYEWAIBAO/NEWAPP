//
//  RecordDetailContentView.h
//  WomenHealthApp
//
//  Created by 朱 青 on 14-11-17.
//  Copyright (c) 2014年 WomenHealthApp. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol RecordDetailProtocal <NSObject>

-(void)setLiuLiang:(NSString *)liuliang AndTongjing :(NSString *)tongjing;

@end

@interface RecordDetailContentView : UIView

@property (weak, nonatomic) IBOutlet UIButton *typeBtn0;
@property (weak, nonatomic) IBOutlet UIButton *typeBtn1;
@property (weak, nonatomic) IBOutlet UIButton *typeBtn2;

@property(nonatomic,strong) NSDate *RDDate;

@property (weak, nonatomic) IBOutlet UIButton *typeBtnNew0;
@property (weak, nonatomic) IBOutlet UIButton *typeBtnNew1;
@property (weak, nonatomic) IBOutlet UIButton *typeBtnNew2;
@property (weak, nonatomic) IBOutlet UIButton *typeBtnNew3;
@property (weak, nonatomic) IBOutlet UIButton *typeBtnNew4;
@property(nonatomic,strong) NSString *tongjing;
@property(nonatomic,strong) NSString *liuliang;

@property(nonatomic) id<RecordDetailProtocal> RDDelegete;


- (IBAction)tocalClcik:(id)sender;

- (IBAction)tocalClcikTwo:(id)sender;

@end
