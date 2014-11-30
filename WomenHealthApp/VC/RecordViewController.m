//
//  RecordViewController.m
//  WomenHealthApp
//
//  Created by 朱 青 on 14-10-23.
//  Copyright (c) 2014年 WomenHealthApp. All rights reserved.
//
/**
 *  
 *  预测经期：例假开始时间+周期天数，时长是经期天数
 *  月经期：月经开始时间，时长是经期天数
 *
    女性的排卵日期一般在下次月经来潮前的14天左右。下次月经来潮的第1天算起，倒数14天或减去14天就是排卵日，排卵日及其前5天和后4天加在一起称为排卵期。例如，某女的月经周期为28天，本次月经来潮的第1天在12月2日，那么下次月经来潮是在12月30日（12月2日加28天），再从12月30日减去14天，则12月16日就是排卵日。排卵日及其前5天和后4天，也就是12月11-20日为排卵期。除了月经期和排卵期，其余的时间均为安全期。
 
 *  上文所指的排卵期即危险期
 */

#import "RecordViewController.h"
#import "RecordDetailVC.h"
#import "calendarView.h"
@interface RecordViewController (){
    NSDate *muBiaoDate;
}

@end

@implementation RecordViewController

+ (UINavigationController *)navigationControllerContainSelf
{
    RecordViewController *vc = [[RecordViewController alloc] initWithNibName:@"RecordViewController" bundle:nil];
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:vc];
    return nav;
}


- (void)loadView
{
    [super loadView];
    
    self.title = @"我的记录";
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    UIButton *rightButton=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
    [rightButton addTarget:self action:@selector(recordDetailAction:) forControlEvents:UIControlEventTouchUpInside];
    [rightButton setBackgroundImage:[UIImage imageWithContentFileName:@"Record_detail_btn.png"] forState:UIControlStateNormal];
    UIBarButtonItem *rightButtonItem=[[UIBarButtonItem alloc]initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem = rightButtonItem;
    
    
    
    calendarView *tempView =(calendarView *)[[[NSBundle mainBundle] loadNibNamed:@"calendarView" owner:self options:nil] lastObject];
    tempView.CPdelegede =self;
    tempView.frame=CGRectMake(0, 110, tempView.frame.size.width, tempView.frame.size.height);
    [self.view addSubview:tempView];
    
    
    
    NSLog(@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"RecordId"]);
}


-(void)gotoRecordDetailwith:(NSDate *)currenDateNew{
    
    RecordDetailVC *vc = [[RecordDetailVC alloc]initWithNibName:@"RecordDetailVC" bundle:nil];
    vc.passDate =currenDateNew;
    [self.navigationController pushViewController:vc animated:YES];
    
}

-(void)setCurrentdate:(NSDate *)curentDate{
    
    muBiaoDate =curentDate;
    [CMSinger share].singerDate =curentDate;
    
}
- (void)recordDetailAction:(id)sender
{
    RecordDetailVC *vc = [[RecordDetailVC alloc]initWithNibName:@"RecordDetailVC" bundle:nil];
    vc.passDate =muBiaoDate;
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
