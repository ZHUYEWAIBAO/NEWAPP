//
//  RefreshTableVC.h
//  CMCCMall
//
//  Created by 萧 曦 on 13-5-6.
//  Copyright (c) 2013年 cmcc. All rights reserved.
//

#import "BasicVC.h"
#import "EGORefreshTableHeaderView.h"
#import "MJRefreshFooterView.h"

@interface RefreshTableVC : BasicVC<UITableViewDataSource,UITableViewDelegate,EGORefreshTableHeaderDelegate,MJRefreshBaseViewDelegate>


@property (nonatomic,strong) UITableView* tableView;  //列表
@property (nonatomic,strong) NSMutableArray* dataArray; //数据
@property (nonatomic,strong) EGORefreshTableHeaderView* refreshHeaderView; //头部刷新view
@property (nonatomic,strong) MJRefreshFooterView *footview;  //上拉加载更多
@property (nonatomic,assign) BOOL  isLoading; //加载状态
@property (nonatomic,assign) BOOL  isNeedLoadMore; //是否需要分页加载

@property (nonatomic,assign) NSInteger totalRowNum;//总行数
@property (nonatomic,assign) NSInteger totalPage;//总页数
@property (nonatomic,assign) NSInteger page;//页数


- (void)reloadTableViewDataSource;
- (void)doneLoadingTableViewData;

- (void)scrollViewDidScroll:(UIScrollView *)scrollView;
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate;

- (NSString *)distanceChange:(NSString *)distance;
@end
