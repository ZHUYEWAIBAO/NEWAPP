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
    NSDate* todayDate ;//今天的日子
    
    
    NSDateFormatter *formater ;
    
    
    NSMutableArray *daysAry;//把42 个按钮都加在数组里
}


-(void)awakeFromNib{

    daysAry =[NSMutableArray array];
    todayDate = [NSDate date];
    formater =[[NSDateFormatter alloc]init];
    [formater setDateFormat:@"yyyy年MM月"];
    NSString *TodayStr =[formater stringFromDate:todayDate];
    NSLog(@"今天是星期几--------%lu",(unsigned long)[self getWeekdayFromDate:todayDate]);
    NSLog(@"这个月总共有-------%lu",(unsigned long)[self getNumberForDate:todayDate]);
    NSInteger totayDays =(unsigned long)[self getNumberForDate:todayDate];
    NSLog(@"今天是这个月的第-----%lu",(unsigned long)[self getDayFromDate:todayDate]);
    NSLog(@"这个月的第1天是星期-----%lu",(unsigned long)[self getTheFirstDayThisMounth:todayDate]);
    
    NSInteger firstDayXingQi =(unsigned long)[self getTheFirstDayThisMounth:todayDate];
    if (firstDayXingQi ==0) {
        firstDayXingQi =7;
    }

    self.titleLab.text =TodayStr;
    for (int i=0; i<6; i++) {
        for (int j=0; j<7; j++) {
            
            calendarItemBtn *temp =[[calendarItemBtn alloc] initWithFrame:CGRectMake(46*j-1,46*i+65, 46 , 46)];
            if((7*i+j) >=(firstDayXingQi-1)  &&  (7*i+j)<totayDays+(firstDayXingQi-1)){
                
                [temp setTitle:[NSString stringWithFormat:@"%lu",(unsigned long)(7*i+j)+1-(firstDayXingQi-1)] forState:UIControlStateNormal];

                
            }else{
                 [temp setTitle:@"" forState:UIControlStateNormal];
            }
            
            //244 227 229
            [temp addTarget:self action:@selector(didSelect:) forControlEvents:UIControlEventTouchUpInside];
            temp.tag =7*i+j;
            temp.titleLabel.font =[UIFont systemFontOfSize:14];
            [temp setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            temp.backgroundColor =[UIColor whiteColor];
            [[temp layer] setBorderWidth:0.5f];
            [[temp layer] setCornerRadius:1];
            [[temp layer] setBorderColor:[UIColor NewcolorWithRed:246 green:224 blue:225 alpha:1].CGColor];
            
            
            if ((7*i+j)+1-(firstDayXingQi-1) ==(unsigned long)[self getDayFromDate:todayDate]) {
                
                didSelectBtn =temp;
                [temp setBackgroundImage:[UIImage imageWithContentFileName:@"today_active@2x.png"] forState:UIControlStateNormal];
            }
            
            if ((7*i+j)%30+1 ==18) {
                UIImageView *tempImg =[[UIImageView alloc] initWithFrame:CGRectMake(5, 25, 14, 14)];
                tempImg.image =[UIImage imageNamed:@"pailuanri_logo.png"];
                [temp addSubview:tempImg];
            }
            
            [self addSubview:temp];
            
            [daysAry addObject:temp];
            
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

    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *comps = nil;
    comps = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:todayDate];
    NSDateComponents *adcomps = [[NSDateComponents alloc] init];
    [adcomps setYear:0];
    [adcomps setMonth:-1];
    [adcomps setDay:0];
    todayDate = [calendar dateByAddingComponents:adcomps toDate:todayDate options:0];
    [formater setDateFormat:@"yyyy年MM月"];
    NSString *TodayStr =[formater stringFromDate:todayDate];
    
    self.titleLab.text =TodayStr;


    [self calanderReloadData];

    
}

- (IBAction)rightBtnClick:(id)sender {
    
    
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *comps = nil;
    comps = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:todayDate];
    NSDateComponents *adcomps = [[NSDateComponents alloc] init];
    [adcomps setYear:0];
    [adcomps setMonth:+1];
    [adcomps setDay:0];
    todayDate = [calendar dateByAddingComponents:adcomps toDate:todayDate options:0];
    [formater setDateFormat:@"yyyy年MM月"];
    NSString *TodayStr =[formater stringFromDate:todayDate];
    self.titleLab.text =TodayStr;

    [self calanderReloadData];
}
/**
 *  刷新日历界面
 */
-(void)calanderReloadData{
    
    NSLog(@"今天是星期几--------%lu",(unsigned long)[self getWeekdayFromDate:todayDate]);
    NSLog(@"这个月总共有-------%lu",(unsigned long)[self getNumberForDate:todayDate]);
    NSInteger totayDays =(unsigned long)[self getNumberForDate:todayDate];
    
    NSLog(@"今天是这个月的第-----%lu",(unsigned long)[self getDayFromDate:todayDate]);
    
    NSLog(@"这个月的第1天是星期-----%lu",(unsigned long)[self getTheFirstDayThisMounth:todayDate]);
    
    NSInteger firstDayXingQi =(unsigned long)[self getTheFirstDayThisMounth:todayDate];
    if (firstDayXingQi ==0) {
        firstDayXingQi =7;
    }
    for (int i=0; i<6; i++) {
        for (int j=0; j<7; j++) {
            
            calendarItemBtn *temp =[daysAry objectAtIndex:7*i+j];
            //            calendarItemBtn *temp =[[calendarItemBtn alloc] initWithFrame:CGRectMake(46*j-1,46*i+65, 46 , 46)];
            if((7*i+j) >=(firstDayXingQi-1)  &&  (7*i+j)<totayDays+(firstDayXingQi-1)){
                
                [temp setTitle:[NSString stringWithFormat:@"%lu",(unsigned long)(7*i+j)+1-(firstDayXingQi-1)] forState:UIControlStateNormal];
                
            }else{
                [temp setTitle:@"" forState:UIControlStateNormal];
            }
            
            //244 227 229
            [temp addTarget:self action:@selector(didSelect:) forControlEvents:UIControlEventTouchUpInside];
            temp.tag =7*i+j;
            temp.titleLabel.font =[UIFont systemFontOfSize:14];
            [temp setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            temp.backgroundColor =[UIColor whiteColor];
            [[temp layer] setBorderWidth:0.5f];
            [[temp layer] setCornerRadius:1];
            [[temp layer] setBorderColor:[UIColor NewcolorWithRed:246 green:224 blue:225 alpha:1].CGColor];
            
            
            if ((7*i+j)+1-(firstDayXingQi-1) ==(unsigned long)[self getDayFromDate:todayDate]) {
                
                didSelectBtn =temp;
                [temp setBackgroundImage:[UIImage imageWithContentFileName:@"today_active@2x.png"] forState:UIControlStateNormal];
            }else{
                
                [temp setBackgroundImage:[UIImage imageWithContentFileName:@""] forState:UIControlStateNormal];
            }
            
            if ((7*i+j)%30+1 ==18) {
                UIImageView *tempImg =[[UIImageView alloc] initWithFrame:CGRectMake(5, 25, 14, 14)];
                tempImg.image =[UIImage imageNamed:@"pailuanri_logo.png"];
                [temp addSubview:tempImg];
            }else{
                
            }
            
        }
    }

}
/**
 *  判断 date是星期几
 *
 */
- (NSUInteger)getWeekdayFromDate:(NSDate*)date

{
    
    NSCalendar* calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents* components = [[NSDateComponents alloc] init];
    NSInteger unitFlags = NSYearCalendarUnit |
    NSMonthCalendarUnit |
    NSDayCalendarUnit |
    NSWeekdayCalendarUnit |
    NSHourCalendarUnit |
    NSMinuteCalendarUnit |
    NSSecondCalendarUnit;
    components = [calendar components:unitFlags fromDate:date];
    NSUInteger weekday = [components weekday];
    weekday =weekday-1;
    return weekday;
    
}
/**
 *  判断今天是这个月的第几天
 *
 */
- (NSUInteger)getDayFromDate:(NSDate*)date

{
    
    NSCalendar* calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents* components = [[NSDateComponents alloc] init];
    NSInteger unitFlags = NSYearCalendarUnit |
    NSMonthCalendarUnit |
    NSDayCalendarUnit |
    NSWeekdayCalendarUnit |
    NSHourCalendarUnit |
    NSMinuteCalendarUnit |
    NSSecondCalendarUnit;
    components = [calendar components:unitFlags fromDate:date];
    NSUInteger weekday = [components day];
    return weekday;
    
}

/**
 *  判断今天所在这个月有几天
 */
-(NSInteger )getNumberForDate:(NSDate *)todayDate{
    

    
    NSCalendar *c = [NSCalendar currentCalendar];
    NSRange days = [c rangeOfUnit:NSDayCalendarUnit
                           inUnit:NSMonthCalendarUnit
                          forDate:todayDate];
    NSLog(@"%lu",(unsigned long)days.length);
    
    return days.length;
}

/**
 *  得到今天所在这个月的第一天是星期几
 *
 *  @param todayDate 今天日期
 *
 *  @return <#return value description#>
 */
-(NSInteger )getTheFirstDayThisMounth:(NSDate *)todayNewDate{
    
    
    NSLog(@"几天是这个月的第-----%lu",(unsigned long)[self getDayFromDate:todayNewDate]);
    
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *comps = nil;
    comps = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:todayDate];
    NSDateComponents *adcomps = [[NSDateComponents alloc] init];
    [adcomps setYear:0];
    [adcomps setMonth:0];
    [adcomps setDay:1-[self getDayFromDate:todayNewDate]];
    NSDate *resultDate;
    resultDate = [calendar dateByAddingComponents:adcomps toDate:todayDate options:0];

    NSLog(@"今天是星期几--------%lu",(unsigned long)[self getWeekdayFromDate:resultDate]);
    
    return (unsigned long)[self getWeekdayFromDate:resultDate];
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