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

@interface RecordViewController ()

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
    
    self.title = @"我的记录";;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
