//
//  OrderCommentListVC.m
//  WomenHealthApp
//
//  Created by 朱青 on 14/12/18.
//  Copyright (c) 2014年 WomenHealthApp. All rights reserved.
//

#import "OrderCommentListVC.h"
#import "CommentListModel.h"
#import "CommentGoodsCell.h"
#import "LineImageView.h"

@interface OrderCommentListVC ()

@end

@implementation OrderCommentListVC

- (void)loadView
{
    [super loadView];
    
    self.title = @"商品评价";
    
    //允许下拉刷新
    self.tableView = self.commentTableView;
    
    //允许上拉分页加载
    self.isNeedLoadMore=YES;
    self.page = 1;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _commentArray = [[NSMutableArray alloc]init];
    
    [self getTheOrderCommentWithGoodsId:self.commentId];
}

//获取订单评价
- (void)getTheOrderCommentWithGoodsId:(NSString *)goodsId
{
    if (self.page == 1) {
        [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];
    }
    
    NSString *path = [NSString stringWithFormat:@"/api/ec/comment.php?act=comment_list&goods_id=%@&page=%ld",goodsId,self.page];
 
    [NETWORK_ENGINE requestWithPath:path Params:self.params CompletionHandler:^(MKNetworkOperation *completedOperation) {
        
        NSDictionary *dic=[completedOperation responseDecodeToDic];
        
        NSDictionary *statusDic = [dic objectForKey:@"status"];
        
        if ([@"1" isEqualToString:CHECK_VALUE([statusDic objectForKey:@"statu"])]) {
            
            NSDictionary *data = [dic objectForKey:@"data"];
            NSDictionary *pageDic = [data objectForKey:@"pager"];
            self.totalRowNum = [CHECK_VALUE([pageDic objectForKey:@"record_count"]) integerValue];
             
            NSArray *ary = CHECK_ARRAY_VALUE([data objectForKey:@"comments"]);
            
            if (ary.count>0) {
                //如果是第一页，清空数组
                if (self.page == 1) {
                    [self.commentArray removeAllObjects];
                    self.footview.hidden=NO;
                }
                
                for (NSDictionary *dic in ary) {
                    CommentListModel *model = [CommentListModel parseDicToLogisticsObject:dic];
                    
                    [self.commentArray addObject:model];
                }
                
                if(self.page == 1&&[self.commentArray count]>0){
                    
                    //tableview返回第一行
                    self.commentTableView.contentSize = CGSizeMake(320, 0);
                    
                }
                //当前数据小于总数据的时候页数++
                if (self.commentArray.count < self.totalRowNum) {
                    self.page++;
                }
                else{
                    self.footview.hidden=YES;
                }
                
            }
            [self.commentTableView reloadData];
            
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

#pragma mark UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return self.commentArray.count;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CommentListModel *model = [self.commentArray objectAtIndex:indexPath.row];
    float contentHeight = HeightForString(model.discuss_content, 13, 300)+10;
    
    if (model.imageArray.count == 0) {
        return 33 + contentHeight;
    }

    return contentHeight + 83;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    CommentGoodsCell *cell = [tableView dequeueReusableCellWithIdentifier:[CommentGoodsCell cellIdentifier]];
    if (cell == nil){
        
        NSArray *nibArr = [[NSBundle mainBundle] loadNibNamed:@"CommentGoodsCell" owner:self options:nil];
        cell = [nibArr objectAtIndex:0];
 
        
    }
    
    CommentListModel *model = [self.commentArray objectAtIndex:indexPath.row];
    
    cell.nameLabel.text = model.discuss_user_name;
    cell.contenLabel.text = model.discuss_content;
    cell.timeLabel.text = model.discuss_time;
    
    float contentHeight = HeightForString(model.discuss_content, 13, 300)+10;
    
    CGRect rect = cell.frame;
    if (model.imageArray.count == 0) {
        cell.secondView.hidden = YES;
        rect.size.height = cell.contenLabel.frame.origin.y + contentHeight;
    }
    else{
        cell.secondView.hidden = NO;
        rect.size.height = cell.contenLabel.frame.origin.y + contentHeight + 50;
        cell.secondView.frame = CGRectMake(cell.secondView.frame.origin.x, rect.size.height - 50, cell.secondView.frame.size.width, 50);
    }
    cell.frame = rect;
    
    LineImageView *lineImgV = [[LineImageView alloc]initWithFrame:CGRectMake(10, cell.frame.size.height-1, cell.frame.size.width - 20, 0.5)];
    [cell.contentView addSubview:lineImgV];
    
    [cell.userImageView setImageWithURL:[NSURL URLWithString:model.discuss_user_avatar]];
    
    
    for (NSInteger i = 0; i < model.imageArray.count; i++) {
        UIImageView *commentImageView = (UIImageView *)[cell valueForKey:[NSString stringWithFormat:@"commentImageView%ld",i]];
        [commentImageView setHidden:NO];
        [commentImageView setImageWithURL:[NSURL URLWithString:[model.imageArray objectAtIndex:i]]];
        
    }
  
    return cell;
    
    
}

#pragma mark - 分页加载
//上拉分页加载
- (void)refreshViewBeginRefreshing:(MJRefreshBaseView *)refreshView
{
    if (refreshView == self.footview){
        [self getTheOrderCommentWithGoodsId:self.commentId];
    }
}

#pragma mark - 下拉刷新
- (void)reloadTableViewDataSource
{
    if (self.isLoading) { return;}
    self.page = 1;
    [self getTheOrderCommentWithGoodsId:self.commentId];
    [super reloadTableViewDataSource];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
