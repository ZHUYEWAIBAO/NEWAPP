//
//  BbsFenLeiVC.m
//  WomenHealthApp
//
//  Created by Daniel on 14/11/15.
//  Copyright (c) 2014年 WomenHealthApp. All rights reserved.
//

#import "BbsFenLeiVC.h"
#import "BbsFenLeiCell.h"
#import "BBSMenuModal.h"

@interface BbsFenLeiVC ()
{
    BOOL isShowSecMenu;
}
@end

@implementation BbsFenLeiVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title =@"圈子分类";
    
    _bigMenuArray = [[NSMutableArray alloc]init];
    _subMenuArray = [[NSMutableArray alloc]init];
    
    self.secondMenuView.frame=CGRectMake(self.view.frame.size.width, self.menuBigTableView.frame.origin.y, self.secondMenuView.frame.size.width, self.menuBigTableView.frame.size.height);
    [self.view insertSubview:self.secondMenuView belowSubview:self.headView];
    
    self.cateArrowImgV.frame=CGRectMake(114,self.menuBigTableView.frame.origin.y, self.cateArrowImgV.frame.size.width, self.cateArrowImgV.frame.size.height);
    [self.menuBigTableView addSubview:self.cateArrowImgV];

    [self.cateArrowImgV setHidden:YES];
    
    [self getTheFirstCategory];
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
    
    [NETWORK_ENGINE requestWithPath:[GLOBALSHARE.CIRCLE_BIGMENU_PATH stringByAppendingFormat:@"?mod=forumdisplay&fid=%@",@"2"]  Params:self.params CompletionHandler:^(MKNetworkOperation *completedOperation) {
        
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
        [cell.bbsEditBtn setHidden:YES];
        
        if (isShowSecMenu==NO) {
            BBSMenuModal *modal = [self.bigMenuArray objectAtIndex:indexPath.row];
            
            cell.bbsTitleLabel.text = modal.bbsName;
            cell.bbsSubLabel.text = modal.bbsDescription;
            
            UIImageView *imageView = (UIImageView *)[cell.contentView viewWithTag:1000];
            [imageView setHidden:NO];
            
            return cell;
        }
        else{
            BBSMenuModal *modal = [self.bigMenuArray objectAtIndex:indexPath.row];
            
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
        [cell.bbsEditBtn setHidden:NO];
        
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
    
    self.title = model.bbsName;
    
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

- (void)getTheCircleWithFid:(NSString *)fid
{
    //测试固定写成2
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];
    
    [NETWORK_ENGINE requestWithPath:[GLOBALSHARE.CIRCLE_BIGMENU_PATH stringByAppendingFormat:@"?mod=collect&action=add&fid=%@&uid=%@",@"2",@"1"]  Params:self.params CompletionHandler:^(MKNetworkOperation *completedOperation) {
        
        [self.subMenuArray removeAllObjects];
        
        NSDictionary *dic = [completedOperation responseDecodeToDic];
        
        NSDictionary *statusDic = [dic objectForKey:@"status"];
        NSDictionary *dataDic = [dic objectForKey:@"data"];
        if ([@"1" isEqualToString:CHECK_VALUE([statusDic objectForKey:@"statu"])]){
            
//            NSArray *array = CHECK_ARRAY_VALUE([dataDic objectForKey:@"forumlist"]);
//            
//            for (NSDictionary *subDic in array) {
//                BBSMenuModal *modal = [BBSMenuModal parseDicToMenuListObject:subDic];
//                [self.subMenuArray addObject:modal];
//            }
//            [self.secondMenuTableView reloadData];
            [SVProgressHUD dismiss];
        }
        else{
            [SVProgressHUD showErrorWithStatus:CHECK_VALUE([statusDic objectForKey:@"msg"])];
        }
        
        
    } ErrorHandler:^(MKNetworkOperation *completedOperation, NSError *error) {
        
        [SVProgressHUD showErrorWithStatus:@"服务器忙，请稍候再试"];
        
    }];

}

- (void)didReceiveMemoryWarning
{
    
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
