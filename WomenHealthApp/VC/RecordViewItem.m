//
//  RecordViewItem.m
//  WomenHealthApp
//
//  Created by Daniel on 14/11/19.
//  Copyright (c) 2014年 WomenHealthApp. All rights reserved.
//

#import "RecordViewItem.h"

@implementation RecordViewItem

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
@synthesize ZZAry;
-(void)awakeFromNib{
    
    [super awakeFromNib];
    
    self.ZZAry= [[NSUserDefaults standardUserDefaults] objectForKey:@"zhengZhuangAry"];
    if (self.ZZAry ==nil) {
        self.ZZAry =[NSMutableArray array];
        
    }else{
        [self.subviews enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
           
            
        }];

    }
}



- (IBAction)cancel:(id)sender {
    NSLog(@"1");
    for (int i=1000; i<=1014; i++) {
        UIButton *btn =(UIButton *)[self viewWithTag:i];
        btn.selected =NO;
        [btn setTitle:btn.titleLabel.text forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [btn setBackgroundImage:[UIImage imageWithContentFileName:@"type_normal_btn"] forState:UIControlStateNormal];
    }
    
    
    
    if ([self.delegete respondsToSelector:@selector(didSelDismss)]) {
        [self.delegete didSelDismss];
        
    }
    
    [ZZAry removeAllObjects];

    
}

- (IBAction)confirm:(id)sender {
    NSLog(@"2");
    
    if ([self.delegete respondsToSelector:@selector(comfirmSelect)]) {
        [self.delegete comfirmSelect];
        
    }
    
    [[NSUserDefaults standardUserDefaults] setObject:ZZAry forKey:@"zhengZhuangAry"];
    
    
}

- (IBAction)click:(id)sender {
    NSLog(@"s");
    
    
    
    UIButton *btn =(UIButton *)sender;
    if (btn.selected ==YES) {
        btn.selected =NO;
        [ZZAry removeObject:[NSNumber numberWithInt:btn.tag]];
        [btn setTitle:btn.titleLabel.text forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [btn setBackgroundImage:[UIImage imageWithContentFileName:@"type_normal_btn"] forState:UIControlStateNormal];

    }else{
        btn.selected =YES;
        [ZZAry addObject:[NSNumber numberWithInt:btn.tag]];
        [btn setTitle:btn.titleLabel.text forState:UIControlStateSelected];
        [btn setTitleColor:FENSERGB forState:UIControlStateSelected];
        [btn setBackgroundImage:[UIImage imageWithContentFileName:@"type_active_btn"] forState:UIControlStateNormal];

    }
    
    

    
}
@end
