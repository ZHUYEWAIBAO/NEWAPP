//
//  RecordDetailContentView.m
//  WomenHealthApp
//
//  Created by 朱 青 on 14-11-17.
//  Copyright (c) 2014年 WomenHealthApp. All rights reserved.
//

#import "RecordDetailContentView.h"

@implementation RecordDetailContentView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(void)awakeFromNib{
    
    [super awakeFromNib];
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"tongjing"] length]==0) {
        [[NSUserDefaults standardUserDefaults] setObject:@"轻度" forKey:@"tongjing"];
    }
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"liuliang"] length]==0) {
        [[NSUserDefaults standardUserDefaults] setObject:@"很少" forKey:@"liuliang"];
    }
    
    [self.subviews enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if ([obj class] ==[UIButton class]) {
            if ([((UIButton *)obj).titleLabel.text isEqualToString:[[NSUserDefaults standardUserDefaults] objectForKey:@"tongjing"]]||[((UIButton *)obj).titleLabel.text isEqualToString:[[NSUserDefaults standardUserDefaults] objectForKey:@"liuliang"]]) {
                
                
                [((UIButton *)obj) setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                [((UIButton *)obj) setBackgroundImage:[UIImage imageWithContentFileName:@"Record_detail_detail_text_selected.png"] forState:UIControlStateNormal];
                
            }else{
                [((UIButton *)obj) setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
                [((UIButton *)obj) setBackgroundImage:[UIImage imageWithContentFileName:@"Record_detail_detail_text.png"] forState:UIControlStateNormal];
                
            }
        }

        
    }];
    
    
    
    
    
}
- (IBAction)tocalClcik:(id)sender {
   UIButton *btn =  (UIButton *)sender;
    [self.typeBtn0 setBackgroundImage:[UIImage imageWithContentFileName:@"Record_detail_detail_text.png"] forState:UIControlStateNormal];
    [self.typeBtn1 setBackgroundImage:[UIImage imageWithContentFileName:@"Record_detail_detail_text.png"] forState:UIControlStateNormal];
    [self.typeBtn2 setBackgroundImage:[UIImage imageWithContentFileName:@"Record_detail_detail_text.png"] forState:UIControlStateNormal];
    [self.typeBtn0 setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [self.typeBtn1 setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [self.typeBtn2 setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    
    
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn setBackgroundImage:[UIImage imageWithContentFileName:@"Record_detail_detail_text_selected.png"] forState:UIControlStateNormal];
    [[NSUserDefaults standardUserDefaults] setObject:btn.titleLabel.text forKey:@"tongjing"];
    
}

- (IBAction)tocalClcikTwo:(id)sender{
    UIButton *btn =  (UIButton *)sender;
    [self.typeBtnNew0 setBackgroundImage:[UIImage imageWithContentFileName:@"Record_detail_detail_text.png"] forState:UIControlStateNormal];
    [self.typeBtnNew1 setBackgroundImage:[UIImage imageWithContentFileName:@"Record_detail_detail_text.png"] forState:UIControlStateNormal];
    [self.typeBtnNew2 setBackgroundImage:[UIImage imageWithContentFileName:@"Record_detail_detail_text.png"] forState:UIControlStateNormal];
    [self.typeBtnNew3 setBackgroundImage:[UIImage imageWithContentFileName:@"Record_detail_detail_text.png"] forState:UIControlStateNormal];
    [self.typeBtnNew4 setBackgroundImage:[UIImage imageWithContentFileName:@"Record_detail_detail_text.png"] forState:UIControlStateNormal];
    [self.typeBtnNew0 setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [self.typeBtnNew1 setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [self.typeBtnNew2 setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [self.typeBtnNew3 setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [self.typeBtnNew4 setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];

    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn setBackgroundImage:[UIImage imageWithContentFileName:@"Record_detail_detail_text_selected.png"] forState:UIControlStateNormal];
    [[NSUserDefaults standardUserDefaults] setObject:btn.titleLabel.text forKey:@"liuliang"];
    
    
    
}

@end
