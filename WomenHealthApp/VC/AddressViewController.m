//
//  AddressViewController.m
//  CMCCMall
//
//  Created by 朱 青 on 14-11-11.
//  Copyright (c) 2014年 cmcc. All rights reserved.
//

#import "AddressViewController.h"
#import "AddressEditVC.h"
#import "AddressListCell.h"
#import "AddressListModel.h"
#import "CalculateHigh.h"

@interface AddressViewController ()
{
    AddressListModel *nonePhoneModel;
    
    UIView *showNoneView;
   
}

@end

@implementation AddressViewController

- (void)loadView
{
    [super loadView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getTheAddressListData:) name:NOTIFICATION_ADDRESS_REQUEST object:nil];
    
    self.title = @"收货地址";
    
    _addressArray = [[NSMutableArray alloc]init];

}

- (void)viewDidLoad {
    [super viewDidLoad];
  
    [self getTheAddressListData:nil];
   
    self.addressTableView.tableFooterView = self.footView;
}

//获取收获地址列表
- (void)getTheAddressListData:(NSNotification *)notifi
{
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];
    
    [NETWORK_ENGINE requestWithPath:[NSString stringWithFormat:@"/api/ec/user.php?mod=address_list&uid=%@",USERINFO.uid] Params:self.params CompletionHandler:^(MKNetworkOperation *completedOperation) {

        [SVProgressHUD dismiss];
        
        NSDictionary *dic=[completedOperation responseDecodeToDic];
        
        NSDictionary *statusDic = [dic objectForKey:@"status"];
        
        if ([@"1" isEqualToString:CHECK_VALUE([statusDic objectForKey:@"statu"])]) {
            
            [self.addressArray removeAllObjects];
    
            NSDictionary *data = [dic objectForKey:@"data"];
            
            NSArray *array = CHECK_ARRAY_VALUE([data objectForKey:@"list"]);
            
            if (array.count > 0) {
                [array enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                    NSDictionary *dictionary = (NSDictionary *)obj;
                    
                    AddressListModel *model = [AddressListModel parseDicToAddressListObject:dictionary];
                    [self.addressArray addObject:model];
           
                    
                }];
                [self.addressTableView reloadData];
             
            }
   

        }
        else{
            [SVProgressHUD showErrorWithStatus:CHECK_VALUE([statusDic objectForKey:@"msg"])];
        }
        
    } ErrorHandler:^(MKNetworkOperation *completedOperation, NSError *error) {
  
        [SVProgressHUD showErrorWithStatus:@"服务器忙，请稍候再试"];
    }];
    
}

- (IBAction)addAddressAction:(id)sender
{
    AddressEditVC *vc = [[AddressEditVC alloc]initWithNibName:@"AddressEditVC" bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.addressArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSArray *nibArr = [[NSBundle mainBundle] loadNibNamed:@"AddressListCell" owner:self options:nil];
    AddressListCell *cell = [nibArr objectAtIndex:0];
    return cell.frame.size.height;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
 
    AddressListCell *cell = [tableView dequeueReusableCellWithIdentifier:[AddressListCell cellIdentifier]];
    
    if (cell == nil) {
        
        NSArray *nibArr = [[NSBundle mainBundle] loadNibNamed:@"AddressListCell" owner:self options:nil];
        cell = [nibArr objectAtIndex:0];

    }
    AddressListModel *listModel = [self.addressArray objectAtIndex:indexPath.row];
    cell.addressNameLabel.text = listModel.consignee;
    cell.addressPhoneLabel.text = listModel.mobile;
    cell.addressDetailLabel.text = listModel.address;
    
    [cell.editButton addTarget:self action:@selector(editButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    cell.editButton.tag = 100 + indexPath.row;
    
    [cell.deleteButton addTarget:self action:@selector(deleteButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    cell.deleteButton.tag = 200 + indexPath.row;
    
    [cell.setDefaultButton addTarget:self action:@selector(setDefaultButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    cell.setDefaultButton.tag = 300 + indexPath.row;


    if([@"1" isEqualToString:listModel.is_default]){
        [cell.setDefaultButton setBackgroundImage:[UIImage imageWithContentFileName:@"deault_address_btn"] forState:UIControlStateNormal];
    }
    else{
        [cell.setDefaultButton setBackgroundImage:[UIImage imageWithContentFileName:@"setting_default_btn"] forState:UIControlStateNormal];
    }

    
    return cell;
    
}

//设置默认
-(void)setDefaultButtonClick:(UIButton *)sender
{
    AddressListModel *listModel = [self.addressArray objectAtIndex:sender.tag - 300];
    
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];
    
    [NETWORK_ENGINE requestWithPath:[NSString stringWithFormat:@"/api/ec/user.php?mod=default_address&uid=%@&address_id=%@",USERINFO.uid,listModel.address_id] Params:self.params CompletionHandler:^(MKNetworkOperation *completedOperation) {
        
        NSDictionary *dic = [completedOperation responseDecodeToDic];
        
        NSDictionary *statusDic = [dic objectForKey:@"status"];
        
        if ([@"1" isEqualToString:CHECK_VALUE([statusDic objectForKey:@"statu"])]) {
            
            
            for (int i = 0; i < self.addressArray.count; i++) {

                AddressListModel * model = [self.addressArray objectAtIndex:i];
                model.is_default = @"0";
            }
            
            listModel.is_default = @"1";
            
            [self.addressTableView reloadData];
            
            [SVProgressHUD showSuccessWithStatus:@"设置成功"];
           
        }
        else{
            [SVProgressHUD showErrorWithStatus:CHECK_VALUE([statusDic objectForKey:@"msg"])];
        }
        
    } ErrorHandler:^(MKNetworkOperation *completedOperation, NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"服务器忙，请稍候再试"];
    }];

}

//地址删除
- (void)deleteButtonClick:(UIButton *)sender
{
    AddressListModel *listModel = [self.addressArray objectAtIndex:sender.tag - 200];
    
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];
    
    [NETWORK_ENGINE requestWithPath:[NSString stringWithFormat:@"/api/ec/user.php?mod=drop_consignee&uid=%@&address_id=%@",USERINFO.uid,listModel.address_id] Params:self.params CompletionHandler:^(MKNetworkOperation *completedOperation) {
  
        NSDictionary *dic = [completedOperation responseDecodeToDic];
        
        NSDictionary *statusDic = [dic objectForKey:@"status"];
        
        if ([@"1" isEqualToString:CHECK_VALUE([statusDic objectForKey:@"statu"])]) {
            
            [SVProgressHUD showSuccessWithStatus:@"删除成功"];
     
            [self.addressArray removeObject:listModel];
  
            [self.addressTableView reloadData];

//            [[NSNotificationCenter defaultCenter]postNotificationName:@"deleteAddress" object:deleteDic];
        }
        else{
            [SVProgressHUD showErrorWithStatus:CHECK_VALUE([statusDic objectForKey:@"msg"])];
        }

    } ErrorHandler:^(MKNetworkOperation *completedOperation, NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"服务器忙，请稍候再试"];
    }];

}

//地址编辑
-(void)editButtonClick:(UIButton *)sender
{
    AddressEditVC *vc = [[AddressEditVC alloc]initWithNibName:@"AddressEditVC" bundle:nil];

    AddressListModel *listModel = [self.addressArray objectAtIndex:sender.tag - 100];
    
    vc.changeModel = listModel;
    
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    AddressListModel *model = [self.addressArray objectAtIndex:indexPath.row];

    [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFICATION_ADDRESS_SELECT object:model.address_id];
    [self.navigationController popViewControllerAnimated:YES];

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
