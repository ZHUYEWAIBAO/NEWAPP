//
//  BbsSearchVC.m
//  WomenHealthApp
//
//  Created by Daniel on 14/11/15.
//  Copyright (c) 2014年 WomenHealthApp. All rights reserved.
//

#import "BbsSearchVC.h"

@interface BbsSearchVC ()

@end

@implementation BbsSearchVC
+ (UINavigationController *)navigationControllerContainSelf{
    
    
    BbsSearchVC *vc = [[BbsSearchVC alloc] initWithNibName:@"BbsSearchVC" bundle:nil];
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:vc];
    return nav;

    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    //将自定义的视图作为导航条leftBarButtonItem
    UISearchBar *searchBar= [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, 230, 44)];
    
    searchBar.placeholder =@"请输入关键字";
//    UIButton *searchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    searchBtn.frame = CGRectMake(10,2.0,35,35);
//    [searchBtn setImage:[UIImage imageWithContentFileName:@"search_btn"] forState:UIControlStateNormal];
//    [searchBtn addTarget:self action:@selector(searchClick) forControlEvents:UIControlEventTouchUpInside];
//    [searchBtn setImage:[UIImage imageWithContentFileName:@"serarch_btn_selected"] forState:UIControlStateHighlighted];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:searchBar];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    
    UIButton *addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    addBtn.frame = CGRectMake(0,2.0,40,35);
    [addBtn setTitle:@"取消" forState:UIControlStateNormal];
    [addBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [addBtn addTarget:self action:@selector(cancel) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:addBtn];
    self.navigationItem.rightBarButtonItem = rightItem;
    // Do any additional setup after loading the view from its nib.
}
-(void)cancel{
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
    
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
