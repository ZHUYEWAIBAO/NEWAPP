//
//  FirstRecordVC.m
//  WomenHealthApp
//
//  Created by 朱 青 on 14-11-13.
//  Copyright (c) 2014年 WomenHealthApp. All rights reserved.
//

#import "FirstRecordVC.h"
#import "RecordViewController.h"
#import "BBSViewController.h"
#import "ShoppingViewController.h"
#import "SetViewController.h"
#import "UITabbarCommonViewController.h"

#define TAG_CHOOSE 100
#define TAG_CANCEL 101
#define TAG_SAVE   102

@interface FirstRecordVC ()<UITextFieldDelegate>
{
    NSMutableArray *recentYearArray;       //年
    NSMutableArray *recentDayArray;        //日
    
    NSMutableArray *menstrualArray;        //例假数组
    NSMutableArray *cycleArray;            //周期数组
    
    UITextField *currentTextField;
    
    NSInteger currentYear;                 //当前年
    NSInteger currentMonth;                //当前月
    NSInteger currentDay;                  //当前日
    
    NSString *currentMenstrual;            //当前经期天数
    NSString *currentCycle;                //当前周期天数
}

@end

@implementation FirstRecordVC

+ (UINavigationController *)navigationControllerContainSelf
{
    FirstRecordVC *vc = [[FirstRecordVC alloc] initWithNibName:@"FirstRecordVC" bundle:nil];
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:vc];
    return nav;
}

- (void)loadView
{
    [super loadView];
    
    self.title = @"我的记录";
    
    menstrualArray = [[NSMutableArray alloc]init];
    cycleArray = [[NSMutableArray alloc]init];
    recentYearArray = [[NSMutableArray alloc]init];
    recentDayArray = [[NSMutableArray alloc]init];
    
    //默认日期
//    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//    //zzz表示时区，zzz可以删除，这样返回的日期字符将不包含时区信息。
//    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
//    NSString *destDateString = [dateFormatter stringFromDate:[NSDate date]];
//
//    NSArray *array = [destDateString componentsSeparatedByString:@"-"];
//   
//    currentYear = [[array objectAtIndex:0] integerValue];
//    currentMonth = [[array objectAtIndex:1] integerValue];
//    currentDay = [[array objectAtIndex:2] integerValue];
    
    currentYear = 2015;
    currentMonth = 1;
    currentDay = 1;
    
    self.recentTextField.text = [NSString stringWithFormat:@"%ld年%ld月%ld日",currentYear,currentMonth,currentDay];
    
    //经期天数默认5天
    currentMenstrual = @"5";
    //周期天数默认28天
    currentCycle = @"28";
    
    dispatch_queue_t quene =dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(quene, ^{
       
        for (int i = 2; i <= 14; i++) {
            NSString *menstrualStr = [NSString stringWithFormat:@"%d",i];
            [menstrualArray addObject:menstrualStr];
        }
        
        for (int j = 15; j <= 100; j++) {
            NSString *cycleStr = [NSString stringWithFormat:@"%d",j];
            [cycleArray addObject:cycleStr];
        }
        
        for (int x = 2014; x < 2025; x++) {
            NSString *recontYearStr = [NSString stringWithFormat:@"%d",x];
            [recentYearArray addObject:recontYearStr];
        }
        
        [self getTheCurrentMonthDayArray];
        
    });
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setViewLayer:self.recentView andCornerRadius:4 andBorderColor:[UIColor lightGrayColor] andBorderWidth:0.6f];
    [self setViewLayer:self.menstrualView andCornerRadius:4 andBorderColor:[UIColor lightGrayColor] andBorderWidth:0.6f];
    [self setViewLayer:self.cycleView andCornerRadius:4 andBorderColor:[UIColor lightGrayColor] andBorderWidth:0.6f];
    
    self.recentTextField.inputView = self.actionView;
    self.recentTextField.delegate = self;

    self.menstrualTextField.inputView = self.actionView;
    self.menstrualTextField.delegate = self;
    
    self.cycleTextField.inputView = self.actionView;
    self.cycleTextField.delegate = self;
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (textField == self.recentTextField) {
        currentTextField = self.recentTextField;
    }
    else if (textField == self.menstrualTextField){
        currentTextField = self.menstrualTextField;
    }
    else{
        currentTextField = self.cycleTextField;
    }
    
    [self.pickerView reloadAllComponents];
    
    if (textField == self.recentTextField) {
        
    }
    else if (textField == self.menstrualTextField){
        //默认经期5天
        [self.pickerView selectRow:3 inComponent:0 animated:NO];
    }
    else{
        //默认周期28天
        [self.pickerView selectRow:13 inComponent:0 animated:NO];
    }
    
    return YES;
}

#pragma mark UIPickerViewDelegate
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    
    if (currentTextField == self.recentTextField) {
        return 3;
    }

    return 1;
}

- (NSInteger) pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    
    if (currentTextField == self.recentTextField) {
        switch (component) {
            case 0:{
                return [recentYearArray count];
            }
                break;
                
            case 1:{
                return 12;
            }
                break;
                
            case 2:{
                return [COMMONDSHARE getDayNumberWithYear:currentYear month:currentMonth];
            }
                break;
                
            default:
                break;
        }

    }
    else if (currentTextField == self.menstrualTextField){
        return [menstrualArray count];
    }
    else{
        return [cycleArray count];
    }
    
    return 0;
}

- (NSString *) pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{

    if (currentTextField == self.recentTextField) {
        switch (component) {
            case 0:{
                return [NSString stringWithFormat:@"%@年",[recentYearArray objectAtIndex:row]];
            }
                break;
                
            case 1:{
                return [NSString stringWithFormat:@"%ld月",row+1];
                
            }
                break;
                
            case 2:{
                return [NSString stringWithFormat:@"%@日",[recentDayArray objectAtIndex:row]];
            }
                break;
                
            default:
                break;
        }
        
    }
    else if (currentTextField == self.menstrualTextField){
        return [NSString stringWithFormat:@"%@天",[menstrualArray objectAtIndex:row]];
    }
    else{
        return [NSString stringWithFormat:@"%@天",[cycleArray objectAtIndex:row]];
    }
    
    return @"";
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
    if (currentTextField == self.recentTextField) {
        
        switch (component) {
            case 0:{
                currentYear = [[recentYearArray objectAtIndex:row] integerValue];
                
                [self getTheCurrentMonthDayArray];
                [self.pickerView reloadComponent:2];
            }
                break;
                
            case 1:{
                currentMonth = row + 1;
                
                [self getTheCurrentMonthDayArray];
                [self.pickerView reloadComponent:2];
            }
                break;
                
            case 2:{
                currentDay = [[recentDayArray objectAtIndex:row] integerValue];
            }
                break;
                
            default:
                break;
        }
    }
    else if (currentTextField == self.menstrualTextField){
        currentMenstrual = [menstrualArray objectAtIndex:row];
    }
    else{
        currentCycle = [cycleArray objectAtIndex:row];
    }

}

//获取当前月份天数数组
- (void)getTheCurrentMonthDayArray
{
    for (int y = 1; y <= [COMMONDSHARE getDayNumberWithYear:currentYear month:currentMonth]; y++) {
        NSString *recontDayStr = [NSString stringWithFormat:@"%d",y];
        [recentDayArray addObject:recontDayStr];
    }
 
}

#pragma mark 按钮事件
- (IBAction)btnClickAction:(id)sender
{
    UIButton *button = (UIButton *)sender;
    
    switch (button.tag) {
        case TAG_CHOOSE:{
            if (currentTextField == self.recentTextField) {
                currentTextField.text = [NSString stringWithFormat:@"%ld年%ld月%ld日",currentYear,currentMonth,currentDay];
            }
            else if (currentTextField == self.menstrualTextField){
                currentTextField.text = [currentMenstrual stringByAppendingString:@"天"];
            }
            else{
                currentTextField.text = [currentCycle stringByAppendingString:@"天"];
            }
            [currentTextField resignFirstResponder];
        }
            break;
            
        case TAG_CANCEL:{
            [currentTextField resignFirstResponder];
        }
            break;
            
        case TAG_SAVE:{
            
            if ([self ifCanSaveTheDate]) {
                
                NSString *month;
                NSString *day;
                if (currentMonth < 10) {
                    month = [NSString stringWithFormat:@"0%ld",currentMonth];
                }
                else{
                    month = [NSString stringWithFormat:@"%ld",currentMonth];
                }
                
                if (currentDay < 10) {
                    day = [NSString stringWithFormat:@"0%ld",currentDay];
                }
                else{
                    day = [NSString stringWithFormat:@"%ld",currentDay];
                }
                NSString *time = [NSString stringWithFormat:@"%ld%@%@000000",currentYear,month,day];
                NSString *recordKey = [NSString stringWithFormat:@"%@_%@_%@",[self getTheWomanTime:time],currentMenstrual,currentCycle];
                [COMMONDSHARE saveTheRecordKey:recordKey];
   
                UITabbarCommonViewController *tabCtrl = [[UITabbarCommonViewController alloc]initWithNibName:@"UITabbarCommonViewController" bundle:nil];
                UINavigationController *record_vc = [RecordViewController navigationControllerContainSelf];
                //圈子
                UINavigationController *bbs_vc = [BBSViewController navigationControllerContainSelf];
                //购物
                UINavigationController *shopping_vc = [ShoppingViewController navigationControllerContainSelf];
                //设置
                UINavigationController *set_vc = [SetViewController navigationControllerContainSelf];
                
                NSArray *ctrs = [NSArray arrayWithObjects:record_vc,bbs_vc,shopping_vc,set_vc,nil];
                
                NSArray *imgs = [NSArray  arrayWithObjects:[UIImage imageWithContentFileName:@"new_record_btn.png"],[UIImage imageWithContentFileName:@"new_circle_btn.png"],[UIImage imageWithContentFileName:@"new_buy_btn.png"],[UIImage imageWithContentFileName:@"new_set_btn.png"],nil];
                
                NSArray *sImgs = [NSArray arrayWithObjects:[UIImage imageWithContentFileName:@"new_record_btn_selected.png"],[UIImage imageWithContentFileName:@"new_circle_btn_selected.png"],[UIImage imageWithContentFileName:@"new_buy_btn_selected.png"],[UIImage imageWithContentFileName:@"new_set_btn_selected.png"],nil];
                
                NSArray *tits = [NSArray arrayWithObjects:@"记录",@"圈子",@"购物",@"设置",nil];
                
                tabCtrl.viewControllers = ctrs;
                tabCtrl.images = imgs;
                tabCtrl.selectImages = sImgs;
                tabCtrl.titles = tits;
                
                [WHSinger share].customTabbr = tabCtrl;
                
                [self.navigationController pushViewController:tabCtrl animated:YES];
                [self.navigationController setNavigationBarHidden:YES animated:YES];
            }
            
        }
            break;
            
        default:
            break;
    }
}

- (BOOL)ifCanSaveTheDate
{
    if ([@"" isEqualToString:self.recentTextField.text]) {

        [[CustomItoast showText:@"上次例假开始时间还没填哦！"] showInView:self.view];
        return NO;
    }
    
    if ([@"" isEqualToString:self.menstrualTextField.text]) {
        [[CustomItoast showText:@"平均例假天数还没填哦！"] showInView:self.view];
        return NO;
    }
    
    if ([@"" isEqualToString:self.cycleTextField.text]) {
        [[CustomItoast showText:@"周期天数还没填哦！"] showInView:self.view];
        return NO;
    }
    
    return YES;
}

- (NSString *)getTheWomanTime:(NSString *)time
{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"yyyyMMddHHmmss"]; // ----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
    
    NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    [formatter setTimeZone:timeZone];
    
    NSDate *date = [formatter dateFromString:time];
    
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[date timeIntervalSince1970]];
 
    return timeSp;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
