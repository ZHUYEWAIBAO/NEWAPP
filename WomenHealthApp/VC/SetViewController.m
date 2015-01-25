//
//  SetViewController.m
//  WomenHealthApp
//
//  Created by 朱 青 on 14-10-23.
//  Copyright (c) 2014年 WomenHealthApp. All rights reserved.
//

#import "SetViewController.h"
#import "SettingDataModel.h"
#import "SetTableViewCell.h"
#import "ShoppingCartVC.h"
#import "MyOrderListVC.h"
#import "FeedBackVC.h"
#import "UserDetailVC.h"
#import "MyCircleListVC.h"
#import "AboutUsVC.h"
#import "NewVersionModel.h"
#import <ShareSDK/ShareSDK.h>

@interface SetViewController ()<UIActionSheetDelegate>
{
    /**
     *  section个数
     */
    NSInteger sectionNum;
}
@property (strong,nonatomic)NewVersionModel *versionModel;

@end

@implementation SetViewController

+ (UINavigationController *)navigationControllerContainSelf
{
    SetViewController *vc = [[SetViewController alloc] initWithNibName:@"SetViewController" bundle:nil];
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:vc];
    return nav;
}

- (void)loadView
{
    [super loadView];
    
    self.title = @"设置";
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userAfterLoginAction:) name:NOTIFICATION_USER_LOGIN object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userDetailChangeAction:) name:NOTIFICATION_DETAIL_CHANGE object:nil];
    
    //设置UIImageView显示为圆形
    self.headImageView.layer.cornerRadius = self.headImageView.frame.size.width / 2;
    self.headImageView.layer.masksToBounds = YES;
    
    self.setTableView.tableHeaderView = self.loginView;
    
    if ([USERINFO isLogin]) {
        sectionNum = 2;
        self.headTitleLabel.text = USERINFO.username;
        [self.headImageView setImageWithURL:[NSURL URLWithString:USERINFO.user_icon]];
        
        self.setTableView.tableFooterView = self.setExitView;
    }
    else{
        sectionNum = 1;
    }
    
    self.setDataArray = [SettingDataModel arrayForSectionNum:sectionNum];
    
}

- (void)userAfterLoginAction:(NSNotification *)notification
{
    sectionNum = 2;
    self.headTitleLabel.text = USERINFO.username;
    [self.headImageView setImageWithURL:[NSURL URLWithString:USERINFO.user_icon]];
    self.setDataArray = [SettingDataModel arrayForSectionNum:sectionNum];
    self.setTableView.tableFooterView = self.setExitView;
    
    [self.setTableView reloadData];
}

- (void)userDetailChangeAction:(NSNotification *)notification
{
    if (USERINFO.isLogin) {
        self.headTitleLabel.text = USERINFO.username;
        [self.headImageView setImageWithURL:[NSURL URLWithString:USERINFO.user_icon]];
        
    }
 
}

- (void)userLoginOutAction
{
    sectionNum = 1;
    
    self.headTitleLabel.text = @"未登录";
    [self.headImageView setImage:[UIImage imageWithContentFileName:@"Set_people_head_image.png"]];
    self.setDataArray = [SettingDataModel arrayForSectionNum:sectionNum];
    self.setTableView.tableFooterView = nil;
    
    [self.setTableView reloadData];
}

#pragma mark UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return sectionNum;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSMutableArray *rowArray = [self.setDataArray objectAtIndex:section];
    
    return rowArray.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SetTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[SetTableViewCell cellIdentifier]];
    if (cell == nil){
        NSArray *nibArr = [[NSBundle mainBundle] loadNibNamed:@"SetTableViewCell" owner:self options:nil];
        cell = [nibArr objectAtIndex:0];
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
    }
    
    NSMutableArray *rowArray = [self.setDataArray objectAtIndex:indexPath.section];
    
    SettingDataModel *model = [rowArray objectAtIndex:indexPath.row];
    
    cell.setNamelLabel.text = model.settingName;

    return cell;
}

#pragma mark UITableViewDelegate
//section头部间距
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
    
}

//section底部间距
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *nibArr = [[NSBundle mainBundle] loadNibNamed:@"SetTableViewCell" owner:self options:nil];
    SetTableViewCell *cell = [nibArr objectAtIndex:0];
    
    return cell.frame.size.height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSMutableArray *rowArray = [self.setDataArray objectAtIndex:indexPath.section];
    
    SettingDataModel *model = [rowArray objectAtIndex:indexPath.row];
    
    [self makeActionForModelTag:model.settingTag];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)makeActionForModelTag:(NSInteger)tag
{
    switch (tag) {
        case 100:{
            //我的订单
            MyOrderListVC *vc = [[MyOrderListVC alloc]initWithNibName:@"MyOrderListVC" bundle:nil];
            [self.navigationController pushViewController:vc animated:YES];
            
        }
            break;
            
        case 101:{
            //我的购物车
            ShoppingCartVC *vc =[[ShoppingCartVC alloc] initWithNibName:@"ShoppingCartVC" bundle:nil];
            [self.navigationController pushViewController:vc animated:YES];
            
        }
            break;
            
        case 103:{
            //我的圈子
            MyCircleListVC *vc = [[MyCircleListVC alloc]initWithNibName:@"MyCircleListVC" bundle:nil];
            [self.navigationController pushViewController:vc animated:YES];

            
        }
            break;
        
        case 104:{
            //意见反馈
            FeedBackVC *vc = [[FeedBackVC alloc]initWithNibName:@"FeedBackVC" bundle:nil];
            [self.navigationController pushViewController:vc animated:YES];
            
        }
            break;
            
        case 105:{
            //关于我们
            AboutUsVC *vc = [[AboutUsVC alloc]initWithNibName:@"AboutUsVC" bundle:nil];
            [self.navigationController pushViewController:vc animated:YES];
      
        }
            break;
            
        case 106:{
            //版本更新
            [self getAppVersionInfo];
        }
            break;
            
        case 107:{
            //清除缓存
            UIActionSheet *actionSheet = [[UIActionSheet alloc] init];
            actionSheet.title = @"确定要清除缓存记录吗";
            actionSheet.delegate = self;
            [actionSheet addButtonWithTitle:NSLocalizedString(@"清除所有缓存记录", nil)];
            actionSheet.cancelButtonIndex = [actionSheet addButtonWithTitle:NSLocalizedString(@"取消", nil)];
            [actionSheet showInView:self.view];
        }
            break;
            
        default:
            break;
    }
    
}

- (IBAction)btnClickAction:(id)sender
{
    UIButton *button = (UIButton *)sender;
    
    if (button.tag == 100) {
        
        if ([USERINFO isLogin]) {
            UserDetailVC *vc = [[UserDetailVC alloc]initWithNibName:@"UserDetailVC" bundle:nil];
            [self.navigationController pushViewController:vc animated:YES];
        }
        else{
            [self presentLoginVCAction];
        }
        
    }
    else{
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"确定要退出舒服吗" message:@"" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        alertView.tag = 100;
        [alertView show];
    }

    
    
}

#pragma mark - UIAlertViewDelegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 100) {
        if (buttonIndex == 1) {
            
            if ([@"1" isEqualToString:USERINFO.loginType]) {
                [ShareSDK cancelAuthWithType:ShareTypeQQSpace];
            }
            else if([@"2" isEqualToString:USERINFO.loginType]){
                [ShareSDK cancelAuthWithType:ShareTypeSinaWeibo];
            }
            
            [USERINFO loginOutForUserInfoModel];
            
            LoginDataModel *model = [LoginDataModel rememberLoginPhoneNum:@"" andPassword:@"" andThirdUid:@"" andLoginType:@"" remember:NO];

            SaveTheUserPhoneNumAndPassword(model);
            
            [self userLoginOutAction];
            
        }
    }
    else{
        
        if (buttonIndex == 1) {
            NSURL *URL = [NSURL URLWithString:self.versionModel.link];
            [[UIApplication sharedApplication]openURL:URL];
        }
        
    }
    
}

#pragma mark UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        //清除缓存
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
        NSString *path = [paths objectAtIndex:0];
        NSFileManager *fileManager = [NSFileManager defaultManager];
        [fileManager removeItemAtPath:path error:nil];
        
        [SVProgressHUD showSuccessWithStatus:@"清除成功"];
    }
}

#pragma mark 版本更新
- (void)getAppVersionInfo
{
  
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];
    
    NSString *path = [NSString stringWithFormat:@"/api/ec/update.php?v=%@&s=ios",CLIENT_VERSION];

    [NETWORK_ENGINE requestWithPath:path Params:self.params CompletionHandler:^(MKNetworkOperation *completedOperation) {
        
        NSDictionary *dic=[completedOperation responseDecodeToDic];
        
        NSDictionary *statusDic = [dic objectForKey:@"status"];
        
        if ([@"1" isEqualToString:CHECK_VALUE([statusDic objectForKey:@"statu"])]) {
            
            NSDictionary *data = [dic objectForKey:@"data"];
            
            if (![CLIENT_VERSION isEqualToString:CHECK_VALUE([data objectForKey:@"version"])]) {
                
                NewVersionModel *model = [NewVersionModel parseDicToNewVersionModel:dic];
                
                self.versionModel = model;
                
                UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:[NSString stringWithFormat:@"发现新版本V%@",model.version] message:model.content delegate:self cancelButtonTitle:@"下次再说" otherButtonTitles:@"立即更新", nil];
                alertView.tag = 101;
                [alertView show];
                
                [SVProgressHUD dismiss];
                
            }
            else{
                [SVProgressHUD showSuccessWithStatus:@"当前为最新版本"];
            }

    
        }
        else{
            [SVProgressHUD showErrorWithStatus:CHECK_VALUE([statusDic objectForKey:@"msg"])];
        }
        
    } ErrorHandler:^(MKNetworkOperation *completedOperation, NSError *error) {
        
        [SVProgressHUD showErrorWithStatus:@"服务器忙，请稍候再试"];
  
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
