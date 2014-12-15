//
//  ShoppingViewController.m
//  WomenHealthApp
//
//  Created by 朱 青 on 14-10-23.
//  Copyright (c) 2014年 WomenHealthApp. All rights reserved.
//

#import "ShoppingViewController.h"
#import "B2CShoppingListCell.h"
#import "GoodsListModel.h"
#import "CalculateHigh.h"
#import "BannerImageView.h"
#import "ShoppingDetailVC.h"
#import "CategoryViewController.h"
#import "SearchResultVC.h"
#import "SearchGoodsVC.h"
#import "AdModal.h"

#define keyBtnInSetx 5
#define keyBtnInSety 0
#define buttonWidth  50
#define buttonHeight 40

@interface ShoppingViewController ()
{
    NSMutableArray *adArray;
    NSMutableArray *keyBtnArray;
    
    NSString *currentKeyWords;
    NSString *currentCategoryId;
    NSString *currentOrdergoryId;
    NSString *currentSortId;
    NSString *currentMin_price;
    NSString *currentMax_price;
    NSString *is_shipping;
    NSString *is_best;
    NSString *is_hot;
    NSString *is_new;
    
    IBOutlet UIButton *zongheButton;
    IBOutlet UIButton *saleButton;
    IBOutlet UIButton *priceButton;
    
    NSMutableArray *sortBtnArray;
    
    BOOL isPriceUp;//降序还是升序
    
    UIView *noneView;
}

@end

@implementation ShoppingViewController

+ (UINavigationController *)navigationControllerContainSelf
{
    ShoppingViewController *vc = [[ShoppingViewController alloc] initWithNibName:@"ShoppingViewController" bundle:nil];
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:vc];
    return nav;
}

- (void)loadView
{
    [super loadView];
    
    self.title = @"购物";
    
    //允许下拉刷新
    self.tableView = self.shopTableView;
    
    //允许上拉分页加载
    self.isNeedLoadMore=YES;
    self.page = 1;
    
    currentSortId = @"is_best";
    currentMin_price = @"0";
    currentMax_price = @"0";
    currentKeyWords = @"";
    currentCategoryId = @"";
    currentOrdergoryId = @"";
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cateSelectAction:) name:NOTIFICATION_SHOP_SELECT object:nil];
    
    //将自定义的视图作为导航条leftBarButtonItem
    UIButton *searchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    searchBtn.frame = CGRectMake(0,0,30,30);
    [searchBtn setImage:[UIImage imageWithContentFileName:@"search_btn"] forState:UIControlStateNormal];
    [searchBtn setImage:[UIImage imageWithContentFileName:@"serarch_btn_selected"] forState:UIControlStateHighlighted];
    [searchBtn addTarget:self action:@selector(searchClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:searchBtn];
    self.navigationItem.rightBarButtonItem = leftItem;
    
    adArray = [[NSMutableArray alloc]initWithCapacity:5];
    keyBtnArray = [[NSMutableArray alloc]initWithCapacity:5];
    _shopArray = [[NSMutableArray alloc]initWithCapacity:5];
    sortBtnArray = [[NSMutableArray alloc]initWithObjects:zongheButton,saleButton,priceButton, nil];
    
    [self getTheBannerData];
    [self getTheHotKey];
    [self getTheListData];
}

- (void)cateSelectAction:(NSNotification *)notification
{
    if (notification.userInfo) {
        currentCategoryId = [notification.userInfo objectForKey:@"cid"];
        currentMin_price = [notification.userInfo objectForKey:@"minPrice"];
        currentMax_price = [notification.userInfo objectForKey:@"maxPrice"];
        
        is_shipping = [notification.userInfo objectForKey:@"is_shipping"];
        is_best = [notification.userInfo objectForKey:@"is_best"];
        is_hot = [notification.userInfo objectForKey:@"is_hot"];
        is_new = [notification.userInfo objectForKey:@"is_new"];

        self.page = 1;
        [self getTheListData];
    }
}

#pragma mark - 获取广告
- (void)getTheBannerData
{
    //设置请求参数
    [self.params removeAllObjects];

    [NETWORK_ENGINE requestWithPath:@"/api/ec/?mod=ad" Params:self.params CompletionHandler:^(MKNetworkOperation *completedOperation) {
        
        NSDictionary *dic=[completedOperation responseDecodeToDic];
        
        NSDictionary *statusDic = [dic objectForKey:@"status"];
  
        if ([@"1" isEqualToString:CHECK_VALUE([statusDic objectForKey:@"statu"])]) {
            
            NSDictionary *data = [dic objectForKey:@"data"];
            
            for (NSDictionary *subDictionery in [data objectForKey:@"list"]) {
                AdModal *modal = [AdModal parseDicToADObject:subDictionery];
                [adArray addObject:modal];
            }
            
            [self layOutTheBannerImage:adArray];
            [SVProgressHUD dismiss];
            
        }
        else{
            [SVProgressHUD showErrorWithStatus:CHECK_VALUE([statusDic objectForKey:@"msg"])];
        }
        
    } ErrorHandler:^(MKNetworkOperation *completedOperation, NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"服务器忙，请稍候再试"];
    }];

}

- (void)layOutTheBannerImage:(NSMutableArray *)array
{
    
    NSMutableArray *viewsArray = [@[] mutableCopy];

    for (int i = 0; i < adArray.count; ++i) {
        
        AdModal *model = [adArray objectAtIndex:i];
        BannerImageView *imageView = [[BannerImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 120)];
   
        //下载图片
        UIActivityIndicatorView *myac=[[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [myac setFrame:CGRectMake(imageView.frame.size.width/2-10, imageView.frame.size.height/2-10, 20, 20)];
        [imageView addSubview:myac];
        
        __block UIActivityIndicatorView *amyac=myac;
        [amyac startAnimating];
        
        [imageView setImageWithURL:[NSURL URLWithString:model.adSrc] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
            
            if (image) {
                [amyac stopAnimating];
                [amyac removeFromSuperview];
                amyac=nil;
            }
        }];
        [viewsArray addObject:imageView];
    }
    
    self.mainScorllView = [[CycleScrollView alloc] initWithFrame:CGRectMake(0, 0, 320, 120) animationDuration:3];
    
    self.mainScorllView.fetchContentViewAtIndex = ^UIView *(NSInteger pageIndex){
        return viewsArray[pageIndex];
    };
    
    self.mainScorllView.totalPagesCount = ^NSInteger(void){
        return array.count;
    };
    
    __block ShoppingViewController *vc = self;
    self.mainScorllView.TapActionBlock = ^(NSInteger pageIndex){
        
        AdModal *modal = [array objectAtIndex:pageIndex];
 
        if ([@"url" isEqualToString:modal.adType]) {
            [vc action:modal.adType withJumpId:modal.adUrl];
        }
        else if ([@"goods" isEqualToString:modal.adType]) {
            [vc action:modal.adType withJumpId:modal.adGoods_id];
        }
    };
    [self.headView addSubview:self.mainScorllView];
    
    self.shopTableView.tableHeaderView = self.headView;
    
}

#pragma mark - 获取热搜词
- (void)getTheHotKey
{
    //设置请求参数
    [self.params removeAllObjects];
    
    [NETWORK_ENGINE requestWithPath:@"/api/ec/?mod=searchkeywords" Params:self.params CompletionHandler:^(MKNetworkOperation *completedOperation) {
        
        NSDictionary *dic=[completedOperation responseDecodeToDic];
        
        NSDictionary *statusDic = [dic objectForKey:@"status"];
        
        if ([@"1" isEqualToString:CHECK_VALUE([statusDic objectForKey:@"statu"])]) {
            
            NSDictionary *data = [dic objectForKey:@"data"];
            
            NSMutableArray *strArray = [[NSMutableArray alloc]init];
            
            for (NSString *str in [data objectForKey:@"list"]) {
               
                [strArray addObject:str];
            }
            
            [self layOutTheKeyWordsView:strArray];
         
        }
        else{
            [SVProgressHUD showErrorWithStatus:CHECK_VALUE([statusDic objectForKey:@"msg"])];
        }
        
    } ErrorHandler:^(MKNetworkOperation *completedOperation, NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"服务器忙，请稍候再试"];
    }];
    

}

- (void)layOutTheKeyWordsView:(NSArray *)keyWordsArray
{
    [keyWordsArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSString *word = (NSString *)obj;
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:word forState:UIControlStateNormal];
        [button.titleLabel setFont:[UIFont systemFontOfSize:14.0]];
        [button setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(keyWordsSearch:) forControlEvents:UIControlEventTouchUpInside];
        
        [keyBtnArray addObject:button];
        
        if (idx > 0) {
            
            UIButton *foreButton = [keyBtnArray objectAtIndex:idx - 1];
            [button setFrame:CGRectMake(keyBtnInSetx + foreButton.frame.origin.x + foreButton.frame.size.width, keyBtnInSety, buttonWidth, buttonHeight)];

        }
        else{
            [button setFrame:CGRectMake(keyBtnInSetx, keyBtnInSety, buttonWidth, buttonHeight)];
        }

        [self.hotKeyScrollView setContentSize:CGSizeMake(button.frame.origin.x + button.frame.size.width, self.hotKeyScrollView.frame.size.height)];
        [self.hotKeyScrollView addSubview:button];
        
    }];
    
}

#pragma mark - 获取商品数据
- (void)getTheListData
{
    if (self.page == 1) {
        [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];
    }

    NSString *path = [NSString stringWithFormat:@"/api/ec/search.php?keywords=%@&category=%@&sort=%@&order=%@&min_price=%@&max_price=%@&page=%ld",currentKeyWords,currentCategoryId,currentSortId,currentOrdergoryId,currentMin_price,currentMax_price,self.page];
    
    if (is_shipping.length > 0) {
        path = [path stringByAppendingString:@"&is_shipping=1"];
    }
    if (is_best.length > 0) {
        path = [path stringByAppendingString:@"&is_best=1"];
    }
    if (is_hot.length > 0) {
        path = [path stringByAppendingString:@"&is_hot=1"];
    }
    if (is_new.length > 0) {
        path = [path stringByAppendingString:@"&is_new=1"];
    }
    
    [NETWORK_ENGINE requestWithPath:path Params:nil CompletionHandler:^(MKNetworkOperation *completedOperation) {
        
        NSDictionary *dic=[completedOperation responseDecodeToDic];
        
        NSDictionary *statusDic = [dic objectForKey:@"status"];
        
        if ([@"1" isEqualToString:CHECK_VALUE([statusDic objectForKey:@"statu"])]) {
            
            NSDictionary *data = [dic objectForKey:@"data"];
            
            self.totalRowNum = [CHECK_VALUE([data objectForKey:@"total_recode"]) integerValue];
            
            if (self.totalRowNum == 0) {
                [self showNothingViewForView:self.shopTableView];
                [self.shopArray removeAllObjects];
                self.footview.hidden=YES;
            }
            else{
                [self removeTheNoneView];
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
                    self.shopTableView.contentSize = CGSizeMake(320, 0);
                    
                }
                //当前数据小于总数据的时候页数++
                if (self.shopArray.count < self.totalRowNum) {
                    self.page++;
                }
                else{
                    self.footview.hidden=YES;
                }
                
            }
            [self.shopTableView reloadData];
 
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

- (void)showNothingViewForView:(UIView *)aView
{
    if (nil==noneView) {
        noneView = [[UIView alloc]initWithFrame:CGRectMake(0, 200, aView.frame.size.width, aView.frame.size.height - 200)];
    }
    noneView.backgroundColor = [UIColor clearColor];

    UIImageView *zanWuImg = [[UIImageView alloc]initWithFrame:CGRectMake(93, noneView.frame.size.height/2-35, 133, 77)];
    zanWuImg.image = [UIImage imageWithContentFileName:@"search_empty_icon"];
    [noneView addSubview:zanWuImg];
    
    [aView addSubview:noneView];
}

- (void)removeTheNoneView
{
    [noneView removeFromSuperview];
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
- (void)keyWordsSearch:(id)sender
{
    UIButton *button = (UIButton *)sender;
    
    SearchResultVC *vc = [[SearchResultVC alloc]initWithNibName:@"SearchResultVC" bundle:nil];
    vc.currentKeyWords = button.titleLabel.text;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)searchClick:(id)sender
{
    SearchGoodsVC *vc = [[SearchGoodsVC alloc]initWithNibName:@"SearchGoodsVC" bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
}

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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
