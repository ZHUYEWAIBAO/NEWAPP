//
//  MyCircleListVC.m
//  WomenHealthApp
//
//  Created by 朱青 on 15/1/21.
//  Copyright (c) 2015年 WomenHealthApp. All rights reserved.
//

#import "MyCircleListVC.h"
#import "MyPostModel.h"
#import "JSONKit.h"
#import "MyCircleListCell.h"
#import "PostDetailVC.h"

@interface MyCircleListVC ()
{
    BOOL isChooseEdit;
 
}

@end

@implementation MyCircleListVC

- (void)loadView
{
    [super loadView];
    
    //允许下拉刷新
    self.tableView = self.circleTableView;
    
    //允许上拉分页加载
    self.isNeedLoadMore=YES;
    self.page = 1;
    
    _circleArray1 = [[NSMutableArray alloc]init];
    _circleArray2 = [[NSMutableArray alloc]init];

    
}

- (void)viewDidLoad {
    [super viewDidLoad];

    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:_editBtn];
    self.navigationItem.rightBarButtonItem = rightItem;

    
    self.circleType = circleType_myPost;
    [self getThePostData];
    
    _titeBtnArray = [[NSMutableArray alloc]initWithObjects:_myPostBtn,_myReturnBtn, nil];
    _myPostBtn.selected = YES;
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    [_titleView setFrame:CGRectMake(67, 0, _titleView.frame.size.width, _titleView.frame.size.height)];
    [self.navigationController.navigationBar addSubview:_titleView];
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    
    [_titleView removeFromSuperview];
}

- (NSMutableArray *)circleArray
{
    _circleArray = [self valueForKey:[NSString stringWithFormat:@"circleArray%d",self.circleType]];
    return _circleArray;
}

- (void)getThePostData
{
    if (self.page == 1) {
        [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];
    }
    
    NSString *path = [NSString stringWithFormat:@"/api/dz/home.php?mod=space&uid=%@&do=thread&view=me&from=space&page=%ld",USERINFO.uid,self.page];
    
    switch (self.circleType) {

        case circleType_myPost:{
            path = [path stringByAppendingString:@"&type=thread"];
        }
            break;
            
        case circleType_myReturn:{
            path = [path stringByAppendingString:@"&type=reply"];
        }
            break;
            
        default:
            break;
    }
    
    [self.params removeAllObjects];
    [NETWORK_ENGINE requestWithPath:path Params:self.params CompletionHandler:^(MKNetworkOperation *completedOperation) {
        
        NSDictionary *dic=[completedOperation responseDecodeToDic];
        
        NSDictionary *statusDic = [dic objectForKey:@"status"];
        
        if ([@"1" isEqualToString:CHECK_VALUE([statusDic objectForKey:@"statu"])]) {
            
            NSDictionary *data = [dic objectForKey:@"data"];
            
            self.totalRowNum = [CHECK_VALUE([data objectForKey:@"total_subject"]) integerValue];
            
            NSArray *ary = CHECK_ARRAY_VALUE([data objectForKey:@"threadlist"]);
            
            if (ary.count>0) {
                //如果是第一页，清空数组
                if (self.page == 1) {
                    [self.circleArray removeAllObjects];
                    self.footview.hidden=NO;
                }
                
                for (NSDictionary *dic in ary) {
                    MyPostModel *model = [MyPostModel parseDicToMyPostObject:dic];
                    
                    [self.circleArray addObject:model];
                }
                
                if(self.page == 1&&[self.circleArray count]>0){
                    
                    //tableview返回第一行
                    self.circleTableView.contentSize = CGSizeMake(SCREEN_SIZE.width, 0);
                    
                }
                //当前数据小于总数据的时候页数++
                if (self.circleArray.count < self.totalRowNum) {
                    self.page++;
                }
                else{
                    self.footview.hidden=YES;
                }
                
            }
            [self.circleTableView reloadData];
            
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
    
    return self.circleArray.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    MyCircleListCell *cell =[tableView dequeueReusableCellWithIdentifier:[MyCircleListCell cellIdentifier]];
    if (cell ==nil) {
        cell = (MyCircleListCell *)[[[NSBundle mainBundle] loadNibNamed:@"MyCircleListCell" owner:self options:nil] lastObject];
        
    }
    
    MyPostModel *model = [self.circleArray objectAtIndex:indexPath.row];
    
    cell.fidLabel.text = model.fid_name;
    cell.postLabel.text = model.subject;
    cell.timeLabel.text = model.lastpost;

    [cell.replyButton setTitle:model.replies forState:UIControlStateNormal];
    
    if (!isChooseEdit) {

        [cell.postDeleteImageView setHidden:YES];
        
        [UIView animateWithDuration:0.2f animations:^{
            [cell.fidLabel setFrame:CGRectMake(50, cell.fidLabel.frame.origin.y, cell.fidLabel.frame.size.width, cell.fidLabel.frame.size.height)];
            [cell.fidImageView setFrame:CGRectMake(30, cell.fidImageView.frame.origin.y, cell.fidImageView.frame.size.width, cell.fidImageView.frame.size.height)];
            [cell.postLabel setFrame:CGRectMake(30, cell.postLabel.frame.origin.y, cell.postLabel.frame.size.width, cell.postLabel.frame.size.height)];
        }];
    }
    else{
        [cell.postDeleteImageView setHidden:NO];
        
        [UIView animateWithDuration:0.2f animations:^{
            [cell.fidLabel setFrame:CGRectMake(79, cell.fidLabel.frame.origin.y, cell.fidLabel.frame.size.width, cell.fidLabel.frame.size.height)];
            [cell.fidImageView setFrame:CGRectMake(59, cell.fidImageView.frame.origin.y, cell.fidImageView.frame.size.width, cell.fidImageView.frame.size.height)];
            [cell.postLabel setFrame:CGRectMake(59, cell.postLabel.frame.origin.y, cell.postLabel.frame.size.width, cell.postLabel.frame.size.height)];
        }];
        
    }


    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (!isChooseEdit) {
        MyPostModel *model = [self.circleArray objectAtIndex:indexPath.row];
        
        PostDetailVC *vc = [[PostDetailVC alloc]initWithNibName:@"PostDetailVC" bundle:nil];
        
        vc.currentTid = model.tid;
        vc.isFromMyCircle = YES;
        
        [self.navigationController pushViewController:vc animated:YES];
    }
    else{
        
        MyPostModel *model = [self.circleArray objectAtIndex:indexPath.row];

        [self deleteThePostAction:model];

    
    }

    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSArray *nibArr = [[NSBundle mainBundle] loadNibNamed:@"MyCircleListCell" owner:self options:nil];
    MyCircleListCell *cell = [nibArr objectAtIndex:0];
    return cell.frame.size.height;
    
}

#pragma mark - 按钮事件
- (IBAction)changeBtnModelAction:(id)sender
{
    for (UIButton *button in _titeBtnArray) {
        button.selected = NO;
    }
    UIButton *btn = (UIButton *)sender;
    btn.selected = YES;
    
    switch (btn.tag) {
        case 100:{
            //我发表的
            self.circleType = circleType_myPost;
        }
            break;
            
        case 101:{
            //我回复的
            self.circleType = circleType_myReturn;
        }
            break;

        default:
            break;
    }
    
    self.page = 1;
    [self getThePostData];
    
}

- (IBAction)editTheListAction:(id)sender
{
    if (!isChooseEdit) {
        [_editBtn setTitle:@"取消" forState:UIControlStateNormal];

        [self.footview setHidden:YES];
        [self.refreshHeaderView setHidden:YES];
        self.tableView = nil;
        [self.myPostBtn setUserInteractionEnabled:NO];
        [self.myReturnBtn setUserInteractionEnabled:NO];
    }
    else{
        [_editBtn setTitle:@"编辑" forState:UIControlStateNormal];
     
        [self.footview setHidden:NO];
        [self.refreshHeaderView setHidden:NO];
        self.tableView = self.circleTableView;
        [self.myPostBtn setUserInteractionEnabled:YES];
        [self.myReturnBtn setUserInteractionEnabled:YES];
    }
    isChooseEdit = !isChooseEdit;
    
    [self.circleTableView reloadData];
    
}

- (void)deleteThePostAction:(MyPostModel *)model
{
    if (self.circleType == circleType_myPost) {
        //删除帖子
        NSArray *array = [NSArray arrayWithObject:model.tid];
        
        [self.params removeAllObjects];
        [self.params setObject:CHECK_VALUE(model.fid) forKey:@"fid"];
        [self.params setObject:CHECK_VALUE([array JSONString]) forKey:@"moderate"];
        
        NSString *path = [NSString stringWithFormat:@"/api/dz/index.php?mod=topicadmin&action=moderate&modsubmit=yes&infloat=yes&inajax=1&duid=%@",USERINFO.uid];
        
        [NETWORK_ENGINE requestWithPath:path Params:self.params CompletionHandler:^(MKNetworkOperation *completedOperation) {
            
            NSDictionary *dic=[completedOperation responseDecodeToDic];
            
            NSDictionary *statusDic = [dic objectForKey:@"status"];
            
            if ([@"1" isEqualToString:CHECK_VALUE([statusDic objectForKey:@"statu"])]) {
                
                
                [SVProgressHUD showSuccessWithStatus:@"已删除"];
                
                [self.circleArray removeObject:model];
                
                self.totalRowNum--;
                
                [self.circleTableView reloadData];
                
                
            }
            else{
                
                [SVProgressHUD showErrorWithStatus:CHECK_VALUE([statusDic objectForKey:@"msg"])];
            }
            
            
        } ErrorHandler:^(MKNetworkOperation *completedOperation, NSError *error) {
            
            [SVProgressHUD showErrorWithStatus:@"服务器忙，请稍候再试"];
            
        }];
    }
    else{
        //删除回复
        [self.params removeAllObjects];
        [self.params setObject:CHECK_VALUE(model.fid) forKey:@"fid"];
        [self.params setObject:CHECK_VALUE(model.tid) forKey:@"tid"];
        [self.params setObject:CHECK_VALUE(model.thread_pids) forKey:@"topiclist"];
        
        NSString *path = [NSString stringWithFormat:@"/api/dz/index.php?mod=topicadmin&action=delpost&modsubmit=yes&infloat=yes&modclick=yes&inajax=1&duid=%@",USERINFO.uid];
        
        [NETWORK_ENGINE requestWithPath:path Params:self.params CompletionHandler:^(MKNetworkOperation *completedOperation) {
            
            NSDictionary *dic=[completedOperation responseDecodeToDic];
            
            NSDictionary *statusDic = [dic objectForKey:@"status"];
            
            if ([@"1" isEqualToString:CHECK_VALUE([statusDic objectForKey:@"statu"])]) {
                
                
                [SVProgressHUD showSuccessWithStatus:@"已删除"];
                
                [self.circleArray removeObject:model];
                
                [self.circleTableView reloadData];
                
            
            }
            else{
                
                [SVProgressHUD showErrorWithStatus:CHECK_VALUE([statusDic objectForKey:@"msg"])];
            }
            
            
        } ErrorHandler:^(MKNetworkOperation *completedOperation, NSError *error) {
            
            [SVProgressHUD showErrorWithStatus:@"服务器忙，请稍候再试"];
            
        }];
    }
    
    
}

#pragma mark - 分页加载
//上拉分页加载
- (void)refreshViewBeginRefreshing:(MJRefreshBaseView *)refreshView
{
    if (refreshView == self.footview){
        [self getThePostData];
    }
}

#pragma mark - 下拉刷新
- (void)reloadTableViewDataSource
{
    if (self.isLoading) { return;}
    self.page = 1;
    [self getThePostData];
    [super reloadTableViewDataSource];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
