//
//  ShoppingViewController.m
//  WomenHealthApp
//
//  Created by 朱 青 on 14-10-23.
//  Copyright (c) 2014年 WomenHealthApp. All rights reserved.
//

#import "ShoppingViewController.h"
#import "AdModal.h"

@interface ShoppingViewController ()
{
    NSMutableArray *adArray;
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
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //将自定义的视图作为导航条leftBarButtonItem
    UIButton *searchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    searchBtn.frame = CGRectMake(0,0,30,30);
    [searchBtn setImage:[UIImage imageWithContentFileName:@"search_btn"] forState:UIControlStateNormal];
    [searchBtn setImage:[UIImage imageWithContentFileName:@"serarch_btn_selected"] forState:UIControlStateHighlighted];
    [searchBtn addTarget:self action:@selector(searchClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:searchBtn];
    self.navigationItem.rightBarButtonItem = leftItem;
    
    adArray = [[NSMutableArray alloc]initWithCapacity:5];
    [self getTheBannerData];

}

//获取广告
- (void)getTheBannerData
{
    //设置请求参数
    [self.params removeAllObjects];

    [NETWORK_ENGINE requestWithPath:@"/api/ec/?mod=ad" Params:self.params CompletionHandler:^(MKNetworkOperation *completedOperation) {
        
        NSDictionary *dic=[completedOperation responseDecodeToDic];
        
        NSDictionary *statusDic = [dic objectForKey:@"status"];
        NSLog(@"yyy %@",dic);
        
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
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 120)];
        
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
        NSLog(@"点击了第%ld个",pageIndex);
        AdModal *modal = [array objectAtIndex:pageIndex];
        [vc action:modal.adType withJumpId:modal.adUrl];
    };
    
    [self.headView addSubview:self.mainScorllView];
    
    self.shopTableView.tableHeaderView = self.headView;
    
}

- (void)searchClick:(id)sender
{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
