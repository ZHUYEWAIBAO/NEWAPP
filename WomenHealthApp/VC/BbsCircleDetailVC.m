//
//  BbsCircleDetailVC.m
//  WomenHealthApp
//
//  Created by 朱青 on 15/1/8.
//  Copyright (c) 2015年 WomenHealthApp. All rights reserved.
//

#import "BbsCircleDetailVC.h"
#import "BbsCircleCell.h"
#import "CircleListModel.h"
#import "WritePostVC.h"
#import "BbsCircleHeadView.h"
#import "PostDetailVC.h"
#import "BbsSearchVC.h"

@interface BbsCircleDetailVC ()

@property (strong, nonatomic) CircleHeadModel *headModel;

@end

@implementation BbsCircleDetailVC

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
    _circleArray3 = [[NSMutableArray alloc]init];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    UIButton *signBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    signBtn.frame = CGRectMake(0,0,30,30);
    [signBtn setImage:[UIImage imageWithContentFileName:@"publish_btn"] forState:UIControlStateNormal];
    [signBtn addTarget:self action:@selector(signClickAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:signBtn];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    //设置UIImageView显示为圆形
    self.headImageView.layer.cornerRadius = self.headImageView.frame.size.width / 2;
    self.headImageView.layer.masksToBounds = YES;
    
    self.circleType = circleType_all;
    [self getTheHeadDataWithFid:self.currentFid];
    
    _titeBtnArray = [[NSMutableArray alloc]initWithObjects:_allBtn,_bestBtn,_freshBtn, nil];
    _allBtn.selected = YES;
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

//request
- (void)getTheHeadDataWithFid:(NSString *)fid
{

    NSString *path = [NSString stringWithFormat:@"/api/dz/index.php?mod=forum_detail_count&fid=%@",self.currentFid];

    [NETWORK_ENGINE requestWithPath:path Params:self.params CompletionHandler:^(MKNetworkOperation *completedOperation) {
        
        NSDictionary *dic=[completedOperation responseDecodeToDic];
        
        NSDictionary *statusDic = [dic objectForKey:@"status"];
        
        if ([@"1" isEqualToString:CHECK_VALUE([statusDic objectForKey:@"statu"])]) {
            
            NSDictionary *data = [dic objectForKey:@"data"];
            
            CircleHeadModel *model = [CircleHeadModel parseDicToCircleHeadObject:data];
                    
            self.headModel = model;
            
            [self layOutTheHeadView];
            
            self.circleTableView.tableHeaderView = self.headView;
            
            [self getTheCirleWithFid:self.currentFid];

        }
        else{
            [SVProgressHUD showErrorWithStatus:CHECK_VALUE([statusDic objectForKey:@"msg"])];
        }
        
    } ErrorHandler:^(MKNetworkOperation *completedOperation, NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"服务器忙，请稍候再试"];
        [self showSearchEmpty];
    }];
    
}

- (void)getTheCirleWithFid:(NSString *)fid
{
    if (self.page == 1) {
        [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];
    }
    
    NSString *path = [NSString stringWithFormat:@"/api/dz/index.php?mod=forum_detail&fid=%@&page=%ld",self.currentFid,self.page];
  
    switch (self.circleType) {
        case circleType_all:{
            path = path;
        }
            break;
        
        case circleType_best:{
            path = [path stringByAppendingString:@"&filter=digest&digest=1"];
        }
            break;
            
        case circleType_fresh:{
            path = [path stringByAppendingString:@"&filter=lastpost&orderby=lastpost"];
        }
            break;
            
        default:
            break;
    }
    
    [NETWORK_ENGINE requestWithPath:path Params:self.params CompletionHandler:^(MKNetworkOperation *completedOperation) {
        
        NSDictionary *dic=[completedOperation responseDecodeToDic];
        
        NSDictionary *statusDic = [dic objectForKey:@"status"];
        
        if ([@"1" isEqualToString:CHECK_VALUE([statusDic objectForKey:@"statu"])]) {
            
            NSDictionary *data = [dic objectForKey:@"data"];
            
            self.totalRowNum = [CHECK_VALUE([data objectForKey:@"total_subject"]) integerValue];
     
            NSArray *ary = CHECK_ARRAY_VALUE([data objectForKey:@"forum_threadlist"]);
            
            if (ary.count>0) {
                //如果是第一页，清空数组
                if (self.page == 1) {
                    [self.circleArray removeAllObjects];
                    self.footview.hidden=NO;
                }
                
                for (NSDictionary *dic in ary) {
                    CircleListModel *model = [CircleListModel parseDicToCircleListObject:dic];
                    
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

- (void)showSearchEmpty
{
    [self.circleTableView setHidden:YES];
    [self.searchEmptyView setHidden:NO];
}

- (void)layOutTheHeadView
{
    self.nameLabel.text = self.headModel.name;
    self.nameDesLabel.text = self.headModel.circle_description;
    self.todayLabel.text = self.headModel.today_subject;
    self.totalLabel.text = self.headModel.total_subject;
    
    [self.headImageView setImageWithURL:[NSURL URLWithString:self.headModel.icon] placeholderImage:[UIImage imageWithContentFileName:@"Circle_menu_default_image.png"]];
    
    CGRect rect1 = self.hotView.frame;
    rect1.size.height = 40 * self.headModel.headArray.count;
    self.hotView.frame = rect1;
    
    CGRect rect2 = self.headView.frame;
    rect2.size.height = rect1.size.height + rect1.origin.y;
    self.headView.frame = rect2;
    
    for (NSInteger i = 0; i < self.headModel.headArray.count; i++) {
        
        BbsCircleHeadView *view = (BbsCircleHeadView *)[[[NSBundle mainBundle]loadNibNamed:@"BbsCircleHeadView" owner:self options:nil]lastObject];
        [view setFrame:CGRectMake(0, view.frame.size.height * i, view.frame.size.width, view.frame.size.height)];
        
        CircleListModel *model = [self.headModel.headArray objectAtIndex:i];
        view.headNameLabel.text = model.subject;
        
        view.headBtn.tag = 100+i;
        [view.headBtn addTarget:self action:@selector(headBtnClickAction:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.hotView addSubview:view];
        
        
    }
    
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

    BbsCircleCell *cell =[tableView dequeueReusableCellWithIdentifier:[BbsCircleCell cellIdentifier]];
    if (cell ==nil) {
        cell = (BbsCircleCell *)[[[NSBundle mainBundle] loadNibNamed:@"BbsCircleCell" owner:self options:nil] lastObject];
 
    }
    
    CircleListModel *model = [self.circleArray objectAtIndex:indexPath.row];
    
    cell.authorLabel.text = model.author;
    cell.postLabel.text = model.subject;
    cell.timeLabel.text = [NSString stringWithFormat:@"最后回复:%@",model.lastpost];
    
    [cell.numButton setTitle:model.replies forState:UIControlStateNormal];
    
    if ([@"1" isEqualToString:model.digest]) {
        [cell.hotImageView setHidden:NO];
    }
    else{
        [cell.hotImageView setHidden:YES];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CircleListModel *model = [self.circleArray objectAtIndex:indexPath.row];
    
    PostDetailVC *vc = [[PostDetailVC alloc]initWithNibName:@"PostDetailVC" bundle:nil];
    
    vc.currentTid = model.tid;
    
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSArray *nibArr = [[NSBundle mainBundle] loadNibNamed:@"BbsCircleCell" owner:self options:nil];
    BbsCircleCell *cell = [nibArr objectAtIndex:0];
    return cell.frame.size.height;
    
}

#pragma mark - 按钮事件
- (IBAction)searchPostAction:(id)sender
{
    BbsSearchVC *vc = [[BbsSearchVC alloc]initWithNibName:@"BbsSearchVC" bundle:nil];
    vc.isFromPost = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)signClickAction:(id)sender
{
    WritePostVC *vc = [[WritePostVC alloc]initWithNibName:@"WritePostVC" bundle:nil];
    vc.currentFid = self.currentFid;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)headBtnClickAction:(id)sender
{
    UIButton *button = (UIButton *)sender;
    CircleListModel *model = [self.headModel.headArray objectAtIndex:button.tag%100];
    
    PostDetailVC *vc = [[PostDetailVC alloc]initWithNibName:@"PostDetailVC" bundle:nil];
    
    vc.currentTid = model.tid;
    
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)changeBtnModelAction:(id)sender
{
    for (UIButton *button in _titeBtnArray) {
        button.selected = NO;
    }
    UIButton *btn = (UIButton *)sender;
    btn.selected = YES;
    
    switch (btn.tag) {
        case 100:{
            //全部
            self.circleType = circleType_all;
        }
            break;
            
        case 101:{
            //新鲜
            self.circleType = circleType_fresh;
        }
            break;
            
        case 102:{
            //精华
            self.circleType = circleType_best;
        }
            break;
            
        default:
            break;
    }
    
    self.page = 1;
    [self getTheCirleWithFid:self.currentFid];
    
}

#pragma mark - 分页加载
//上拉分页加载
- (void)refreshViewBeginRefreshing:(MJRefreshBaseView *)refreshView
{
    if (refreshView == self.footview){
        [self getTheCirleWithFid:self.currentFid];
    }
}

#pragma mark - 下拉刷新
- (void)reloadTableViewDataSource
{
    if (self.isLoading) { return;}
    self.page = 1;
    [self getTheCirleWithFid:self.currentFid];
    [super reloadTableViewDataSource];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
