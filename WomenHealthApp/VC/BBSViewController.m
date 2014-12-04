//
//  BBSViewController.m
//  WomenHealthApp
//
//  Created by 朱 青 on 14-10-23.
//  Copyright (c) 2014年 WomenHealthApp. All rights reserved.
//

#import "BBSViewController.h"
#import "bbsTableCell.h"
#import "BbsSearchVC.h"
#import "BbsFenLeiVC.h"
#import "CycleScrollView.h"
@interface BBSViewController ()
{

    UIView *sectionView;
}
@property (nonatomic , strong) CycleScrollView *mainScorllView;

@end

@implementation BBSViewController

+ (UINavigationController *)navigationControllerContainSelf
{
    BBSViewController *vc = [[BBSViewController alloc] initWithNibName:@"BBSViewController" bundle:nil];
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:vc];
    return nav;
}

- (void)loadView
{
    [super loadView];
    
    self.title = @"我的圈子";
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //将自定义的视图作为导航条leftBarButtonItem
    UIButton *searchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    searchBtn.frame = CGRectMake(0,0,30,30);
    [searchBtn setImage:[UIImage imageWithContentFileName:@"search_btn"] forState:UIControlStateNormal];
    [searchBtn setImage:[UIImage imageWithContentFileName:@"serarch_btn_selected"] forState:UIControlStateHighlighted];
    [searchBtn addTarget:self action:@selector(searchClick) forControlEvents:UIControlEventTouchUpInside];

    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:searchBtn];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    UIButton *addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    addBtn.frame = CGRectMake(0,0,30,30);
    [addBtn setImage:[UIImage imageWithContentFileName:@"add_btn"] forState:UIControlStateNormal];
    [addBtn setImage:[UIImage imageWithContentFileName:@"add_btn_selected"] forState:UIControlStateHighlighted];
    [addBtn addTarget:self action:@selector(addClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:addBtn];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    NSMutableArray *viewsArray = [@[] mutableCopy];
    NSArray *colorArray = @[[UIColor cyanColor],[UIColor blueColor]];
    for (int i = 0; i < 2; ++i) {
        UILabel *tempLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 120)];
        tempLabel.backgroundColor = [(UIColor *)[colorArray objectAtIndex:i] colorWithAlphaComponent:0.5];
        [viewsArray addObject:tempLabel];
    }
    
    self.mainScorllView = [[CycleScrollView alloc] initWithFrame:CGRectMake(0, 0, 320, 120) animationDuration:3];

    self.mainScorllView.fetchContentViewAtIndex = ^UIView *(NSInteger pageIndex){
        return viewsArray[pageIndex];
    };
    self.mainScorllView.totalPagesCount = ^NSInteger(void){
        return 2;
    };
    self.mainScorllView.TapActionBlock = ^(NSInteger pageIndex){
        NSLog(@"点击了第%ld个",pageIndex);
    };

    self.bbsTableView.tableHeaderView = self.mainScorllView;
    self.bbsTableView.tableFooterView = self.footView;
}

#pragma mark tableview
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 7;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
  
    bbsTableCell *cell =[tableView dequeueReusableCellWithIdentifier:[bbsTableCell cellIdentifier]];
    if (cell ==nil) {
        cell = (bbsTableCell *)[[[NSBundle mainBundle] loadNibNamed:@"bbsTableCell" owner:self options:nil] lastObject];
    }
    

    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSArray *nibArr = [[NSBundle mainBundle] loadNibNamed:@"bbsTableCell" owner:self options:nil];
    bbsTableCell *cell = [nibArr objectAtIndex:0];
    return cell.frame.size.height;
 
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    if (nil == sectionView) {
        sectionView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_SIZE.width, 30)];
        sectionView.backgroundColor = RGBACOLOR(243, 240, 234, 1.0);
    }
    UILabel *sectionLabel = (UILabel *)[sectionView viewWithTag:1000];
    //Title
    if (sectionLabel == nil) {
        sectionLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 120, 20)];
        sectionLabel.textAlignment = NSTextAlignmentLeft;
        sectionLabel.backgroundColor = [UIColor clearColor];
        sectionLabel.font = [UIFont systemFontOfSize:12.0f];
        sectionLabel.textColor = [UIColor darkGrayColor];
        sectionLabel.text = @"加入的圈子(2)";
        [sectionLabel setTag:1000];
        [sectionView addSubview:sectionLabel];
    }
    return sectionView;
}

- (void)searchClick
{
    [self presentViewController:[BbsSearchVC navigationControllerContainSelf] animated:YES completion:nil];
    
}

- (void)addClick
{
    
    BbsFenLeiVC *vc = [[BbsFenLeiVC alloc]initWithNibName:@"BbsFenLeiVC" bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
