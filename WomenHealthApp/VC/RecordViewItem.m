//
//  RecordViewItem.m
//  WomenHealthApp
//
//  Created by Daniel on 14/11/19.
//  Copyright (c) 2014年 WomenHealthApp. All rights reserved.
//

#import "RecordViewItem.h"

@implementation RecordViewItem


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    
    
  }

@synthesize ZZAry;
-(void)awakeFromNib{
    
    [super awakeFromNib];
    
    //zzzDate
    
    NSDateFormatter  *formater =[[NSDateFormatter alloc]init];
    [formater setDateFormat:@"yyyyMMdd"];
    NSString * TodayStr =[formater stringFromDate:[CMSinger share].singerDate];
    
    
    NSDictionary* totalDic =[NSMutableDictionary dictionaryWithDictionary:[[[NSUserDefaults standardUserDefaults] objectForKey:@"resultDic"] objectForKey:TodayStr]];
    
    self.ZZAry=[NSMutableArray arrayWithArray:[totalDic objectForKey:@"shujuAry"]];
    if (self.ZZAry ==nil) {
        self.ZZAry =[NSMutableArray array];
        
    }else{
        
        [self.altetSubView.subviews enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            if ([obj class] ==[UIButton class] &&[ZZAry containsObject:[NSNumber numberWithInteger: (((UIButton *)obj).tag)]] ) {
                
                [(UIButton *)obj setTitle:((UIButton *)obj).titleLabel.text forState:UIControlStateSelected];
                [(UIButton *)obj setTitleColor:FENSERGB forState:UIControlStateNormal];
                [(UIButton *)obj setBackgroundImage:[UIImage imageWithContentFileName:@"type_active_btn"] forState:UIControlStateNormal];
            }
            
            
        }];
    }


//        NSLog(@"%@",self.altetSubView.subviews);
    
//        for (int i=0; i<ZZAry.count; i++) {
//
//            UIButton *btn =(UIButton *)[self.altetSubView viewWithTag:(int)[ZZAry objectAtIndex:i]];
//            btn.selected =NO;
//            [btn setTitle:btn.titleLabel.text forState:UIControlStateNormal];
//            [btn setTitleColor:FENSERGB forState:UIControlStateSelected];
//            [btn setBackgroundImage:[UIImage imageWithContentFileName:@"type_active_btn"] forState:UIControlStateNormal];
//        }
//        
//
//    }
}



- (IBAction)cancel:(id)sender {
    NSLog(@"1");
    for (int i=1000; i<=1014; i++) {
        UIButton *btn =(UIButton *)[self viewWithTag:i];
        [btn setTitle:btn.titleLabel.text forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [btn setBackgroundImage:[UIImage imageWithContentFileName:@"type_normal_btn"] forState:UIControlStateNormal];
    }
    [ZZAry removeAllObjects];
    
    
    if ([self.delegete respondsToSelector:@selector(didSelDismss)]) {
        [self.delegete didSelDismss];
        
    }
    


    
}

- (IBAction)confirm:(id)sender {
    NSLog(@"2");
    
    if ([self.delegete respondsToSelector:@selector(comfirmSelect:)]) {
        [self.delegete comfirmSelect:ZZAry];
        
    }
    
    
}

- (IBAction)click:(id)sender {
    NSLog(@"s");
    
    
    
    UIButton *btn =(UIButton *)sender;
    if (btn.selected ==YES) {
        btn.selected =NO;
        [ZZAry removeObject:[NSNumber numberWithInteger:btn.tag]];
        [btn setTitle:btn.titleLabel.text forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [btn setBackgroundImage:[UIImage imageWithContentFileName:@"type_normal_btn"] forState:UIControlStateNormal];

    }else{
        btn.selected =YES;
        [ZZAry addObject:[NSNumber numberWithInteger:btn.tag]];
        [btn setTitle:btn.titleLabel.text forState:UIControlStateSelected];
        [btn setTitleColor:FENSERGB forState:UIControlStateSelected];
        [btn setBackgroundImage:[UIImage imageWithContentFileName:@"type_active_btn"] forState:UIControlStateNormal];

    }
    
    

    
}
@end
