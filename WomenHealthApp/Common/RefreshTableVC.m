//
//  RefreshTableVC.m
//  CMCCMall
//
//  Created by 萧 曦 on 13-5-6.
//  Copyright (c) 2013年 cmcc. All rights reserved.
//

#import "RefreshTableVC.h"
//#import "GroupBuyListVC.h"
//#import "CouponListVC.h"
//#import "NearbyVC.h"
//#import "ShopListVC.h"
//#import "OTOVC.h"
//#import "CheckinVC.h"
//#import "CommentVC.h"
@interface RefreshTableVC ()

@end

@implementation RefreshTableVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        self.dataArray=[NSMutableArray arrayWithCapacity:5];
        self.totalRowNum=0;
        self.totalPage = 0;
        self.page=1;
        
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    if (_refreshHeaderView == nil) {
		
		EGORefreshTableHeaderView *view = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - self.tableView.bounds.size.height, self.view.frame.size.width, self.tableView.bounds.size.height)];
		view.delegate = self;
		[self.tableView addSubview:view];
		self.refreshHeaderView = view;
		
	}
	
	//  update the last update date
	[_refreshHeaderView refreshLastUpdatedDate];
    
    //判断需要上拉分页的类
    if (self.isNeedLoadMore==YES) {
        //集成上拉加载更多控件
        _footview = [MJRefreshFooterView footer];
        _footview.scrollView = self.tableView;
        _footview.delegate=self;
    }


    
}

- (NSString *)distanceChange:(NSString *)distance
{
    if ([distance isEqualToString:@"3000"]) {
        return @"3";
    }
    else if([distance isEqualToString:@"500"]){
        return @"0";
    }
    else if([distance isEqualToString:@"1000"]){
        return @"1";
    }
    else if([distance isEqualToString:@"2000"]){
        return @"2";
    }
    else{
        return @"";
    }
}

#pragma mark -
#pragma mark UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 10;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"refreshCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
	// Configure the cell.
    
    return cell;
}

#pragma mark -
#pragma mark Data Source Loading / ReLoading Methods

- (void)reloadTableViewDataSource{
	
	//  should be calling your tableviews data source model to reload
	//  put here just for demo
    _isLoading = YES;
	
}

- (void)doneLoadingTableViewData{
	
	//  model should call this when its done loading
    _isLoading = NO;
	[_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self.tableView];
	
}



#pragma mark -
#pragma mark UIScrollViewDelegate Methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
	
	[_refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
    
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerat
{
	if (scrollView == self.tableView) {
        [_refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
        
    }
	
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    
    
}


#pragma mark -
#pragma mark EGORefreshTableHeaderDelegate Methods

- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)view{
	
	[self reloadTableViewDataSource];
	
}

- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView*)view{
	
	return _isLoading; // should return if data source model is isLoading
	
}

- (NSDate*)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView*)view{
	
	return [NSDate date]; // should return date data source was last changed
	
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    self.refreshHeaderView=nil;
}

- (void)dealloc {
	
	self.refreshHeaderView = nil;
}


@end
