//
//  BbsFenLeiVC.m
//  WomenHealthApp
//
//  Created by Daniel on 14/11/15.
//  Copyright (c) 2014年 WomenHealthApp. All rights reserved.
//

#import "BbsFenLeiVC.h"
#import "BbsFenLeiCell.h"
@interface BbsFenLeiVC ()

@end

@implementation BbsFenLeiVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title =@"圈子分类";
    
    [self getTheFirstCategory];
}

- (void)getTheFirstCategory
{

    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];
    
    [NETWORK_ENGINE requestWithPath:GLOBALSHARE.CIRCLE_BIGMENU_PATH Params:self.params CompletionHandler:^(MKNetworkOperation *completedOperation) {
        
        NSDictionary *dic = [completedOperation responseDecodeToDic];
        
        NSDictionary *statusDic = [dic objectForKey:@"status"];
        if ([@"1" isEqualToString:CHECK_VALUE([statusDic objectForKey:@"statu"])]){
            

//            [SVProgressHUD dismiss];
        }
        else{
            [SVProgressHUD showErrorWithStatus:CHECK_VALUE([statusDic objectForKey:@"msg"])];
        }
      
        
    } ErrorHandler:^(MKNetworkOperation *completedOperation, NSError *error) {
     
        [SVProgressHUD showErrorWithStatus:@"服务器忙，请稍候再试"];
        
    }];

}

#pragma mark tableview
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 7;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    static NSString *indertifier =@"BbsFenLeiCell";
    
    BbsFenLeiCell *cell =[tableView dequeueReusableCellWithIdentifier:indertifier];
    if (cell ==nil) {
        cell =(BbsFenLeiCell *)[[[NSBundle mainBundle] loadNibNamed:@"BbsFenLeiCell" owner:self options:nil] lastObject];
    }
    
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
//    [UIView animateWithDuration:0.5 animations:^{
//        
//        self.fenleiTable.frame =CGRectMake(-100, 50, 320, 518);
//        
//    }];
//    
//    
//    [UIView animateWithDuration:0.5 animations:^{
//        
//        self.fenLeiRightTable.frame =CGRectMake(50, 50, 270, 518);
//        
//    }];
    
    

    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 60;
}


- (void)didReceiveMemoryWarning
{
    
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
