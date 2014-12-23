//
//  ShoppingDetailVC.m
//  WomenHealthApp
//
//  Created by 朱青 on 14/12/1.
//  Copyright (c) 2014年 WomenHealthApp. All rights reserved.
//

#import "ShoppingDetailVC.h"
#import "ShoppingWebVC.h"
#import "ShoppingParameterView.h"
#import "ShoppingCommentView.h"
#import "B2CSelectCountView.h"

#import "ShoppingCartVC.h"
#define TAG_BUYNOW 100
#define TAG_ADDCAR 101

#import "ShoppingOrderComfirmVC.h"
#import "AddressViewController.h"
#import "OrderCommentListVC.h"
#import "JSONKit.h"

@interface ShoppingDetailVC ()<UIScrollViewDelegate,B2CSelectCountViewDelegate>


/**
 *  选择数量的view
 */
@property (strong, nonatomic) B2CSelectCountView *selectCountView;

@end

@implementation ShoppingDetailVC

- (void)loadView
{
    [super loadView];
    
    self.title = @"商品详情";
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //添加分享按钮
    UIButton *rightButton=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
    [rightButton addTarget:self action:@selector(shareAction:) forControlEvents:UIControlEventTouchUpInside];
    [rightButton setBackgroundImage:[UIImage imageWithContentFileName:@"share_btn"] forState:UIControlStateNormal];
    UIBarButtonItem *rightButtonItem=[[UIBarButtonItem alloc]initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem = rightButtonItem;
    
    [self getTheB2CDetailWithGoodsId:self.goodsId];
    
    _selectCountView = (B2CSelectCountView *)[[[NSBundle mainBundle] loadNibNamed:@"B2CSelectCountView" owner:self options:nil] firstObject];
    [_selectCountView layOutTheCountView];
    [_selectCountView setDelegate:self];
    _selectCountView.frame = CGRectMake(0, SCREEN_SIZE.height, _selectCountView.frame.size.width, _selectCountView.frame.size.height);
    
    
}

//商品详情信息接口请求
- (void)getTheB2CDetailWithGoodsId:(NSString *)modelId
{
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];
    
    NSString *path = [NSString stringWithFormat:@"/api/ec/goods.php?id=%@",modelId];
    
    [NETWORK_ENGINE requestWithPath:path Params:self.params CompletionHandler:^(MKNetworkOperation *completedOperation) {
     
        NSDictionary *dic=[completedOperation responseDecodeToDic];
        
        NSDictionary *statusDic = [dic objectForKey:@"status"];
        
        if ([@"1" isEqualToString:CHECK_VALUE([statusDic objectForKey:@"statu"])]) {
            
            GoodDetailModel *model = [GoodDetailModel parseDicToB2CGoodDetailObject:[dic objectForKey:@"data"]];
            
            self.detailModel = model;
            
            NSMutableArray *array = [[NSMutableArray alloc]initWithObjects:_headView,_priceView, nil];
            
            if (model.propertiesModel.propertiesArray.count > 0) {
                [array addObject:_parameterView];
            }
            
            if (model.discussModel.discussArray.count > 0) {
                [array addObject:_commentView];
            }
            
            [array addObject:_imageTextView];


            [self layOutMainView:array];
            
            [_selectCountView layOutTopView:model];
            
        }
        else{
            
            [SVProgressHUD showErrorWithStatus:CHECK_VALUE([statusDic objectForKey:@"msg"])];
        }
        [SVProgressHUD dismiss];
        
    } ErrorHandler:^(MKNetworkOperation *completedOperation, NSError *error) {
   
        [SVProgressHUD showErrorWithStatus:@"服务器忙，请稍候再试"];
        
    }];
    
    
}

//布局整体页面
-(void)layOutMainView:(NSMutableArray *)viewArr
{
    //商品是否已下架,1表示未下架，0表示已下架
    if ([@"0" isEqualToString:self.detailModel.infoModel.goods_number]) {
        
        [self.gotoBuyBtn setHidden:YES];
        [self.addToCarBtn setHidden:YES];
        [self.downAlertLabel setHidden:NO];
        
    }
    
    [self layOutHeadView];
    [self layOutTheTitleView];
    [self layOutTheParameterView];
    [self layOutTheCommentView];
    
    //最外层
    _layOutView.orientation = CSLinearLayoutViewOrientationVertical;
    _layOutView.scrollEnabled = YES;
    _layOutView.showsVerticalScrollIndicator = NO;
    _layOutView.showsVerticalScrollIndicator = YES;
    _layOutView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    for (UIView *view in viewArr) {
        
        CSLinearLayoutItem *item = [CSLinearLayoutItem layoutItemForView:view];
        item.padding = CSLinearLayoutMakePadding(0.0, 0.0, 10.0, 0.0);  //各个view距上下左右的边距长度
        item.horizontalAlignment = CSLinearLayoutItemHorizontalAlignmentCenter;
        
        [_layOutView addItem:item];
    }
    
}

//初始化headView
-(void)layOutHeadView
{
    NSInteger numberOfPages = [self.detailModel.imageModel.imagesArray count];

    self.headPageControl.numberOfPages = numberOfPages;
    
    _headScrollView.delegate = self;
    _headScrollView.contentSize = CGSizeMake(_headScrollView.frame.size.width * numberOfPages, _headScrollView.frame.size.height);
    
    if (numberOfPages > 0) {

        for (int i = 0; i < numberOfPages; i++) {
            [self setImageViewsWithPage:i];
        }
    }
    
    
}

//scrollView上添加imageView
- (void)setImageViewsWithPage:(NSInteger)page
{
    NSInteger numberOfPages = [self.detailModel.imageModel.imagesArray count];
    NSString *urlStr = [[self.detailModel.imageModel.imagesArray objectAtIndex:page] img_url];
    if (page < 0) {
        return;
    }
    if (page >= numberOfPages) {
        return;
    }
    
    UIImageView *tempView = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_SIZE.width * page , 0, SCREEN_SIZE.width, self.headScrollView.frame.size.height)];
    tempView.backgroundColor = [UIColor clearColor];
    tempView.contentMode=UIViewContentModeScaleAspectFit;
    [_headScrollView addSubview:tempView];
    
    //下载图片
    UIActivityIndicatorView *activity=[[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [activity setFrame:CGRectMake(tempView.frame.size.width/2-10, tempView.frame.size.height/2-10, 20, 20)];
    [tempView addSubview:activity];
    
    __block UIActivityIndicatorView *activ=activity;
    [activ startAnimating];
    
    [tempView setImageWithURL:[NSURL URLWithString:urlStr] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
        
        if (image) {
            [activ stopAnimating];
            [activ removeFromSuperview];
            activ=nil;
        }
    }];
    
}

- (void)layOutTheTitleView
{
    //商品名
    [self.nameLabel setText:self.detailModel.infoModel.goods_name];
    
    //现价
    if (self.detailModel.infoModel.promote_price.length > 0 && ![@"0" isEqualToString:self.detailModel.infoModel.promote_price]) {
        
        self.nowLabel.text = [NSString priceStringWithOneFloat:self.detailModel.infoModel.promote_price];
    }
    else{

        self.nowLabel.text = [NSString priceStringWithOneFloat:self.detailModel.infoModel.shop_price];
            
        
    }
    self.nowLabel.textColor = RGBACOLOR(254, 111, 117, 1.0);
    
    //原价
    self.preLabel.text= [NSString priceStringWithOneFloat:self.detailModel.infoModel.market_price];
    self.preLabel.strikeThroughEnabled=YES;
    self.preLabel.textColor=[UIColor darkGrayColor];
}

- (void)layOutTheParameterView
{
    if (self.detailModel.propertiesModel.propertiesArray.count > 0) {
        
        [self.detailModel.propertiesModel.propertiesArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            
            GoodPropertiesModel *model = (GoodPropertiesModel *)obj;
            
            ShoppingParameterView *view = (ShoppingParameterView *)[[[NSBundle mainBundle]loadNibNamed:@"ShoppingParameterView" owner:self options:nil]lastObject];
            
            [view setFrame:CGRectMake(0, 44 + idx * 38, SCREEN_SIZE.width, 38)];
            
            view.nameLabel.text = model.name;
            view.parameterLabel.text = model.value;
            
            [self.parameterView setFrame:CGRectMake(0, 0, SCREEN_SIZE.width, 38 * self.detailModel.propertiesModel.propertiesArray.count + 44)];
            [self.parameterView addSubview:view];
            
        }];
    }
}

- (void)layOutTheCommentView
{
    if (self.detailModel.discussModel.discussArray.count > 0) {
        
        self.commentLabel.text = [NSString stringWithFormat:@"累计评价(%@)",self.detailModel.discussModel.totals];
        
        [self.detailModel.discussModel.discussArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            
            GoodDiscussValueModel *model = (GoodDiscussValueModel *)obj;
            
            ShoppingCommentView *view = (ShoppingCommentView *)[[[NSBundle mainBundle]loadNibNamed:@"ShoppingCommentView" owner:self options:nil]lastObject];
            
            [view setFrame:CGRectMake(0, 44 + idx * 70, SCREEN_SIZE.width, 70)];
            
            view.nameLabel.text = model.discuss_user_name;
            view.contentLabel.text = model.discuss_content;
            view.timeLabel.text = [model.discuss_time substringToIndex:10];
            [view.userImageView setImageWithURL:[NSURL URLWithString:model.discuss_user_avatar]];
            
            [self.commentView setFrame:CGRectMake(0, 0, SCREEN_SIZE.width, 70 * self.detailModel.discussModel.discussArray.count + 44)];
            [self.commentView addSubview:view];
            
        }];
    }
}

- (IBAction)pushToCommentViewAction:(id)sender
{
    OrderCommentListVC *vc = [[OrderCommentListVC alloc]initWithNibName:@"OrderCommentListVC" bundle:nil];
    vc.commentId = self.goodsId;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView;
{
    NSInteger numberOfPages = [self.detailModel.imageModel.imagesArray count];
    
    CGFloat pageWidth = _headScrollView.frame.size.width;
    NSInteger page = floor((_headScrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    if (page < 0 || page >= numberOfPages) {
        return;
    }
    self.headPageControl.currentPage = page;

}

#pragma mark - 按钮事件
- (void)shareAction:(id)sender
{

    AddressViewController *vc = [[AddressViewController alloc]initWithNibName:@"AddressViewController" bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)imageTextClickAction:(id)sender
{
    ShoppingWebVC *vc = [[ShoppingWebVC alloc]initWithNibName:@"ShoppingWebVC" bundle:nil];
    vc.title = self.detailModel.infoModel.goods_name;
    vc.webUrl = self.detailModel.infoModel.goods_desc;
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)buyClickAction:(id)sender
{

    [UIView animateWithDuration:0.2f animations:^{
        
        self.blackButton.alpha = 0.3;
        _selectCountView.frame = CGRectMake(0, self.view.frame.size.height - _selectCountView.frame.size.height, _selectCountView.frame.size.width, _selectCountView.frame.size.height);
 
        [self.view addSubview:_selectCountView];
        
    }];
}

- (IBAction)blackBtnAction:(id)sender
{
    [UIView animateWithDuration:0.2f animations:^{
        
        self.blackButton.alpha = 0.0;
        _selectCountView.frame = CGRectMake(0, SCREEN_SIZE.height, _selectCountView.frame.size.width, _selectCountView.frame.size.height);
        
        
    } completion:^(BOOL finished) {
        [_selectCountView removeFromSuperview];
    }];
}

#pragma mark - B2CSelectCountViewDelegate
- (void)B2CSelectCountView:(B2CSelectCountView *)view params:(NSMutableDictionary *)dic isAddToCar:(BOOL)addToCar
{
    if (![USERINFO isLogin]) {
        [self presentLoginVCAction];
        return;
    }
    if (addToCar) {
        [self addToShopCart:dic];
    }
    else{
        ShoppingOrderComfirmVC *vc = [[ShoppingOrderComfirmVC alloc]initWithNibName:@"ShoppingOrderComfirmVC" bundle:nil];
        vc.jsonString = [dic JSONString];
        [self.navigationController pushViewController:vc animated:YES];
    }
    
}

- (void)B2CSelectCountView:(B2CSelectCountView *)view dismiss:(BOOL)dismiss
{
    [UIView animateWithDuration:0.2f animations:^{
        
        self.blackButton.alpha = 0.0;
        _selectCountView.frame = CGRectMake(0, SCREEN_SIZE.height, _selectCountView.frame.size.width, _selectCountView.frame.size.height);
        
    
    } completion:^(BOOL finished) {
        [_selectCountView removeFromSuperview];
    }];
}

//加入购物车
- (void)addToShopCart:(NSMutableDictionary *)dictionary
{
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];
    
    [self.params removeAllObjects];
    [self.params setObject:[dictionary JSONString] forKey:@"goods"];
    NSString *path = [NSString stringWithFormat:@"/api/ec/flow.php?uid=%@&step=add_to_cart",USERINFO.uid];
    
    [NETWORK_ENGINE requestWithPath:path Params:self.params CompletionHandler:^(MKNetworkOperation *completedOperation) {
        
        NSDictionary *dic=[completedOperation responseDecodeToDic];
        
        NSDictionary *statusDic = [dic objectForKey:@"status"];
        
        if ([@"1" isEqualToString:CHECK_VALUE([statusDic objectForKey:@"statu"])]) {
            [SVProgressHUD showSuccessWithStatus:@"添加购物车成功"];
            
            [UIView animateWithDuration:0.2f animations:^{
                
                self.blackButton.alpha = 0.0;
                _selectCountView.frame = CGRectMake(0, SCREEN_SIZE.height, _selectCountView.frame.size.width, _selectCountView.frame.size.height);
                
                
            } completion:^(BOOL finished) {
                [_selectCountView removeFromSuperview];
            }];

        }
        else{
            
            [SVProgressHUD showErrorWithStatus:@"服务器忙，请稍候再试"];
        }
        [SVProgressHUD dismiss];
        
    } ErrorHandler:^(MKNetworkOperation *completedOperation, NSError *error) {
        
        [SVProgressHUD showErrorWithStatus:@"服务器忙，请稍候再试"];
        
    }];

}


- (IBAction)pushToShopCarAction:(id)sender
{
    
    ShoppingCartVC *vc =[[ShoppingCartVC alloc] initWithNibName:@"ShoppingCartVC" bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
