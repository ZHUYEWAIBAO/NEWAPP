//
//  BbsSearchResultVC.m
//  WomenHealthApp
//
//  Created by 朱青 on 15/1/8.
//  Copyright (c) 2015年 WomenHealthApp. All rights reserved.
//

#import "BbsSearchResultVC.h"
#import "BbsCircleDetailVC.h"
#import "BBSMenuModal.h"
#import "BbsFenLeiCell.h"
#import "LineImageView.h"

@interface BbsSearchResultVC ()

@end

@implementation BbsSearchResultVC

- (void)loadView
{
    [super loadView];
    
    self.title = self.currentKeyWords;
   

}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _circleArray = [[NSMutableArray alloc]initWithCapacity:5];

    [self getTheListData];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    self.view.backgroundColor = [UIColor whiteColor];
}

#pragma mark - 获取搜索数据
- (void)getTheListData
{

    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];
    
    NSString *path = [NSString stringWithFormat:@"/api/dz/search.php?mod=category&kw=%@",self.currentKeyWords];
    NSString *enStr =  [path stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    [NETWORK_ENGINE requestWithPath:enStr Params:self.params CompletionHandler:^(MKNetworkOperation *completedOperation) {
        
        NSDictionary *dic=[completedOperation responseDecodeToDic];
        
        NSDictionary *statusDic = [dic objectForKey:@"status"];
        
        if ([@"1" isEqualToString:CHECK_VALUE([statusDic objectForKey:@"statu"])]) {
            
            NSDictionary *data = [dic objectForKey:@"data"];
  
            NSArray *ary = CHECK_ARRAY_VALUE([data objectForKey:@"data"]);
            
            if (ary.count>0) {
                
                for (NSDictionary *subDic in ary) {
                    BBSMenuModal *modal = [BBSMenuModal parseDicToMenuListObject:subDic];
                    [self.circleArray addObject:modal];
                }
 
            }
            else{
                [self showSearchEmpty];
            }
            
            [self.searchTableView reloadData];
            
            [SVProgressHUD dismiss];
  
        }
        else{
            [SVProgressHUD showErrorWithStatus:CHECK_VALUE([statusDic objectForKey:@"msg"])];
        }
        
    } ErrorHandler:^(MKNetworkOperation *completedOperation, NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"服务器忙，请稍候再试"];

    }];
    
}

#pragma mark UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return self.circleArray.count;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *nibArr = [[NSBundle mainBundle] loadNibNamed:@"BbsFenLeiCell" owner:self options:nil];
    BbsFenLeiCell *cell = [nibArr objectAtIndex:0];
    
    return cell.frame.size.height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    BbsFenLeiCell *cell = [tableView dequeueReusableCellWithIdentifier:[BbsFenLeiCell cellIdentifier]];
    if (cell == nil){
        
        NSArray *nibArr = [[NSBundle mainBundle] loadNibNamed:@"BbsFenLeiCell" owner:self options:nil];
        cell = [nibArr objectAtIndex:0];
        
        LineImageView *lineImgV=[[LineImageView alloc]initWithFrame:CGRectMake(15, cell.frame.size.height-1, cell.frame.size.width - 15, 0.5)];
        [cell.contentView addSubview:lineImgV];
        
    }

    BBSMenuModal *modal = [self.circleArray objectAtIndex:indexPath.row];
    
    cell.bbsTitleLabel.text = modal.bbsName;
    cell.bbsSubLabel.text = modal.bbsDescription;
    
    [cell.bbsimageView setImageWithURL:[NSURL URLWithString:modal.bbsIcon] placeholderImage:[UIImage imageWithContentFileName:@"Circle_menu_default_image.png"]];
 
    return cell;
    
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    BbsCircleDetailVC *vc = [[BbsCircleDetailVC alloc]initWithNibName:@"BbsCircleDetailVC" bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
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
