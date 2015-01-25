//
//  PostSearchVC.m
//  WomenHealthApp
//
//  Created by 朱青 on 15/1/12.
//  Copyright (c) 2015年 WomenHealthApp. All rights reserved.
//

#import "PostSearchVC.h"
#import "PostSearchListCell.h"
#import "PostSearchModel.h"
#import "LineImageView.h"
#import "PostDetailVC.h"

@interface PostSearchVC ()

@end

@implementation PostSearchVC

- (void)loadView
{
    [super loadView];
    
    self.title = self.currentKeyWords;
    
    //允许下拉刷新
    self.tableView = self.searchTableView;
    
    //允许上拉分页加载
    self.isNeedLoadMore=YES;
    self.page = 1;
    
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    _postArray = [[NSMutableArray alloc]initWithCapacity:5];
    
    [self getTheSearchResultWithKeyWord:self.currentKeyWords];
}

- (void)getTheSearchResultWithKeyWord:(NSString *)string
{
    if (self.page == 1) {
        [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];
    }
    
    NSString *path = [NSString stringWithFormat:@"/api/dz/search.php?mod=forum&kw=%@&page=%ld",string,self.page];
    
    NSString *enStr =  [path stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    [NETWORK_ENGINE requestWithPath:enStr Params:self.params CompletionHandler:^(MKNetworkOperation *completedOperation) {
        
        NSDictionary *dic=[completedOperation responseDecodeToDic];
        
        NSDictionary *statusDic = [dic objectForKey:@"status"];
        
        if ([@"1" isEqualToString:CHECK_VALUE([statusDic objectForKey:@"statu"])]) {
            
            NSDictionary *data = [dic objectForKey:@"data"];
            
            self.totalRowNum = [CHECK_VALUE([data objectForKey:@"total_count"]) integerValue];
            
            NSArray *ary = CHECK_ARRAY_VALUE([data objectForKey:@"data"]);
            
            if (ary.count>0) {
                //如果是第一页，清空数组
                if (self.page == 1) {
                    [self.postArray removeAllObjects];
                    self.footview.hidden=NO;
                }
                
                for (NSDictionary *dic in ary) {
                    PostSearchModel *model = [PostSearchModel parseDicToPostSearchObject:dic];
                    
                    [self.postArray addObject:model];
                }
                
                if(self.page == 1&&[self.postArray count]>0){
                    
                    //tableview返回第一行
                    self.searchTableView.contentSize = CGSizeMake(SCREEN_SIZE.width, 0);
                    
                }
                //当前数据小于总数据的时候页数++
                if (self.postArray.count < self.totalRowNum) {
                    self.page++;
                }
                else{
                    self.footview.hidden=YES;
                }
                
            }
            else{
                [self showSearchEmpty];
            }
            
            [self.searchTableView reloadData];
            
            [SVProgressHUD dismiss];
            
            [self doneLoadingTableViewData];
            [self.footview endRefreshing];
            
        }
        else{
            [SVProgressHUD showErrorWithStatus:CHECK_VALUE([statusDic objectForKey:@"msg"])];
        }
        
    } ErrorHandler:^(MKNetworkOperation *completedOperation, NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"服务器忙，请稍候再试"];
        [self doneLoadingTableViewData];
        [self.footview endRefreshing];
    }];

}

#pragma mark tableview
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.postArray.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    PostSearchListCell *cell =[tableView dequeueReusableCellWithIdentifier:[PostSearchListCell cellIdentifier]];
    if (cell ==nil) {
        cell = (PostSearchListCell *)[[[NSBundle mainBundle] loadNibNamed:@"PostSearchListCell" owner:self options:nil] lastObject];
        
        LineImageView *lineImgV=[[LineImageView alloc]initWithFrame:CGRectMake(15, cell.frame.size.height-1, cell.frame.size.width - 15, 0.5)];
        [cell.contentView addSubview:lineImgV];
        
    }
    PostSearchModel *model = [self.postArray objectAtIndex:indexPath.row];
    
    cell.timeLabel.text = model.dateline;
    cell.authorLabel.text = model.author;
    cell.postLabel.text = model.subject;
    cell.messageLabel.text = model.message;

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    PostSearchModel *model = [self.postArray objectAtIndex:indexPath.row];
    
    PostDetailVC *vc = [[PostDetailVC alloc]initWithNibName:@"PostDetailVC" bundle:nil];
    
    vc.currentTid = model.tid;
    
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSArray *nibArr = [[NSBundle mainBundle] loadNibNamed:@"PostSearchListCell" owner:self options:nil];
    PostSearchListCell *cell = [nibArr objectAtIndex:0];
    return cell.frame.size.height;
    
}

#pragma mark - 分页加载
//上拉分页加载
- (void)refreshViewBeginRefreshing:(MJRefreshBaseView *)refreshView
{
    if (refreshView == self.footview){
        [self getTheSearchResultWithKeyWord:self.currentKeyWords];
    }
}

#pragma mark - 下拉刷新
- (void)reloadTableViewDataSource
{
    if (self.isLoading) { return;}
    self.page = 1;
    [self getTheSearchResultWithKeyWord:self.currentKeyWords];
    [super reloadTableViewDataSource];
}

- (void)showSearchEmpty
{
    [self.searchTableView setHidden:YES];
    [self.searchEmptyView setHidden:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
