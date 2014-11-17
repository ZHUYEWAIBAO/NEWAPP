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
@interface BBSViewController (){
    
    IBOutlet UIPageControl *pageControl;
    
}

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
    searchBtn.frame = CGRectMake(10,2.0,35,35);
    [searchBtn setImage:[UIImage imageWithContentFileName:@"search_btn"] forState:UIControlStateNormal];
    [searchBtn addTarget:self action:@selector(searchClick) forControlEvents:UIControlEventTouchUpInside];
    [searchBtn setImage:[UIImage imageWithContentFileName:@"serarch_btn_selected"] forState:UIControlStateHighlighted];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:searchBtn];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    UIButton *addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    addBtn.frame = CGRectMake(10,2.0,35,35);
    [addBtn setImage:[UIImage imageWithContentFileName:@"add_btn"] forState:UIControlStateNormal];
    [addBtn setImage:[UIImage imageWithContentFileName:@"add_btn_selected"] forState:UIControlStateHighlighted];
    [addBtn addTarget:self action:@selector(addClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:addBtn];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    
    
    
    for (int i =0; i<4; i++) {
        
        UIButton *tempBtn =[[UIButton alloc] initWithFrame:CGRectMake(320*i, 0, 320, 150)];
        [tempBtn setImage:[UIImage imageNamed:[NSString stringWithFormat:@"addview%i.jpg",i]] forState:UIControlStateNormal];
        
        [self.addScrollview addSubview:tempBtn];
    }
    self.addScrollview.contentSize =CGSizeMake(320*4, 0);
    self.addScrollview.bounces =NO;
    self.addScrollview.pagingEnabled =YES;
    self.addScrollview.delegate =self;
    

    pageControl.numberOfPages =4;
    [self.view addSubview:pageControl];
    
    
    
    // Do any additional setup after loading the view from its nib.
}
#pragma mark tableview
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 7;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    

    static NSString *indertifier =@"bbsTableCell";
    
    bbsTableCell *cell =[tableView dequeueReusableCellWithIdentifier:indertifier];
    if (cell ==nil) {
        cell =(bbsTableCell *)[[[NSBundle mainBundle] loadNibNamed:@"bbsTableCell" owner:self options:nil] lastObject];
    }
    

    return cell;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 76;
}


-(void)searchClick{

    
    [self presentViewController:[BbsSearchVC navigationControllerContainSelf] animated:YES completion:nil];
    
    
}

-(void)addClick{
    BbsFenLeiVC *vc =[[BbsFenLeiVC alloc]initWithNibName:@"BbsFenLeiVC" bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];

    
    
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    int page =scrollView.contentOffset.x/320;
    pageControl.currentPage =page;
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
