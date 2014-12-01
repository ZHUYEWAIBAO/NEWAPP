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
#import "AboutUsVC.h"

@interface SetViewController ()<UIActionSheetDelegate>
{
    /**
     *  section个数
     */
    NSInteger sectionNum;
}

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
    
    if ([USERINFO isLogin]) {
        sectionNum = 2;

    }
    else{
        sectionNum = 1;
    }
    
    self.setDataArray = [SettingDataModel arrayForSectionNum:sectionNum];
    
    self.setTableView.tableHeaderView = self.loginView;
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
            
        }
            break;
            
        case 101:{
            //我的购物车

            
        }
            break;
            
        case 103:{
            //我的圈子

            
        }
            break;
        
        case 104:{
            //意见反馈
            
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
        
        [self presentLoginVCAction];
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
            
            //设置请求参数
            [self.params removeAllObjects];
            
            [self.params setObject:CHECK_VALUE(USERINFO.user_id) forKey:@"user_id"];
            [self.params setObject:CHECK_VALUE(USERINFO.code) forKey:@"code"];
            
            [SVProgressHUD showWithStatus:@"正在退出" maskType:SVProgressHUDMaskTypeClear];
            
            [NETWORK_ENGINE requestWithPath:GLOBALSHARE.USER_LOGINOUT_PATH Params:self.params CompletionHandler:^(MKNetworkOperation *completedOperation) {
                
                NSDictionary *dic=[completedOperation responseDecodeToDic];
                
                if ([@"0" isEqualToString:CHECK_VALUE([dic objectForKey:@"errorid"])]) {
                    
                    USERINFO.isLogin = NO;
                    
                    [USERINFO loginOutForUserInfoModel];
                    
                    [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFICATION_USER_LOGIN object:@"0"];
                    
                    [self.navigationController popViewControllerAnimated:YES];
                    
                    [SVProgressHUD dismiss];
                    
                }
                else{
                    [SVProgressHUD showErrorWithStatus:CHECK_VALUE([dic objectForKey:@"msg"])];
                }
                
            } ErrorHandler:^(MKNetworkOperation *completedOperation, NSError *error) {
                [SVProgressHUD showErrorWithStatus:@"服务器忙，请稍候再试"];
            }];
            
        }
    }
    else{
        
        if (buttonIndex == 1) {
//            NSURL *URL = [NSURL URLWithString:self.versionModel.url];
//            [[UIApplication sharedApplication]openURL:URL];
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
//    [SVProgressHUD showWithStatus:@"正在获取最新版本信息" maskType:SVProgressHUDMaskTypeClear];
//    
//    [NETWORK_ENGINE requestWithPath:GLOBALSHARE.SET_NEWVERSION_PATH Params:nil CompletionHandler:^(MKNetworkOperation *completedOperation) {
//        
//        NSDictionary *dic=[completedOperation responseDecodeToDic];
//        
//        if ([@"0" isEqualToString:CHECK_VALUE([dic objectForKey:@"errorid"])]) {
//            
//            if (![CLIENT_VERSION isEqualToString:CHECK_VALUE([dic objectForKey:@"version"])]) {
//                
//                NewVersionModel *model = [NewVersionModel parseDicToNewVersionModel:dic];
//                
//                self.versionModel = model;
//                
//                UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:[NSString stringWithFormat:@"发现新版本V%@",model.version] message:model.explain delegate:self cancelButtonTitle:@"下次再说" otherButtonTitles:@"立即更新", nil];
//                alertView.tag = 101;
//                [alertView show];
//                
//                [SVProgressHUD dismiss];
//                
//            }
//            else{
//                [SVProgressHUD showSuccessWithStatus:@"当前为最新版本"];
//            }
//            
//            
//        }
//        else{
//            [SVProgressHUD showErrorWithStatus:CHECK_VALUE([dic objectForKey:@"msg"])];
//        }
//        
//    } ErrorHandler:^(MKNetworkOperation *completedOperation, NSError *error) {
//        [SVProgressHUD showErrorWithStatus:@"服务器忙，请稍候再试"];
//    }];
//    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
