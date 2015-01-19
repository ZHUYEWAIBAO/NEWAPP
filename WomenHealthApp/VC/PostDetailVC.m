//
//  PostDetailVC.m
//  WomenHealthApp
//
//  Created by 朱青 on 15/1/14.
//  Copyright (c) 2015年 WomenHealthApp. All rights reserved.
//

#import "PostDetailVC.h"
#import "PostDetailCell.h"
#import "PostDetailModel.h"
#import "BbsCircleDetailVC.h"
#import "ImageScrollVC.h"

@interface PostDetailVC ()

@property (strong, nonatomic) PostDetailModel *detailModel;

@end

@implementation PostDetailVC

- (void)loadView
{
    [super loadView];
    
    self.title = @"帖子详情";
    
    //允许下拉刷新
    self.tableView = self.postTableView;
    
    //允许上拉分页加载
    self.isNeedLoadMore=YES;
    self.page = 1;

}

- (void)viewDidLoad {
    [super viewDidLoad];

    _postListArray = [[NSMutableArray alloc]init];
    
    [self getThePostDetailWithTid:self.currentTid];
    
}

- (void)getThePostDetailWithTid:(NSString *)tid
{
    if (self.page == 1) {
        [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];
    }
    
    NSString *path = [NSString stringWithFormat:@"/api/dz/index.php?mod=viewthread&tid=%@&page=%ld",self.currentTid,self.page];
    
    [NETWORK_ENGINE requestWithPath:path Params:self.params CompletionHandler:^(MKNetworkOperation *completedOperation) {
        
        NSDictionary *dic=[completedOperation responseDecodeToDic];
        
        NSDictionary *statusDic = [dic objectForKey:@"status"];
        
        if ([@"1" isEqualToString:CHECK_VALUE([statusDic objectForKey:@"statu"])]) {
            
            NSDictionary *data = [dic objectForKey:@"data"];
            
            PostDetailModel *detailModel = [PostDetailModel parseDicToPostDetailObject:data];
            self.detailModel = detailModel;
            
            [self layOutTheHeadView];
            
            self.totalRowNum = [CHECK_VALUE([data objectForKey:@"total_subject"]) integerValue];
            
            NSArray *ary = CHECK_ARRAY_VALUE([data objectForKey:@"view_threadlist"]);
            
            if (ary.count>0) {
                //如果是第一页，清空数组
                if (self.page == 1) {
                    [self.postListArray removeAllObjects];
                    self.footview.hidden=NO;
                }
                
                for (NSDictionary *dic in ary) {
                    PostListModel *model = [PostListModel parseDicToPostListObject:dic];
                    
                    [self.postListArray addObject:model];
                }
                
                if(self.page == 1&&[self.postListArray count]>0){
                    
                    //tableview返回第一行
                    self.postTableView.contentSize = CGSizeMake(SCREEN_SIZE.width, 0);
                    
                }
                //当前数据小于总数据的时候页数++
                if (self.postListArray.count < self.totalRowNum) {
                    self.page++;
                }
                else{
                    self.footview.hidden=YES;
                }
                
            }
            [self.postTableView reloadData];
            
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

- (void)layOutTheHeadView
{
    if ([@"1" isEqualToString:self.detailModel.digest]) {
        [self.jingImageView setHidden:NO];
    }
    self.nameLabel.text = self.detailModel.subject;
    self.totalLabel.text = self.detailModel.total_subject;
    self.circleLabel.text = self.detailModel.fid_name;
    
    CGRect rect1 =  self.nameLabel.frame;
    rect1.size.height = HeightForString(self.detailModel.subject, 14.0, 260) + 10;
    self.nameLabel.frame = rect1;
    
    CGRect rect2 =  self.topView.frame;
    rect2.size.height = rect1.size.height + 3;
    self.topView.frame = rect2;
    
    CGRect rect3 =  self.bottomView.frame;
    rect3.origin.y = rect2.size.height;
    self.bottomView.frame = rect3;
    
    CGRect rect5 =  self.lineImageView.frame;
    rect5.origin.y = rect3.size.height + rect3.origin.y;
    self.lineImageView.frame = rect5;
    
    CGRect rect4 =  self.headView.frame;
    rect4.size.height = rect5.size.height + rect5.origin.y;
    self.headView.frame = rect4;
    
    self.postTableView.tableHeaderView = self.headView;
}

- (IBAction)circleClickAction:(id)sender
{
    if (self.isFromMyCircle) {
        
        BbsCircleDetailVC *vc = [[BbsCircleDetailVC alloc]initWithNibName:@"BbsCircleDetailVC" bundle:nil];
        vc.currentFid = self.detailModel.fid;
        [self.navigationController pushViewController:vc animated:YES];
    }
    else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark tableview
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.postListArray.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    PostDetailCell *cell =[tableView dequeueReusableCellWithIdentifier:[PostDetailCell cellIdentifier]];
    if (cell ==nil) {
        cell = (PostDetailCell *)[[[NSBundle mainBundle] loadNibNamed:@"PostDetailCell" owner:self options:nil] objectAtIndex:0];
        
    }
    
    PostListModel *model = [self.postListArray objectAtIndex:indexPath.row];
    
    [cell.headImageView setImageWithURL:[NSURL URLWithString:model.avatar] placeholderImage:[UIImage imageWithContentFileName:@"Set_people_head_image.png"]];
    
    cell.authorLabel.text = model.author;
    cell.timeLabel.text = model.dateline;
    cell.postLabel.text = model.message;
    
    if ([@"1" isEqualToString:model.louzhu]) {
        cell.louZhuLabel.text = @"楼主";
    }
    else{
        cell.louZhuLabel.text = [NSString stringWithFormat:@"%@楼",model.position];
    }

    for (NSInteger i = 0; i < model.imgInfosArray.count; i++) {
        
        UIButton *button = [cell valueForKey:[NSString stringWithFormat:@"photoButton%ld",i ]];
        [button setImageWithURL:[model.imgInfosArray objectAtIndex:i] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(imageClickAction:) forControlEvents:UIControlEventTouchUpInside];
        [button setTag:indexPath.row * 100 +i];
        [button setHidden:NO];
    }
    
    CGRect rect1 = cell.authorLabel.frame;
    rect1.size.width = WidthForString(model.author, 14.0, 30);
    
    if (rect1.size.width >= 210) {
        rect1.size.width = 210;
    }
    cell.authorLabel.frame = rect1;
    
    if ([@"1" isEqualToString:model.louzhu]) {
        
        [cell.louZhuImageView setHidden:NO];
        
        CGRect rect2 = cell.louZhuImageView.frame;
        rect2.origin.x = rect1.size.width + rect1.origin.x + 5;
        cell.louZhuImageView.frame = rect2;
    }
    
    CGRect rect3 = cell.postLabel.frame;
    rect3.size.height = HeightForString(model.message, 14.0, 200);
    cell.postLabel.frame = rect3;

    CGRect rect4 = cell.postView.frame;
    rect4.size.height = rect3.size.height + 5;
    cell.postView.frame = rect4;

    
    if (model.imgInfosArray.count > 0) {
        CGRect rect5 = cell.buttonView.frame;
        rect5.origin.y = rect4.size.height + rect4.origin.y;
        cell.buttonView.frame = rect5;
        
        CGRect rect6 = cell.bigView.frame;
        rect6.size.height = rect5.size.height + rect5.origin.y;
        cell.bigView.frame = rect6;
    }
    else{
        [cell.buttonView setHidden:YES];
        
        CGRect rect6 = cell.bigView.frame;
        rect6.size.height = rect4.size.height + rect4.origin.y;
        cell.bigView.frame = rect6;
    }

 
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    PostListModel *model = [self.postListArray objectAtIndex:indexPath.row];
    
    if (model.imgInfosArray.count == 0) {
        return HeightForString(model.message, 14.0, 200) + 60 + 5 + 10;
    }
    
    return HeightForString(model.message, 14.0, 200) + 85 + 60 + 5 + 10;
    
}

- (void)imageClickAction:(id)sender
{
    UIButton *button = (UIButton *)sender;
    
    PostListModel *model = [self.postListArray objectAtIndex:button.tag/100];
    
    ImageScrollVC *vc = [[ImageScrollVC alloc]initWithNibName:@"ImageScrollVC" bundle:nil];
    vc.imagesArray = [NSMutableArray arrayWithArray:model.imgInfosArray];
    vc.selectIndex = button.tag%100;
    vc.isFromPostDetail = YES;
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
