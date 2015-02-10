//
//  calendar.m
//  RILIDemo
//
//  Created by Daniel on 14-11-13.
//  Copyright (c) 2014年 Daniel. All rights reserved.
//
#import "calendarView.h"
#import "UIColor+RGBCo.h"
#import "RecordDetailVC.h"
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
    

    
    NSDate *dataDate;
    
    NSMutableArray *yueJingDayAry;  //未来一年的月经日子数据都放在这个数组里面
    NSMutableArray *weixianqiDayAry; //记录未来一年的危险期日期
    NSMutableArray *paiRuanDateAry; // 记录未来一年的排卵日;
    NSMutableArray *currenYuejingDayAry;//  这次的月经时间 红色 其余粉色
    
    NSDate *currentDate; // 当前选择的月份的第一天
    
    NSString *qijianStr;
    
    NSDate *needNumberDate; // 预测下次多久时间用
    
}


-(void)awakeFromNib{

    yueJingDayAry =[NSMutableArray array];
    weixianqiDayAry =[NSMutableArray array];
    paiRuanDateAry =[NSMutableArray array];
    currenYuejingDayAry =[NSMutableArray array];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadDataCl:) name:@"reloadDataCl" object:nil];
    
    /**
     *  假设     2014-11-3_3_24
     */
    //  20141111111111_3_24
    NSArray *dataAry =[[[NSUserDefaults standardUserDefaults] objectForKey:RecordHealthId] componentsSeparatedByString:@"_"];
    NSString *timeStr =[dataAry objectAtIndex:0];
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:[timeStr doubleValue]];
    
    
    confromTimesp =[self getTheDate:confromTimesp afterDays:1];
    
    currentDate =[self getTheDate:confromTimesp afterDays:1-(int)[self getDayFromDate:confromTimesp]];
    

    /**
     *  NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:1296035591];
     */
    
    durationDay =[[dataAry objectAtIndex:1] intValue];//月经持续时间
    zhouqiDay =[[dataAry objectAtIndex:2] intValue];//周期时间
    NSDate *paiRuanDate =[self getTheDate:confromTimesp afterDays:zhouqiDay-14]; //第一个排卵日
    
    [CMSinger share].durationDay =durationDay;

    /**
     *  迭代一年时间
     */
    //红色的线
    
    if ([(NSMutableArray *)[[NSUserDefaults standardUserDefaults] objectForKey:@"addYueJingAry"] count] !=0) {
        
        currenYuejingDayAry=[[NSUserDefaults standardUserDefaults] objectForKey:@"addYueJingAry"];
    }else{
        for (int ii =0; ii<durationDay; ii++) {
            
            [currenYuejingDayAry addObject:[self getTheDate:confromTimesp afterDays:ii]];
            
        }
    }
    
    
    for (int timeNumber =-12*3; timeNumber <12*3; timeNumber++) {
        
        //所有的排卵日
        [paiRuanDateAry addObject:[self getTheDate:paiRuanDate afterDays:zhouqiDay*timeNumber]];
        
        for (int tempp =0; tempp <durationDay; tempp++) {
            
            //所有预测的月经期
            NSDate *dateeee =[self getTheDate:[self getTheDate:confromTimesp afterDays:timeNumber*zhouqiDay]  afterDays:tempp];
            NSDateFormatter *fffffff =[[NSDateFormatter alloc] init];
            [fffffff setDateFormat:@"yyyyMM"];
            NSString *strr =[fffffff stringFromDate:dateeee];
            NSString *todatstrr =[fffffff stringFromDate:[NSDate date]];
            if ([strr isEqualToString:todatstrr]) {
                needNumberDate =dateeee;
            }

            [yueJingDayAry addObject:dateeee];
        }
        
        //所有的危险期
        for (int tempxx =0; tempxx <9; tempxx++) {
            [weixianqiDayAry addObject:[self getTheDate:[self getTheDate:paiRuanDate afterDays:timeNumber*zhouqiDay-5]  afterDays:tempxx]];
        }
        
    }
    [CMSinger share].currenYuejingDayAry =currenYuejingDayAry;
    [CMSinger share].paiRuanDateAry =paiRuanDateAry;
    [CMSinger share].yueJingDayAry =yueJingDayAry;
    [CMSinger share].weixianqiDayAry =weixianqiDayAry;
    
    
    daysAry =[NSMutableArray array];
    formater =[[NSDateFormatter alloc]init];
    [formater setDateFormat:@"yyyy年MM月"];
    NSString *TodayStr =[formater stringFromDate:confromTimesp];
//    NSLog(@"今天是星期几--------%lu",(unsigned long)[self getWeekdayFromDate:todayDate]);
//    NSLog(@"这个月总共有-------%lu",(unsigned long)[self getNumberForDate:todayDate]);
//    NSInteger totayDays =(unsigned long)[self getNumberForDate:currentDate];
//    NSLog(@"今天是这个月的第-----%lu",(unsigned long)[self getDayFromDate:todayDate]);
//    NSLog(@"这个月的第1天是星期-----%lu",(unsigned long)[self getTheFirstDayThisMounth:todayDate]);
    
    int firstDayXingQi =(int)[self getTheFirstDayThisMounth:currentDate];
    if (firstDayXingQi ==0) {
        firstDayXingQi =7;
    }
    self.titleLab.text =TodayStr;
    
    /************************/
     

     NSDate *todayTempDate=[NSDate date];
     NSDateFormatter *fff =[[NSDateFormatter alloc] init];
     [fff setDateFormat:@"yyyyMMdd160000"];
     NSString *str =[fff stringFromDate:todayTempDate];
     NSDate *today =[self getTheDate:[fff dateFromString:str] afterDays:1] ;
     
     
     if ([yueJingDayAry containsObject:today]) {
     
     qijianStr =@"亲，您的大姨妈还没来嘛。";
     
     }else if([weixianqiDayAry containsObject:today]){
     qijianStr =@"亲，您当前处于:危险期";
    if([paiRuanDateAry containsObject:today]){
        qijianStr =@"亲，您当前处于:排卵期";
    }
         
     }else{
     qijianStr =@"亲，您当前处于:安全期";
     
     }
    
    /**
     *  处于月经是 是多少天
     */
    if ([currenYuejingDayAry containsObject:today]) {
        
        NSDate *todyaDateaa =[NSDate date];
        NSDateFormatter *sssss =[[NSDateFormatter alloc] init];
        [sssss setDateFormat:@"yyyyMMdd"];
        double aaa =[[sssss stringFromDate:todyaDateaa] doubleValue];
        double bbbb =[[sssss stringFromDate:confromTimesp] doubleValue];
        int number = 0;
        
        if (aaa<bbbb) {
            number =[self xiangCHajitian:today withday:confromTimesp];
        }else if(aaa ==bbbb){
            number =0;
        }else{
            number =[self xiangCHajitian:today withday:confromTimesp];
        }

        
        qijianStr =[NSString stringWithFormat:@"亲，您当前处于月经第%i天",number+1];
    }
     
     
     
     /*********************/
    
    
    for (int i=0; i<6; i++) {
        for (int j=0; j<7; j++) {
            int impotrNum =(7*i+j)+1-(firstDayXingQi-1);
            calendarItemBtn *temp =[[calendarItemBtn alloc] initWithFrame:CGRectMake(46*j-1,46*i+65, 46 , 46)];
            
            
//            if((7*i+j) >=(firstDayXingQi-1)  &&  (7*i+j)<totayDays+(firstDayXingQi-1)){
//                
//                
//                [temp setTitle:[NSString stringWithFormat:@"%i",impotrNum] forState:UIControlStateNormal];
                NSDate *panduanDate =[self getTheDate:currentDate afterDays:impotrNum];
            if ([self isTheSameDayOne:panduanDate wihtTwo:[NSDate date]]) {
                [temp setBackgroundImage:[UIImage imageWithContentFileName:@"today_active@2x.png"] forState:UIControlStateNormal];
            }else{
                [temp setBackgroundImage:[UIImage imageWithContentFileName:@""] forState:UIControlStateNormal];
            }
//                if([weixianqiDayAry containsObject:panduanDate]){
//                    
//                    temp.lineView.backgroundColor =YIYUNQICOLOR;
//                }else{
//                    temp.lineView.backgroundColor =ANQUANQICOLOR;
//                    
//                }
//                
//                if ([yueJingDayAry containsObject:panduanDate]) {
//                    
//                    temp.lineView.backgroundColor =YUCEJINGQICOLOR;
//                    
//                    
//                }
//                if ([currenYuejingDayAry containsObject:panduanDate]) {
//                    temp.lineView.backgroundColor =YUEJINGQICOLOR;
//                }
//                
//                if ([paiRuanDateAry containsObject:panduanDate] &&![yueJingDayAry containsObject:panduanDate]) {
//                    temp.tempImg.image =[UIImage imageNamed:@"pailuanri_logo.png"];
//                    
//                }else{
//                    temp.tempImg.image =[UIImage imageNamed:@""];
//                }
//                
//                
//            }else{
//                 [temp setTitle:@"" forState:UIControlStateNormal];
//                 temp.lineView.backgroundColor =[UIColor clearColor];
//                temp.tempImg.image =[UIImage imageNamed:@""];
//            }
//            
//            //244 227 229
//            [temp addTarget:self action:@selector(didSelect:) forControlEvents:UIControlEventTouchUpInside];
//            temp.tag =7*i+j;
//            temp.titleLabel.font =[UIFont systemFontOfSize:14];
//            [temp setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//            temp.backgroundColor =[UIColor whiteColor];
//            /**
//             *  今天几号
//             */
//            if ((7*i+j)+1-(firstDayXingQi-1) ==(unsigned long)[self getDayFromDate:todayDate]) {
//                
//                didSelectBtn =temp;
//                [temp setBackgroundImage:[UIImage imageWithContentFileName:@"today_active@2x.png"] forState:UIControlStateNormal];
//            }

            
            [self addSubview:temp];
            
            [daysAry addObject:temp];
        
            
        }
    }

    

    
}

-(int)xiangCHajitian:(NSDate *)day1 withday:(NSDate *)day2{
    
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *  senddate=[NSDate date];
    //结束时间
    NSDate *endDate = day1;
    //当前时间
    NSDate *senderDate = day2;
    //得到相差秒数
    NSTimeInterval time=[endDate timeIntervalSinceDate:senderDate];
    
    int days = ((int)time)/(3600*24);
//    int hours = ((int)time)%(3600*24)/3600;
//    int minute = ((int)time)%(3600*24)*600/60;
    
//    if (days <= 0&&hours; <= 0&&minute; <= 0)
//        dateContent=@"0天0小时0分钟";
//    else
//      NSString * dateContent=[[NSString alloc] initWithFormat:@"%i天%i小时%i分钟",days,hours,minute];
    
    return days;
}
/**
 *  刷新日历界面
 */
-(void)calanderReloadData{
    
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self backNowCalendar];
    });

    
    
    NSInteger totayDays =(unsigned long)[self getNumberForDate:currentDate];
    
    
    int firstDayXingQi =(int)[self getTheFirstDayThisMounth:currentDate];
    if (firstDayXingQi ==0) {
        firstDayXingQi =7;
    }
    for (int i=0; i<6; i++) {
        for (int j=0; j<7; j++) {
            
            calendarItemBtn *temp =[daysAry objectAtIndex:7*i+j];
            int impotrNum =(7*i+j)+1-(firstDayXingQi-1);
            if((7*i+j) >=(firstDayXingQi-1)  &&  (7*i+j)<totayDays+(firstDayXingQi-1)){
                
                [temp setTitle:[NSString stringWithFormat:@"%i",impotrNum] forState:UIControlStateNormal];
                NSDate *panduanDate =[self getTheDate:currentDate afterDays:impotrNum];
                if ([self isTheSameDayOne:[self getTheDate:panduanDate afterDays:-1] wihtTwo:[NSDate date]]) {
                    [temp setBackgroundImage:[UIImage imageWithContentFileName:@"today_active@2x.png"] forState:UIControlStateNormal];
                    didSelectBtn =temp;
                }else{
                    [temp setBackgroundImage:[UIImage imageWithContentFileName:@""] forState:UIControlStateNormal];
                }
                
                
                if([weixianqiDayAry containsObject:panduanDate]){
                    
                    temp.lineView.backgroundColor =YIYUNQICOLOR;
                }else{
                    temp.lineView.backgroundColor =ANQUANQICOLOR;
                    
                }
                
                if ([yueJingDayAry containsObject:panduanDate]) {
                    
                    temp.lineView.backgroundColor =YUCEJINGQICOLOR;
                    
                }
                if ([currenYuejingDayAry containsObject:panduanDate]) {
                    temp.lineView.backgroundColor =YUEJINGQICOLOR;
                }
                
                
                if ([paiRuanDateAry containsObject:panduanDate] &&![yueJingDayAry containsObject:panduanDate]) {
                    temp.tempImg.image =[UIImage imageNamed:@"pailuanri_logo.png"];
                }else{
                    temp.tempImg.image =[UIImage imageNamed:@""];
                }
                
                
            }else{
                [temp setTitle:@"" forState:UIControlStateNormal];
                temp.lineView.backgroundColor =[UIColor clearColor];
                temp.tempImg.image =[UIImage imageNamed:@""];
               
                [temp setBackgroundImage:[UIImage imageWithContentFileName:@""] forState:UIControlStateNormal];

            }
            
            //244 227 229
            [temp addTarget:self action:@selector(didSelect:) forControlEvents:UIControlEventTouchUpInside];
            temp.tag =7*i+j;
            temp.titleLabel.font =[UIFont systemFontOfSize:14];
            [temp setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            temp.backgroundColor =[UIColor whiteColor];
            
//            if (impotrNum == [self getDayFromDate:[NSDate date]]) {
//
//                didSelectBtn =temp;
//                
//            }else{
//                
//                [temp setBackgroundImage:[UIImage imageWithContentFileName:@""] forState:UIControlStateNormal];
//            }
            
            
        }
    }
    
    
}

/**
////!!!:手动修改过后的逻辑
 *  手动修改过后的逻辑
 *
 */
-(void)reloadDataCl:(NSNotification *)notification{

    NSNumber *yesOrNo =[notification object];
    
    if ([yesOrNo intValue] ==1) {
        /**
         *   增加月经期 红色条
         */
        if ([currenYuejingDayAry containsObject:[CMSinger share].singerDate]) {
            
            [self setNeedsDisplay];
            return ;
        }
        
        
        for (int iii =0; iii<durationDay; iii++) {
            NSDate *sss =[self getTheDate:[CMSinger share].singerDate afterDays:iii+1];
            if ([currenYuejingDayAry containsObject:sss]) {
                
            }else{
                NSMutableArray *ssssAry =[NSMutableArray arrayWithArray:currenYuejingDayAry];
                
                [ssssAry addObject:sss];
                currenYuejingDayAry =ssssAry ;
            }
            
            
        }
        
        for (int xxx=0; xxx<9; xxx++) {
            
            NSDate *dfdfdf =[self getTheDate:[CMSinger share].singerDate afterDays:xxx-14-5];
            if ([weixianqiDayAry containsObject:dfdfdf]) {
                
            }else{
                NSMutableArray *dfdfdfAry =[NSMutableArray arrayWithArray:weixianqiDayAry];
                
                [dfdfdfAry addObject:dfdfdf];
                weixianqiDayAry =dfdfdfAry;
            }
            
            
        }
        
        [paiRuanDateAry addObject:[self getTheDate:[CMSinger share].singerDate afterDays:-14]];
        
        
    }else if([yesOrNo intValue] ==0){
        //如果是结束传递过来
        //移除月经期  移除危险期 移除拍软日
        
        for (int iii =0; iii<durationDay; iii++) {
            NSDate *dsfdsf =[self getTheDate:[CMSinger share].singerDate afterDays:iii+1];
            
            if ([currenYuejingDayAry containsObject:dsfdsf]) {
                NSMutableArray *dfdfdfAry =[NSMutableArray arrayWithArray:currenYuejingDayAry];
                
                [dfdfdfAry removeObject:dsfdsf];
                currenYuejingDayAry =dfdfdfAry;
                

            }
            
            if ([yueJingDayAry containsObject:dsfdsf]) {
                
                NSMutableArray *dfdfdfAry =[NSMutableArray arrayWithArray:yueJingDayAry];
                
                [dfdfdfAry removeObject:dsfdsf];
                yueJingDayAry =dfdfdfAry;
                
            
            }

            
        }
        
        for (int xxx=0; xxx<9; xxx++) {
           NSDate *dsfdsf =[self getTheDate:[CMSinger share].singerDate afterDays:xxx-14-5];
            if ([weixianqiDayAry containsObject:dsfdsf]) {
                
                NSMutableArray *dfdfdfAry =[NSMutableArray arrayWithArray:weixianqiDayAry];
                [dfdfdfAry removeObject:dsfdsf];
                weixianqiDayAry =dfdfdfAry;
                
            }
            
            
        }
//
        
        if ([paiRuanDateAry containsObject:[self getTheDate:[CMSinger share].singerDate afterDays:-14]]) {
             [paiRuanDateAry removeObject:[self getTheDate:[CMSinger share].singerDate afterDays:-14]];
        }
       
        
        
    }else if([yesOrNo intValue] ==-1){
        //增加一天的月经期
        //增加危险期
        
        [currenYuejingDayAry addObject:[self getTheDate:[CMSinger share].singerDate afterDays:1]];
        
        for (int xxx=0; xxx<9; xxx++) {
            [weixianqiDayAry addObject:[self getTheDate:[CMSinger share].singerDate afterDays:xxx-14-5]];
        }
        
        [paiRuanDateAry addObject:[self getTheDate:[CMSinger share].singerDate afterDays:-14]];
        
    }else{
        
//        for (int iii =0; iii<durationDay; iii++) {
//            [currenYuejingDayAry removeObject:[self getTheDate:[CMSinger share].singerDate afterDays:iii+1]];
//        }
//        
//        for (int xxx=0; xxx<9; xxx++) {
//            [weixianqiDayAry removeObject:[self getTheDate:[CMSinger share].singerDate afterDays:xxx-14-5]];
//        }
//        
//        [paiRuanDateAry removeObject:[self getTheDate:[CMSinger share].singerDate afterDays:-14]];
        
    }


    [CMSinger share].currenYuejingDayAry =currenYuejingDayAry;
    [CMSinger share].paiRuanDateAry =paiRuanDateAry;
    [CMSinger share].yueJingDayAry =yueJingDayAry;
    [CMSinger share].weixianqiDayAry =weixianqiDayAry;
    
    
    [[NSUserDefaults standardUserDefaults] setObject:currenYuejingDayAry forKey:@"addYueJingAry"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [self setNeedsDisplay];
    

}

-(void)didSelect:(id)sender{


    
    calendarItemBtn *btn =(calendarItemBtn *)sender;
    if (btn.titleLabel.text.length ==0) {
        return;
    }
    
    NSDate *panduanDate =[self getTheDate:currentDate afterDays:[btn.titleLabel.text intValue]];
    if([self.CPdelegede respondsToSelector:@selector(setCurrentdate:)]){
        
        [self.CPdelegede setCurrentdate:panduanDate];
    }
    
//    if (didSelectBtn.tag ==btn.tag) {
    
        if ([self.CPdelegede respondsToSelector:@selector(gotoRecordDetailwith:)]) {
            [self.CPdelegede gotoRecordDetailwith:panduanDate];
        }
    
//    }
//    [didSelectBtn setBackgroundImage:[UIImage imageWithContentFileName:@""] forState:UIControlStateNormal];
//    
//    [btn setBackgroundImage:[UIImage imageWithContentFileName:@"today_active@2x.png"] forState:UIControlStateNormal];
    
//    didSelectBtn =btn;
 
    
    NSLog(@"%@",panduanDate);
    
    
    
}
- (IBAction)leftBtnClick:(id)sender {

    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *comps = nil;
    comps = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:currentDate];
    NSDateComponents *adcomps = [[NSDateComponents alloc] init];
    [adcomps setYear:0];
    [adcomps setMonth:-1];
    [adcomps setDay:0];
    currentDate = [calendar dateByAddingComponents:adcomps toDate:currentDate options:0];
    [formater setDateFormat:@"yyyy年MM月"];
    NSString *TodayStr =[formater stringFromDate:currentDate];
    
    self.titleLab.text =TodayStr;

    [self calanderReloadData];

    
}

- (IBAction)rightBtnClick:(id)sender {
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *comps = nil;
    comps = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:currentDate];
    NSDateComponents *adcomps = [[NSDateComponents alloc] init];
    [adcomps setYear:0];
    [adcomps setMonth:+1];
    [adcomps setDay:0];
    currentDate = [calendar dateByAddingComponents:adcomps toDate:currentDate options:0];
    [formater setDateFormat:@"yyyy年MM月"];
    NSString *TodayStr =[formater stringFromDate:currentDate];
    self.titleLab.text =TodayStr;
    [self calanderReloadData];
    
}
/**
 * 显示当前日期
 */
-(void)backNowCalendar{
    
    [formater setDateFormat:@"yyyy_M"];
    NSString *currentDateStr =[formater stringFromDate:currentDate];
    
    NSDateFormatter *formaterNew =[[NSDateFormatter alloc]init];
    [formaterNew setDateFormat:@"yyyy_M"];
    NSDate *date =[NSDate date];
    NSString *TodayStr =[formaterNew stringFromDate:date];
    
    NSArray *currentDateAry =[currentDateStr componentsSeparatedByString:@"_"];
    NSString *currentDateYear =[currentDateAry objectAtIndex:0];
    NSString *currentDatemonth=[currentDateAry objectAtIndex:1];
    
    NSArray *TodayAry =[TodayStr componentsSeparatedByString:@"_"];
    NSString *TodayYear =[TodayAry objectAtIndex:0];
    NSString *Todaymonth=[TodayAry objectAtIndex:1];
    
    int month =([TodayYear intValue]-[currentDateYear intValue])*12 +([Todaymonth intValue]-[currentDatemonth intValue]);
    
    [self getSeverMonthAfterDate:month];
    

}
-(void)getSeverMonthAfterDate:(int)month{
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *comps = nil;
    comps = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:currentDate];
    NSDateComponents *adcomps = [[NSDateComponents alloc] init];
    [adcomps setYear:0];
    [adcomps setMonth:month];
    [adcomps setDay:0];
    currentDate = [calendar dateByAddingComponents:adcomps toDate:currentDate options:0];
    [formater setDateFormat:@"yyyy年MM月"];
    NSString *TodayStr =[formater stringFromDate:currentDate];
    self.titleLab.text =TodayStr;
//    [self calanderReloadData];
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
 *  判断date是这个月的第几天
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
    
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *comps = nil;
    comps = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:todayNewDate];
    NSDateComponents *adcomps = [[NSDateComponents alloc] init];
    [adcomps setYear:0];
    [adcomps setMonth:0];
    [adcomps setDay:1-[self getDayFromDate:todayNewDate]];
    NSDate *resultDate;
    resultDate = [calendar dateByAddingComponents:adcomps toDate:todayNewDate options:0];

    
    return (unsigned long)[self getWeekdayFromDate:resultDate];
}

/**
 *  判断theDate 过了days天后是 什么日子
 *
 *
 *  @return <#return value description#>
 */
-(NSDate *)getTheDate:(NSDate *)theDate afterDays:(int)days{
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *comps = nil;
    comps = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:todayDate];
    NSDateComponents *adcomps = [[NSDateComponents alloc] init];
    [adcomps setYear:0];
    [adcomps setMonth:0];
    [adcomps setDay:days];
    NSDate *resultDate;
    resultDate = [calendar dateByAddingComponents:adcomps toDate:theDate options:0];
//    NSLog(@"resultDate--------%@",resultDate);
    
    return resultDate;
}

-(void)drawRect:(CGRect)rect{
    [super drawRect:rect];
    
    [self calanderReloadData];
    

    NSDate *todyaDateaa =[NSDate date];
    NSDateFormatter *sssss =[[NSDateFormatter alloc] init];
    [sssss setDateFormat:@"yyyyMMdd"];
    double aaa =[[sssss stringFromDate:todyaDateaa] doubleValue];
    double bbbb =[[sssss stringFromDate:needNumberDate] doubleValue];
    int number = 0;
    
    if (aaa>bbbb) {
        number =zhouqiDay-(aaa-bbbb)-durationDay-1;
    }else if(aaa ==bbbb){
        number =zhouqiDay;
    }else{
        number =bbbb-aaa-durationDay;
    }

    
    if ([self.CPdelegede respondsToSelector:@selector(setTitleLab:withnumber:)]) {
        [self.CPdelegede setTitleLab:[NSString stringWithFormat:@"%@",qijianStr] withnumber:number];
    }
    
}
-(BOOL)isTheSameDayOne:(NSDate *)date1 wihtTwo:(NSDate *)date2{
    BOOL result ;

    NSDateFormatter *sssss =[[NSDateFormatter alloc] init];
    [sssss setDateFormat:@"yyyyMMdd"];
    double aaa =[[sssss stringFromDate:date1] doubleValue];
    double bbbb =[[sssss stringFromDate:date2] doubleValue];
    
    if (aaa==bbbb) {
        result =YES;
    }else{
        result =NO;
    }
    
    return result;
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