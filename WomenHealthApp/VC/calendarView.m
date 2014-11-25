//
//  calendar.m
//  RILIDemo
//
//  Created by Daniel on 14-11-13.
//  Copyright (c) 2014年 Daniel. All rights reserved.
//
#import "calendarView.h"
#import "UIColor+RGBCo.h"
#define YUEJINGQICOLOR [UIColor NewcolorWithRed:247 green:95 blue:106 alpha:1]
#define YUCEJINGQICOLOR  [UIColor NewcolorWithRed:252  green:209 blue:155 alpha:1]
#define ANQUANQICOLOR   [UIColor colorWithRed:142/255.0f green:229/255.0f blue:146/255.0f alpha:1]
#define YIYUNQICOLOR  [UIColor colorWithRed:226/255.0f green:165/255.0f blue:84/255.0f alpha:1]


@implementation calendarView{
    calendarItemBtn *didSelectBtn;
    NSDate* todayDate ;//今天的日子
    
    
    NSDateFormatter *formater ;
    
    
    NSMutableArray *daysAry;//把42 个按钮都加在数组里
    
    int yueJingDay ;//这次开始时间
    int durationDay ;//月经持续时间
    int zhouqiDay ;//周期时间
    
    int yueJingEndDay ;  //5 这次月经结束时间
    
    int nextYuceStartDay ;//27  下次月经开始时间
    int nextYuceEndDay ; //29 下次月经结束时间
    
    int weiXianStarDay ; //8  危险期开始时间
    int weixianEndDay ;//17   危险期结束时间
    
    int paiRuanDay;   //拍卵日  13
}


-(void)awakeFromNib{

    /**
     *  假设     2014-11-3-3天-24天
     */
     yueJingDay =3; //这次开始时间
     durationDay =3;//月经持续时间
     zhouqiDay =24;//周期时间
    
     yueJingEndDay =yueJingDay +durationDay -1;  //5 这次月经结束时间
    
     nextYuceStartDay =yueJingDay +zhouqiDay;//27  下次月经开始时间
     nextYuceEndDay =nextYuceStartDay +durationDay-1; //29 下次月经结束时间
    
     weiXianStarDay =nextYuceStartDay-14-5; //8  危险期开始时间
     weixianEndDay =weiXianStarDay +9;//17   危险期结束时间
    
    paiRuanDay =nextYuceStartDay -14;
    //其余都是安全期
    
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
    
    
    
    int firstDayXingQi =(int)[self getTheFirstDayThisMounth:todayDate];
    if (firstDayXingQi ==0) {
        firstDayXingQi =7;
    }

    self.titleLab.text =TodayStr;
    for (int i=0; i<6; i++) {
        for (int j=0; j<7; j++) {
            int impotrNum =(7*i+j)+1-(firstDayXingQi-1);
            calendarItemBtn *temp =[[calendarItemBtn alloc] initWithFrame:CGRectMake(46*j-1,46*i+65, 46 , 46)];
            if((7*i+j) >=(firstDayXingQi-1)  &&  (7*i+j)<totayDays+(firstDayXingQi-1)){
                
                [temp setTitle:[NSString stringWithFormat:@"%i",(7*i+j)+1-(firstDayXingQi-1)] forState:UIControlStateNormal];
                
                if (impotrNum >=yueJingDay &&impotrNum <=yueJingEndDay) {
                    temp.lineView.backgroundColor =YUEJINGQICOLOR;
                }
               else if (impotrNum >=weiXianStarDay &&impotrNum <=weixianEndDay) {
                    temp.lineView.backgroundColor =YIYUNQICOLOR;
                }
                else if (impotrNum >=nextYuceStartDay &&impotrNum <=nextYuceEndDay) {
                    temp.lineView.backgroundColor =YUCEJINGQICOLOR;
                }else{
                    temp.lineView.backgroundColor =ANQUANQICOLOR;
                }
                
                
            }else{
                 [temp setTitle:@"" forState:UIControlStateNormal];
                temp.lineView.backgroundColor =[UIColor clearColor];
            }
            
            //244 227 229
            [temp addTarget:self action:@selector(didSelect:) forControlEvents:UIControlEventTouchUpInside];
            temp.tag =7*i+j;
            temp.titleLabel.font =[UIFont systemFontOfSize:14];
            [temp setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            temp.backgroundColor =[UIColor whiteColor];
//            [[temp layer] setBorderWidth:0.4f];
//            [[temp layer] setCornerRadius:1];
//            [[temp layer] setBorderColor:[UIColor NewcolorWithRed:246 green:224 blue:225 alpha:1].CGColor];
            
            /**
             *  今天几号
             */
            if ((7*i+j)+1-(firstDayXingQi-1) ==(unsigned long)[self getDayFromDate:todayDate]) {
                
                didSelectBtn =temp;
                [temp setBackgroundImage:[UIImage imageWithContentFileName:@"today_active@2x.png"] forState:UIControlStateNormal];
            }
            
            /**
             *  排卵日
             */
            if (impotrNum==paiRuanDay) {
//                UIImageView *tempImg =[[UIImageView alloc] initWithFrame:CGRectMake(5, 25, 14, 14)];
                temp.tempImg.image =[UIImage imageNamed:@"pailuanri_logo.png"];
//                [temp addSubview:tempImg];
            }else{
                temp.tempImg.image =[UIImage imageNamed:@""];
            }
            
            [self addSubview:temp];
            
            [daysAry addObject:temp];
        
            
        }
    }

    /**
     月经期
     
     */
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 65+46*2-3, 3*46, 4)];
    lineView.backgroundColor =YUEJINGQICOLOR;
//    [self addSubview:lineView];
    
    /**
     预测经期
     
     */
    UIView *lineView1 = [[UIView alloc] initWithFrame:CGRectMake(46*3, 65+46*5-3, 46*3, 4)];
    lineView1.backgroundColor =YUCEJINGQICOLOR;
//    [self addSubview:lineView1];
//
//
    //安全期
    UIView *lineView2 = [[UIView alloc] initWithFrame:CGRectMake(46*3-1, 65+46-4+46*3, 320-46*3+3, 4)];
    lineView2.backgroundColor =ANQUANQICOLOR;
//    [self addSubview:lineView2];
    
    //  226  165  84  危险期
    
    UIView *lineView3 = [[UIView alloc] initWithFrame:CGRectMake(0, 65-3+46*3, 320, 4)];
    lineView3.backgroundColor =YIYUNQICOLOR;
//    [self addSubview:lineView3];
    
    
}

-(void)didSelect:(id)sender{
    
    
    calendarItemBtn *btn =(calendarItemBtn *)sender;
    [didSelectBtn setBackgroundImage:[UIImage imageWithContentFileName:@""] forState:UIControlStateNormal];
    
    [btn setBackgroundImage:[UIImage imageWithContentFileName:@"today_active@2x.png"] forState:UIControlStateNormal];
    
    didSelectBtn =btn;
    NSLog(@"%i",(int)btn.tag);
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
    
    int firstDayXingQi =(int)[self getTheFirstDayThisMounth:todayDate];
    if (firstDayXingQi ==0) {
        firstDayXingQi =7;
    }
    for (int i=0; i<6; i++) {
        for (int j=0; j<7; j++) {
            
            calendarItemBtn *temp =[daysAry objectAtIndex:7*i+j];
            //            calendarItemBtn *temp =[[calendarItemBtn alloc] initWithFrame:CGRectMake(46*j-1,46*i+65, 46 , 46)];
            int impotrNum =(7*i+j)+1-(firstDayXingQi-1);
            if((7*i+j) >=(firstDayXingQi-1)  &&  (7*i+j)<totayDays+(firstDayXingQi-1)){
                
                
                [temp setTitle:[NSString stringWithFormat:@"%i",(7*i+j)+1-(firstDayXingQi-1)] forState:UIControlStateNormal];
                if (impotrNum >=yueJingDay &&impotrNum <=yueJingEndDay) {
                    temp.lineView.backgroundColor =YUEJINGQICOLOR;
                }
                else if (impotrNum >=weiXianStarDay &&impotrNum <=weixianEndDay) {
                    temp.lineView.backgroundColor =YIYUNQICOLOR;
                }
                else if (impotrNum >=nextYuceStartDay &&impotrNum <=nextYuceEndDay) {
                    temp.lineView.backgroundColor =YUCEJINGQICOLOR;
                }else{
                    temp.lineView.backgroundColor =ANQUANQICOLOR;
                }
                
                
            }else{
                [temp setTitle:@"" forState:UIControlStateNormal];
                temp.lineView.backgroundColor =[UIColor clearColor];
            }
            
            //244 227 229
            [temp addTarget:self action:@selector(didSelect:) forControlEvents:UIControlEventTouchUpInside];
            temp.tag =7*i+j;
            temp.titleLabel.font =[UIFont systemFontOfSize:14];
            [temp setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            temp.backgroundColor =[UIColor whiteColor];
//            [[temp layer] setBorderWidth:0.5f];
//            [[temp layer] setCornerRadius:1];
//            [[temp layer] setBorderColor:[UIColor NewcolorWithRed:246 green:224 blue:225 alpha:1].CGColor];
            
            
            if ((7*i+j)+1-(firstDayXingQi-1) ==(unsigned long)[self getDayFromDate:todayDate]) {
                
                didSelectBtn =temp;
                [temp setBackgroundImage:[UIImage imageWithContentFileName:@"today_active@2x.png"] forState:UIControlStateNormal];
            }else{
                
                [temp setBackgroundImage:[UIImage imageWithContentFileName:@""] forState:UIControlStateNormal];
            }
            
            if (impotrNum==paiRuanDay) {
                //                UIImageView *tempImg =[[UIImageView alloc] initWithFrame:CGRectMake(5, 25, 14, 14)];
                temp.tempImg.image =[UIImage imageNamed:@"pailuanri_logo.png"];
                //                [temp addSubview:tempImg];
            }else{
                temp.tempImg.image =[UIImage imageNamed:@""];
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
-(NSInteger )getNumberForDate:(NSDate *)todayDateNew{
    

    
    NSCalendar *c = [NSCalendar currentCalendar];
    NSRange days = [c rangeOfUnit:NSDayCalendarUnit
                           inUnit:NSMonthCalendarUnit
                          forDate:todayDateNew];
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

        UIImageView *backImgeview =[[UIImageView alloc] initWithFrame:CGRectMake(0.1, 0.1, self.frame.size.width-0.2, self.frame.size.height -0.2)];
            [[backImgeview layer] setBorderWidth:0.5f];
            [[backImgeview layer] setCornerRadius:1];
            [[backImgeview layer] setBorderColor:[UIColor NewcolorWithRed:246 green:224 blue:225 alpha:1].CGColor];
        [self addSubview:backImgeview];
        
        _tempImg =[[UIImageView alloc] initWithFrame:CGRectMake(5, 25, 14, 14)];
        
        [self addSubview:_tempImg];
        
        _lineView = [[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height-3, self.frame.size.width, 4)];
        [self addSubview:_lineView];
 

    }
    return self;

}




@end