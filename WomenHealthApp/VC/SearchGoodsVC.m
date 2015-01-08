//
//  SearchGoodsVC.m
//  WomenHealthApp
//
//  Created by 朱青 on 14/12/4.
//  Copyright (c) 2014年 WomenHealthApp. All rights reserved.
//

#import "SearchGoodsVC.h"
#import "SearchResultVC.h"
#import "CustomSearchCell.h"

@interface SearchGoodsVC ()<UITextFieldDelegate>
{
    /**
     *  历史搜索数组
     */
    NSArray *historyAry;
}
@end

@implementation SearchGoodsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //设置搜索栏位置
    [self.searchNavView setFrame:CGRectMake(0, 0, self.searchNavView.frame.size.width, self.searchNavView.frame.size.height)];
    
    [self setViewLayer:self.searchView andCornerRadius:3 andBorderColor:[UIColor whiteColor] andBorderWidth:0.6f];

    //设置tableview的footview
    self.hisStoryTableView.tableFooterView = self.clearSearchView;
    self.searchTextField.delegate = self;
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    [self.navigationController.navigationBar addSubview:self.searchNavView];

    historyAry = [self getTheSearchKeys];
    [self.hisStoryTableView reloadData];
    
    //取消响应状态
    [self.searchTextField resignFirstResponder];
    [self.searchTextField setText:@""];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];

    [self.searchNavView removeFromSuperview];

}

#pragma mark - UITableView DataSource Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(historyAry.count > 20){
        return 20;
    }
    else{
        return [historyAry count];
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *nibArr = [[NSBundle mainBundle] loadNibNamed:@"CustomSearchCell" owner:self options:nil];
    CustomSearchCell *cell = [nibArr objectAtIndex:0];
    
    return cell.frame.size.height;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CustomSearchCell *cell = [tableView dequeueReusableCellWithIdentifier:[CustomSearchCell cellIdentifier]];
    
    if (cell == nil) {
        
        cell =  (CustomSearchCell *)[[[NSBundle mainBundle] loadNibNamed:@"CustomSearchCell" owner:self options:nil] lastObject];
        
        UIImageView *lineImgV=[[UIImageView alloc]initWithFrame:CGRectMake(0, cell.frame.size.height-1, cell.frame.size.width, 0.5)];
        [cell.contentView addSubview:lineImgV];
        
        [lineImgV setBackgroundColor:RGBACOLOR(199, 199, 204, 1.0)];
    }
    
    if (historyAry.count > indexPath.row) {
        
        [cell.searchNameLabel setText:[historyAry objectAtIndex:indexPath.row]];
        
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [self.searchTextField resignFirstResponder];
    
    SearchResultVC *vc = [[SearchResultVC alloc]initWithNibName:@"SearchResultVC" bundle:nil];
  
    vc.currentKeyWords = [historyAry objectAtIndex:indexPath.row];
    
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)setResultPush:(NSString *)contentString
{
    NSString *replaceString = [contentString stringByReplacingOccurrencesOfString:@" " withString:@""];//用空字符串代替空格
    if (replaceString.length > 0) {
        [self saveTheSearchKey:replaceString];
        
        SearchResultVC *vc = [[SearchResultVC alloc]initWithNibName:@"SearchResultVC" bundle:nil];
        vc.currentKeyWords = contentString;
        [self.navigationController pushViewController:vc animated:YES];
        
    }
    else{
        contentString=@"";
    }
    
}

#pragma mark - 按钮事件
//保存搜索历史
- (void)saveTheSearchKey:(NSString *)searchKey
{
    NSUserDefaults *userDefualt = [NSUserDefaults standardUserDefaults];
    NSArray *history = [userDefualt objectForKey:GOODS_SEARCH_KEY];
    NSMutableArray *array = [[NSMutableArray alloc]initWithArray:history];
    if (!array) {
        array = [[NSMutableArray alloc]initWithCapacity:0];
    }
    if (![array containsObject:searchKey] && [array isKindOfClass:[NSMutableArray class]]) {
        [array insertObject:searchKey atIndex:0];
    }
    history = [NSArray arrayWithArray:array];
    [userDefualt setObject:history forKey:GOODS_SEARCH_KEY];
}

//获取搜索历史数组
- (NSArray *)getTheSearchKeys
{
    return [[NSUserDefaults standardUserDefaults]objectForKey:GOODS_SEARCH_KEY];
}

//清除历史记录
- (IBAction)dissmissHistory:(id)sender
{
    
    NSUserDefaults *userDefualt = [NSUserDefaults standardUserDefaults];
    NSArray *history = [userDefualt objectForKey:GOODS_SEARCH_KEY];
    NSMutableArray *array = [[NSMutableArray alloc]initWithArray:history];
    [array removeAllObjects];
    history = [NSArray arrayWithArray:array];
    [userDefualt setObject:history forKey:GOODS_SEARCH_KEY];
    
    historyAry =[NSArray array];
    [self.hisStoryTableView reloadData];
    
}

- (IBAction)popToNavigation:(id)sender
{

    if ([self.searchTextField isFirstResponder]) {
        
        [self.searchTextField resignFirstResponder];
        [self.searchTextField setText:@""];
     
    }
    else{
        [self.navigationController popViewControllerAnimated:YES];
    }
 
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    [self setResultPush:textField.text];
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
