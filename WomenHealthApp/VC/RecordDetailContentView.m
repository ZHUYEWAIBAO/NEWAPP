//
//  RecordDetailContentView.m
//  WomenHealthApp
//
//  Created by 朱 青 on 14-11-17.
//  Copyright (c) 2014年 WomenHealthApp. All rights reserved.
//

#import "RecordDetailContentView.h"

@implementation RecordDetailContentView


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    NSDateFormatter  *formater =[[NSDateFormatter alloc]init];
    [formater setDateFormat:@"yyyyMMdd"];
    NSString  *TodayStr =[formater stringFromDate:self.RDDate];
    
    NSDictionary *dataDic  = [[[NSUserDefaults standardUserDefaults] objectForKey:@"resultDic"] objectForKey:TodayStr];
    

    self.liuliang =[dataDic objectForKey:@"liuliang"];
    
    self.tongjing =[dataDic objectForKey:@"tongjing"];
    if ([[CMSinger share].yueJingDayAry containsObject:[CMSinger share].singerDate]||[[CMSinger share].currenYuejingDayAry containsObject:[CMSinger share].singerDate]) {
        
        
    }else{
        self.liuliang =@"";
        
        self.tongjing =@"";
    }
    
    
    [self.subviews enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if ([obj class] ==[UIButton class]) {
            if ([((UIButton *)obj).titleLabel.text isEqualToString:self.liuliang]||[((UIButton *)obj).titleLabel.text isEqualToString:self.tongjing]) {
                
                
                [((UIButton *)obj) setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                [((UIButton *)obj) setBackgroundImage:[UIImage imageWithContentFileName:@"Record_detail_detail_text_selected.png"] forState:UIControlStateNormal];
                
            }else{
                [((UIButton *)obj) setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
                [((UIButton *)obj) setBackgroundImage:[UIImage imageWithContentFileName:@"Record_detail_detail_text.png"] forState:UIControlStateNormal];
                
            }
        }
        
        
    }];

}

-(void)awakeFromNib{
    
    [super awakeFromNib];
//    
//    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"tongjing"] length]==0) {
//        [[NSUserDefaults standardUserDefaults] setObject:@"轻度" forKey:@"tongjing"];
//    }
//    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"liuliang"] length]==0) {
//        [[NSUserDefaults standardUserDefaults] setObject:@"很少" forKey:@"liuliang"];
//    }
    
    
    
    
    
    
}
- (IBAction)tocalClcik:(id)sender {
    
    if ([[CMSinger share].yueJingDayAry containsObject:[CMSinger share].singerDate]||[[CMSinger share].currenYuejingDayAry containsObject:[CMSinger share].singerDate]) {
        
        
    }else{
        [OMGToast showWithText:@"您当前不处于月经期，无法设置"];
        
        return;
    }
    
   UIButton *btn =  (UIButton *)sender;
    [self.typeBtn0 setBackgroundImage:[UIImage imageWithContentFileName:@"Record_detail_detail_text.png"] forState:UIControlStateNormal];
    [self.typeBtn1 setBackgroundImage:[UIImage imageWithContentFileName:@"Record_detail_detail_text.png"] forState:UIControlStateNormal];
    [self.typeBtn2 setBackgroundImage:[UIImage imageWithContentFileName:@"Record_detail_detail_text.png"] forState:UIControlStateNormal];
    [self.typeBtn0 setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [self.typeBtn1 setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [self.typeBtn2 setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    
    
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn setBackgroundImage:[UIImage imageWithContentFileName:@"Record_detail_detail_text_selected.png"] forState:UIControlStateNormal];
//    [[NSUserDefaults standardUserDefaults] setObject:btn.titleLabel.text forKey:@"tongjing"];
    self.tongjing =btn.titleLabel.text;
    
    if ([self.RDDelegete respondsToSelector:@selector(setLiuLiang:AndTongjing:)]) {
        [self.RDDelegete setLiuLiang:self.liuliang AndTongjing:self.tongjing];
    }
    
    
}
-(NSDate *)getTheDate:(NSDate *)theDate afterDays:(int)days{
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *comps = nil;
    comps = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:theDate];
    NSDateComponents *adcomps = [[NSDateComponents alloc] init];
    [adcomps setYear:0];
    [adcomps setMonth:0];
    [adcomps setDay:days];
    NSDate *resultDate;
    resultDate = [calendar dateByAddingComponents:adcomps toDate:theDate options:0];
    //    NSLog(@"resultDate--------%@",resultDate);
    
    return resultDate;
}
- (IBAction)tocalClcikTwo:(id)sender{
    
    
    if ([[CMSinger share].yueJingDayAry containsObject:[CMSinger share].singerDate]||[[CMSinger share].currenYuejingDayAry containsObject:[CMSinger share].singerDate]) {
        
        
    }else{
        [OMGToast showWithText:@"您当前不处于月经期，无法设置"];
        
        return;
    }
    
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
    
    self.liuliang =btn.titleLabel.text;
//    [[NSUserDefaults standardUserDefaults] setObject:btn.titleLabel.text forKey:@"liuliang"];
    if ([self.RDDelegete respondsToSelector:@selector(setLiuLiang:AndTongjing:)]) {
        [self.RDDelegete setLiuLiang:self.liuliang AndTongjing:self.tongjing];
    }
    
    
    
    
}

@end
