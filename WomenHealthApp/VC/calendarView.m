//
//  calendar.m
//  RILIDemo
//
//  Created by Daniel on 14-11-13.
//  Copyright (c) 2014年 Daniel. All rights reserved.
//

#import "calendarView.h"
#import "UIColor+RGBCo.h"
@implementation calendarView{
    calendarItemBtn *didSelectBtn;
    
}


-(void)awakeFromNib{
    NSDate* todayDate = [NSDate date];
    
    NSDateFormatter *formater =[[NSDateFormatter alloc]init];
    [formater setDateFormat:@"yyyy年M月"];
    
    NSString *TodayStr =[formater stringFromDate:todayDate];
    
    [formater setDateFormat:@"d"];
    NSString *TodayDayStr =[formater stringFromDate:todayDate];
    
    
    self.titleLab.text =TodayStr;
    
    
    for (int i=0; i<5; i++) {
        for (int j=0; j<7; j++) {
            
            calendarItemBtn *temp =[[calendarItemBtn alloc] initWithFrame:CGRectMake(46*j-1,46*i+65, 46 , 46)];
            [temp setTitle:[NSString stringWithFormat:@"%i",(7*i+j)%30+1] forState:UIControlStateNormal];
//244 227 229
            [temp addTarget:self action:@selector(didSelect:) forControlEvents:UIControlEventTouchUpInside];
            temp.tag =7*i+j;
            temp.titleLabel.font =[UIFont systemFontOfSize:14];
            [temp setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            temp.backgroundColor =[UIColor whiteColor];
            [[temp layer] setBorderWidth:0.5f];
            [[temp layer] setCornerRadius:1];
            [[temp layer] setBorderColor:[UIColor NewcolorWithRed:246 green:224 blue:225 alpha:1].CGColor];
            
            
            if ((7*i+j)%30+1 ==[TodayDayStr intValue]) {
                
                didSelectBtn =temp;
                [temp setBackgroundImage:[UIImage imageWithContentFileName:@"today_active@2x.png"] forState:UIControlStateNormal];
//                temp.backgroundColor =[UIColor colorWithRed:243/255.0f green:216/255.0f blue:171/255.0f alpha:1];
//                temp.backgroundColor =[UIColor colorWithPatternImage:[UIImage imageWithContentFileName:@"today_active.png"]];
                
            }
            
            if ((7*i+j)%30+1 ==18) {
                UIImageView *tempImg =[[UIImageView alloc] initWithFrame:CGRectMake(5, 25, 14, 14)];
                tempImg.image =[UIImage imageNamed:@"pailuanri_logo.png"];
                [temp addSubview:tempImg];
            }
            
            [self addSubview:temp];
            
        }
    }

    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 65+46-3, 5*46-1, 4)];
    lineView.backgroundColor =[UIColor NewcolorWithRed:247 green:95 blue:106 alpha:1];
    [self addSubview:lineView];
    
    
    UIView *lineView1 = [[UIView alloc] initWithFrame:CGRectMake(0, 65+46-4+45+1, 320, 4)];
    lineView1.backgroundColor =[UIColor NewcolorWithRed:252  green:209 blue:155 alpha:1];
    [self addSubview:lineView1];
    
    
    UIView *lineView2 = [[UIView alloc] initWithFrame:CGRectMake(46*3-1, 65+46-4+46*3, 320-46*3+3, 4)];
    lineView2.backgroundColor =[UIColor colorWithRed:142/255.0f green:229/255.0f blue:146/255.0f alpha:1];
    [self addSubview:lineView2];
    
}
-(void)didSelect:(id)sender{
    calendarItemBtn *btn =(calendarItemBtn *)sender;
    [didSelectBtn setBackgroundImage:[UIImage imageWithContentFileName:@""] forState:UIControlStateNormal];
    
    [btn setBackgroundImage:[UIImage imageWithContentFileName:@"today_active@2x.png"] forState:UIControlStateNormal];
    
    didSelectBtn =btn;
    NSLog(@"%li",(long)btn.tag);
}
- (IBAction)leftBtnClick:(id)sender {
    
    
    NSLog(@"11");
    
}

- (IBAction)rightBtnClick:(id)sender {
    
    NSLog(@"22");
}
@end




@implementation calendarItemBtn




-(id)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if (self) {

//        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height-2, self.frame.size.width, 5)];
//        lineView.backgroundColor =[UIColor grayColor];
//        [self addSubview:lineView];
 

    }
    return self;

}




@end