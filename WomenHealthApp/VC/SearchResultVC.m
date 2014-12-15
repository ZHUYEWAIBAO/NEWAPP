//
//  SearchResultVC.m
//  WomenHealthApp
//
//  Created by 朱青 on 14/12/4.
//  Copyright (c) 2014年 WomenHealthApp. All rights reserved.
//

#import "SearchResultVC.h"
#import "GoodsListModel.h"
#import "B2CShoppingListCell.h"
#import "ShoppingDetailVC.h"
#import "CategoryViewController.h"

@interface SearchResultVC ()
{
    NSString *currentCategoryId;
    NSString *currentOrdergoryId;
    NSString *currentSortId;
    NSString *currentMin_price;
    NSString *currentMax_price;
    NSString *is_shipping;
    
    IBOutlet UIButton *zongheButton;
    IBOutlet UIButton *saleButton;
    IBOutlet UIButton *priceButton;
    
    NSMutableArray *sortBtnArray;
    
    BOOL isPriceUp;//降序还是升序
}
@end

@implementation SearchResultVC

- (void)loadView
{
    [super loadView];
    
    self.title = self.currentKeyWords;
    
    //允许下拉刷新
    self.tableView = self.searchTableView;
    
    //允许上拉分页加载
    self.isNeedLoadMore=YES;
    self.page = 1;
    
    currentSortId = @"is_best";
    currentMin_price = @"0";
    currentMax_price = @"0";
    currentCategoryId = @"";
    currentOrdergoryId = @"";
}

- (void)viewDidLoad {
    [super viewDidLoad];

    _shopArray = [[NSMutableArray alloc]initWithCapacity:5];
    sortBtnArray = [[NSMutableArray alloc]initWithObjects:zongheButton,saleButton,priceButton, nil];

    [self getTheListData];
    
}

#pragma mark - 获取商品数据
- (void)getTheListData
{
    if (self.page == 1) {
        [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];
    }

    NSString *path = [NSString stringWithFormat:@"/api/ec/search.php?keywords=%@&category=%@&sort=%@&order=%@&min_price=%@&max_price=%@&page=%ld",self.currentKeyWords,currentCategoryId,currentSortId,currentOrdergoryId,currentMin_price,currentMax_price,self.page];
    NSString *enStr =  [path stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];

    [NETWORK_ENGINE requestWithPath:enStr Params:nil CompletionHandler:^(MKNetworkOperation *completedOperation) {
        
        NSDictionary *dic=[completedOperation responseDecodeToDic];
        
        NSDictionary *statusDic = [dic objectForKey:@"status"];
        
        if ([@"1" isEqualToString:CHECK_VALUE([statusDic objectForKey:@"statu"])]) {
            
            NSDictionary *data = [dic objectForKey:@"data"];
            
            self.totalRowNum = [CHECK_VALUE([data objectForKey:@"total_recode"]) integerValue];
            
            if (self.totalRowNum == 0) {
                [self showSearchEmpty];
                self.footview.hidden=YES;
            }
            
            NSArray *ary = CHECK_ARRAY_VALUE([data objectForKey:@"list"]);
            
            if (ary.count>0) {
                //如果是第一页，清空数组
                if (self.page == 1) {
                    [self.shopArray removeAllObjects];
                    self.footview.hidden=NO;
                }
                
                for (NSDictionary *dic in ary) {
                    GoodsListModel *model = [GoodsListModel parseDicToB2CGoodModelObject:dic];
                    
                    [self.shopArray addObject:model];
                }
                
                if(self.page == 1&&[self.shopArray count]>0){
                    
                    //tableview返回第一行
                    self.searchTableView.contentSize = CGSizeMake(320, 0);
                    
                }
                //当前数据小于总数据的时候页数++
                if (self.shopArray.count < self.totalRowNum) {
                    self.page++;
                }
                else{
                    self.footview.hidden=YES;
                }
                
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

#pragma mark UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return ceil(self.shopArray.count/2.0);
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *nibArr = [[NSBundle mainBundle] loadNibNamed:@"B2CShoppingListCell" owner:self options:nil];
    B2CShoppingListCell *cell = [nibArr objectAtIndex:0];
    
    return cell.frame.size.height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    B2CShoppingListCell *cell = [tableView dequeueReusableCellWithIdentifier:[B2CShoppingListCell cellIdentifier]];
    if (cell == nil){
        
        NSArray *nibArr = [[NSBundle mainBundle] loadNibNamed:@"B2CShoppingListCell" owner:self options:nil];
        cell = [nibArr objectAtIndex:0];
        
    }
    
    [cell setItemWithArray:self.shopArray row:indexPath.row target:self detailAction:@selector(tableViewBtnAction:)];
    
    
    return cell;
    
    
}

//点击商品触发push详情页
-(void)tableViewBtnAction:(id)sender
{
    B2CGoodsButton *btn = (B2CGoodsButton *)sender;
    
    ShoppingDetailVC *vc = [[ShoppingDetailVC alloc]initWithNibName:@"ShoppingDetailVC" bundle:nil];
    
    vc.goodsId = btn.model.goods_id;
    
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - 分页加载
//上拉分页加载
- (void)refreshViewBeginRefreshing:(MJRefreshBaseView *)refreshView
{
    if (refreshView == self.footview){
        [self getTheListData];
    }
}

#pragma mark - 下拉刷新
- (void)reloadTableViewDataSource
{
    if (self.isLoading) { return;}
    self.page = 1;
    [self getTheListData];
    [super reloadTableViewDataSource];
}

#pragma mark - 按钮事件
- (IBAction)categoryClickAction:(id)sender
{
    //筛选
    CategoryViewController *vc = [[CategoryViewController alloc]initWithNibName:@"CategoryViewController" bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)btnClickAction:(id)sender
{
    for (UIButton *btn in sortBtnArray) {
        [btn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        
    }
    [self.priceSortLogoImageView setImage:[UIImage imageWithContentFileName:@"price_logo"]];
    
    UIButton *button = (UIButton *)sender;
    [button setTitleColor:MAIN_RED_COLOR forState:UIControlStateNormal];
    
    switch (button.tag) {
        case 100:{
            //综合
            currentSortId = @"is_best";
            
            self.page = 1;
            [self getTheListData];
            
        }
            break;
            
        case 101:{
            //销量
            
            currentSortId = @"sales_number";
            
            self.page = 1;
            [self getTheListData];
        }
            break;
            
        case 102:{
            //价格
            currentSortId = @"shop_price";
            
            if (!isPriceUp) {
                currentOrdergoryId = @"ASC";
                isPriceUp = YES;
                [self.priceSortLogoImageView setImage:[UIImage imageWithContentFileName:@"price_up_logo"]];
            }
            else{
                currentOrdergoryId = @"DESC";
                isPriceUp = NO;
                [self.priceSortLogoImageView setImage:[UIImage imageWithContentFileName:@"price_down_logo"]];
            }
            
            self.page = 1;
            [self getTheListData];
        }
            break;
            
        default:
            break;
    }
    
}

- (void)showSearchEmpty
{
    [self.searchTableView setHidden:YES];
    [self.sortView setHidden:YES];
    [self.searchEmptyView setHidden:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
