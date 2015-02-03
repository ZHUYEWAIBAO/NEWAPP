//
//  BBSViewController.m
//  WomenHealthApp
//
//  Created by 朱 青 on 14-10-23.
//  Copyright (c) 2014年 WomenHealthApp. All rights reserved.
//

#import "BBSViewController.h"
#import "BbsCircleDetailVC.h"
#import "BbsSearchVC.h"
#import "CycleScrollView.h"
#import "BBSMenuModal.h"
#import "BbsFenLeiCell.h"

#import "SurveyVC.h"

#import "AdModal.h"

@interface BBSViewController ()
{
    BOOL isShowSecMenu;
    
    NSMutableArray *adArray;
    
    UIButton *backBtn;
    
}
@property (nonatomic , strong) CycleScrollView *mainScorllView;

@end

@implementation BBSViewController

+ (UINavigationController *)navigationControllerContainSelf
{
    BBSViewController *vc = [[BBSViewController alloc] initWithNibName:@"BBSViewController" bundle:nil];
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:vc];
    return nav;
}

- (void)loadView
{
    [super loadView];
    
    self.title = @"我的圈子";
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //将自定义的视图作为导航条leftBarButtonItem
    UIButton *searchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    searchBtn.frame = CGRectMake(0,0,30,30);
    [searchBtn setImage:[UIImage imageWithContentFileName:@"search_btn"] forState:UIControlStateNormal];
    [searchBtn setImage:[UIImage imageWithContentFileName:@"serarch_btn_selected"] forState:UIControlStateHighlighted];
    [searchBtn addTarget:self action:@selector(searchClick) forControlEvents:UIControlEventTouchUpInside];

    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:searchBtn];
    self.navigationItem.rightBarButtonItem = leftItem;

    
    _bigMenuArray = [[NSMutableArray alloc]init];
    _subMenuArray = [[NSMutableArray alloc]init];
    
    self.secondMenuView.frame=CGRectMake(self.view.frame.size.width, 123, self.secondMenuView.frame.size.width, self.secondMenuView.frame.size.height);
    [self.view insertSubview:self.secondMenuView belowSubview:self.lineImgV];
    
    self.cateArrowImgV.frame = CGRectMake(114,self.menuBigTableView.frame.origin.y, self.cateArrowImgV.frame.size.width, self.cateArrowImgV.frame.size.height);
    [self.menuBigTableView addSubview:self.cateArrowImgV];
    
    [self.cateArrowImgV setHidden:YES];
    
    [self getTheFirstCategory];
    
    adArray = [[NSMutableArray alloc]initWithCapacity:5];

    [self getTheBannerData];
    
    //将自定义的视图作为导航条leftBarButtonItem
    backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(10,2.0,32,25);
    [backBtn setImage:[UIImage imageNamed:@"back_bt.png"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(leftBackClick:) forControlEvents:UIControlEventTouchUpInside];
    [backBtn setHidden:YES];
    UIBarButtonItem *Item = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem = Item;
    
}

#pragma mark - 获取广告
- (void)getTheBannerData
{
    //设置请求参数
    [self.params removeAllObjects];
    
    [NETWORK_ENGINE requestWithPath:@"/api/ec/?mod=ad&location=dz" Params:self.params CompletionHandler:^(MKNetworkOperation *completedOperation) {
        
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
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 120)];
        [imageView setContentMode:UIViewContentModeScaleAspectFit];
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
    
//    self.mainScorllView = [[CycleScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_SIZE.width, 120) animationDuration:3];

//
//    self.mainScorllView.fetchContentViewAtIndex = ^UIView *(NSInteger pageIndex){
//        return viewsArray[pageIndex];
//    };
//    
//    self.mainScorllView.totalPagesCount = ^NSInteger(void){
//        return array.count;
//    };
    AdModal *model1 = [adArray objectAtIndex:0];
    self.mainScorllView = [[CycleScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_SIZE.width, 120) animationDuration:5 withAry:viewsArray andfirstImageUrl:model1.adSrc];
        __block BBSViewController *vc = self;
    self.mainScorllView.TapActionBlock = ^(NSInteger pageIndex){
        
        AdModal *modal = [array objectAtIndex:pageIndex];
        
        if ([@"url" isEqualToString:modal.adType]) {
            [vc action:modal.adType withJumpId:modal.adUrl withTitle:modal.adText];
        }
        else if ([@"goods" isEqualToString:modal.adType]) {
            [vc action:modal.adType withJumpId:modal.adGoods_id withTitle:nil];
        }
    };
    [self.mainScorllView setBackgroundColor:[UIColor whiteColor]];
    [self.lineImgV setHidden:NO];
    [self.view addSubview:self.mainScorllView];
    
}

- (void)searchClick
{
    BbsSearchVC *vc = [[BbsSearchVC alloc]initWithNibName:@"BbsSearchVC" bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)getTheFirstCategory
{
    
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];
    
    [NETWORK_ENGINE requestWithPath:GLOBALSHARE.CIRCLE_BIGMENU_PATH Params:self.params CompletionHandler:^(MKNetworkOperation *completedOperation) {
        
        NSDictionary *dic = [completedOperation responseDecodeToDic];
        
        NSDictionary *statusDic = [dic objectForKey:@"status"];
        NSDictionary *dataDic = [dic objectForKey:@"data"];
        if ([@"1" isEqualToString:CHECK_VALUE([statusDic objectForKey:@"statu"])]){
            
            NSArray *array = CHECK_ARRAY_VALUE([dataDic objectForKey:@"forumlist"]);
            
            for (NSDictionary *subDic in array) {
                BBSMenuModal *modal = [BBSMenuModal parseDicToMenuListObject:subDic];
                [self.bigMenuArray addObject:modal];
            }
            [self.menuBigTableView reloadData];
            [SVProgressHUD dismiss];
        }
        else{
            [SVProgressHUD showErrorWithStatus:CHECK_VALUE([statusDic objectForKey:@"msg"])];
        }
        
        
    } ErrorHandler:^(MKNetworkOperation *completedOperation, NSError *error) {
        
        [SVProgressHUD showErrorWithStatus:@"服务器忙，请稍候再试"];
        
    }];
    
}

- (void)getTheSecondCategory:(NSString *)fid
{
    //测试固定写成2
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];
    
    [NETWORK_ENGINE requestWithPath:[GLOBALSHARE.CIRCLE_BIGMENU_PATH stringByAppendingFormat:@"?mod=forumdisplay&fid=%@",fid]  Params:self.params CompletionHandler:^(MKNetworkOperation *completedOperation) {
        
        [self.subMenuArray removeAllObjects];
        
        NSDictionary *dic = [completedOperation responseDecodeToDic];
        
        NSDictionary *statusDic = [dic objectForKey:@"status"];
        NSDictionary *dataDic = [dic objectForKey:@"data"];
        if ([@"1" isEqualToString:CHECK_VALUE([statusDic objectForKey:@"statu"])]){
            
            NSArray *array = CHECK_ARRAY_VALUE([dataDic objectForKey:@"forumlist"]);
            
            for (NSDictionary *subDic in array) {
                BBSMenuModal *modal = [BBSMenuModal parseDicToMenuListObject:subDic];
                [self.subMenuArray addObject:modal];
            }
            [self.secondMenuTableView reloadData];
            [SVProgressHUD dismiss];
        }
        else{
            [SVProgressHUD showErrorWithStatus:CHECK_VALUE([statusDic objectForKey:@"msg"])];
        }
        
        
    } ErrorHandler:^(MKNetworkOperation *completedOperation, NSError *error) {
        
        [SVProgressHUD showErrorWithStatus:@"服务器忙，请稍候再试"];
        
    }];
    
}

#pragma mark tableview
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (tableView.tag == 100) {
        return self.bigMenuArray.count;
    }
    return self.subMenuArray.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (tableView.tag == 100) {
        BbsFenLeiCell *cell =[tableView dequeueReusableCellWithIdentifier:[BbsFenLeiCell cellIdentifier]];
        if (cell ==nil) {
            cell = (BbsFenLeiCell *)[[[NSBundle mainBundle] loadNibNamed:@"BbsFenLeiCell" owner:self options:nil] lastObject];
            
            UIImageView *lineImgV=[[UIImageView alloc]initWithFrame:CGRectMake(10, cell.frame.size.height-1, cell.frame.size.width, 0.5)];
            [cell.contentView addSubview:lineImgV];
            [lineImgV setTag:1000];
            [lineImgV setHidden:YES];
            [lineImgV setBackgroundColor:RGBACOLOR(199, 199, 204, 1.0)];
        }
        
        [cell.bbsArrowImageView setHidden:NO];
        
        BBSMenuModal *modal = [self.bigMenuArray objectAtIndex:indexPath.row];
        [cell.bbsimageView setImageWithURL:[NSURL URLWithString:modal.bbsIcon] placeholderImage:[UIImage imageWithContentFileName:@"Circle_menu_default_image.png"]];
        
        if (isShowSecMenu==NO) {

            cell.bbsTitleLabel.text = modal.bbsName;
            cell.bbsSubLabel.text = modal.bbsDescription;
            [cell.bbsSubLabel setHidden:NO];
            cell.bbsTitleLabel.textColor = RGBACOLOR(190, 169, 130, 1.0);
            
            UIImageView *imageView = (UIImageView *)[cell.contentView viewWithTag:1000];
            [imageView setHidden:NO];
            
            return cell;
        }
        else{

            cell.bbsTitleLabel.text = modal.bbsName;
            [cell.bbsSubLabel setHidden:YES];
            
            UIImageView *imageView = (UIImageView *)[cell.contentView viewWithTag:1000];
            [imageView setHidden:YES];
            
            return cell;
        }
        
    }
    else{
        BbsFenLeiCell *cell =[tableView dequeueReusableCellWithIdentifier:[BbsFenLeiCell cellIdentifier]];
        if (cell ==nil) {
            cell = (BbsFenLeiCell *)[[[NSBundle mainBundle] loadNibNamed:@"BbsFenLeiCell" owner:self options:nil] lastObject];
            
            UIImageView *lineImgV=[[UIImageView alloc]initWithFrame:CGRectMake(0, cell.frame.size.height-1, cell.frame.size.width, 0.5)];
            [cell.contentView addSubview:lineImgV];
            [lineImgV setBackgroundColor:RGBACOLOR(199, 199, 204, 1.0)];
        }
        
        BBSMenuModal *modal = [self.subMenuArray objectAtIndex:indexPath.row];
        
        cell.bbsTitleLabel.text = modal.bbsName;
        cell.bbsSubLabel.text = modal.bbsDescription;
        
        [cell.bbsArrowImageView setHidden:YES];
      
        [cell.bbsimageView setImageWithURL:[NSURL URLWithString:modal.bbsIcon] placeholderImage:[UIImage imageWithContentFileName:@"Circle_menu_default_image.png"]];
        
        return cell;
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    if (tableView.tag==100) {
        
        BBSMenuModal *modal = [self.bigMenuArray objectAtIndex:indexPath.row];
        
        [self getTheSecondCategory:modal.bbsFid];
        
        [self layOutTableView:modal firstCatAndArrow:indexPath];
        
        [self setFirstCatAndArrow:indexPath];
        
    }
    else{
        
        BBSMenuModal *modal = [self.subMenuArray objectAtIndex:indexPath.row];
        BbsCircleDetailVC *vc = [[BbsCircleDetailVC alloc]initWithNibName:@"BbsCircleDetailVC" bundle:nil];
        vc.currentFid = modal.bbsFid;
        [self.navigationController pushViewController:vc animated:YES];
        
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSArray *nibArr = [[NSBundle mainBundle] loadNibNamed:@"BbsFenLeiCell" owner:self options:nil];
    BbsFenLeiCell *cell = [nibArr objectAtIndex:0];
    return cell.frame.size.height;
    
}

- (void)layOutTableView:(BBSMenuModal *)model firstCatAndArrow:(NSIndexPath *)path
{
    if (isShowSecMenu==NO) {
        
        [backBtn setHidden:NO];
        
        isShowSecMenu=YES;
        
        [self.cateArrowImgV setHidden:NO];
        
        self.cateArrowImgV.frame=CGRectMake(self.cateArrowImgV.frame.origin.x,self.cateArrowImgV.frame.size.height*path.row, self.cateArrowImgV.frame.size.width, self.cateArrowImgV.frame.size.height);
        
        [UIView animateWithDuration:0.2f animations:^{
            self.menuBigTableView.frame=CGRectMake(-60, self.menuBigTableView.frame.origin.y, self.menuBigTableView.frame.size.width, self.menuBigTableView.frame.size.height);
            
        }];
        [UIView animateWithDuration:0.048f animations:^{
            self.secondMenuView.frame=CGRectMake(70, self.secondMenuView.frame.origin.y, self.secondMenuView.frame.size.width, self.secondMenuTableView.frame.size.height);
            
        }];
        
        [self.menuBigTableView reloadData];
    }

    
}

//设置一级分类按钮选中和箭头动画
- (void)setFirstCatAndArrow:(NSIndexPath *)path
{
    for (int i = 0; i<self.bigMenuArray.count; i++) {
        BbsFenLeiCell *cell=(BbsFenLeiCell *)[self.menuBigTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
        cell.bbsTitleLabel.textColor = RGBACOLOR(190, 169, 130, 1.0);
        
    }//先遍历所有cell，全部设为未选中颜色
    
    BbsFenLeiCell *cell=(BbsFenLeiCell *)[self.menuBigTableView cellForRowAtIndexPath:path];
    cell.bbsTitleLabel.textColor = RGBACOLOR(253, 153, 172, 1.0);
    
    [UIView animateWithDuration:0.2f animations:^{
        self.cateArrowImgV.frame=CGRectMake(self.cateArrowImgV.frame.origin.x,self.cateArrowImgV.frame.size.height*path.row, self.cateArrowImgV.frame.size.width, self.cateArrowImgV.frame.size.height);
    }];
    
    [self.secondMenuTableView setContentOffset:CGPointMake(0, 0)];
    
    //保存已选中行数
    //    indexRow=path.row;
}


- (void)leftBackClick:(id)sender
{

    isShowSecMenu=NO;
    [backBtn setHidden:YES];
    
    [self.cateArrowImgV setHidden:YES];
    
    [UIView animateWithDuration:0.2f animations:^{
        self.menuBigTableView.frame=CGRectMake(0, self.menuBigTableView.frame.origin.y, self.menuBigTableView.frame.size.width, self.menuBigTableView.frame.size.height);
        self.secondMenuView.frame=CGRectMake(self.view.frame.size.width, self.secondMenuView.frame.origin.y, self.secondMenuView.frame.size.width, self.menuBigTableView.frame.size.height);
    }];

    
    [self.menuBigTableView reloadData];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
