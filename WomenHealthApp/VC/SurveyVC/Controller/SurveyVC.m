//
//  SurveyVC.m
//  WomenHealthApp
//
//  Created by Daniel on 15/1/16.
//  Copyright (c) 2015年 WomenHealthApp. All rights reserved.
//

#import "SurveyVC.h"
#import "SurveyModel.h"
#import "SurveyTool.h"
#import "SurveyTableViewCell.h"
#import "CommWebView.h"
#import "JSONKit.h"
@interface SurveyVC (){
    
    NSMutableArray *dataAry;//数据源
    
    __weak IBOutlet UITableView *dataTableview;
    
    
    NSInteger indexSectionCustom;
}

@end

@implementation SurveyVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title =@"问卷调查";
    dataAry =[NSMutableArray array];
    indexSectionCustom =0;
    
    UIButton *sendBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    sendBtn.frame = CGRectMake(0,0,30,30);
    [sendBtn setBackgroundImage:[UIImage imageWithContentFileName:@"Record_detail_sure_btn.png"] forState:UIControlStateNormal];
    [sendBtn addTarget:self action:@selector(pushResult) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightButtonItem=[[UIBarButtonItem alloc]initWithCustomView:sendBtn];
    self.navigationItem.rightBarButtonItem = rightButtonItem;
    
    [self.params removeAllObjects];
    [NETWORK_ENGINE requestWithPath:GLOBALSHARE.CIRCLE_SURVEY Params:self.params CompletionHandler:^(MKNetworkOperation *completedOperation) {
        
        NSDictionary *dic = [completedOperation responseDecodeToDic];
        
        NSDictionary *statusDic = [dic objectForKey:@"status"];
        NSDictionary *dataDic = [dic objectForKey:@"data"];
        if ([@"1" isEqualToString:CHECK_VALUE([statusDic objectForKey:@"statu"])]){
          
            NSLog(@"%@",dataDic);
            
            dataAry  =[SurveyTool getDataAryWithDic:dataDic];
            
            [dataTableview reloadData];
            [SVProgressHUD dismiss];
            
        }
        else{
            [SVProgressHUD showErrorWithStatus:CHECK_VALUE([statusDic objectForKey:@"msg"])];
        }
        
        
    } ErrorHandler:^(MKNetworkOperation *completedOperation, NSError *error) {
        
        [SVProgressHUD showErrorWithStatus:@"服务器忙，请稍候再试"];
        
    }];

    
    
    // Do any additional setup after loading the view from its nib.
}

-(void)pushResult{
    
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];
    
    [self.params removeAllObjects];
    NSMutableDictionary *dics =[NSMutableDictionary dictionary];
    [dataAry enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
       
        NSMutableArray *paramesAry =[NSMutableArray array];
        
        [((SurveyModel *)obj).optionAry enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            if (((OptionModel *)obj).selectBool) {
                [paramesAry addObject:((OptionModel *)obj).option_id];
            }
            
        }];
        
        [dics setObject:paramesAry forKey:((SurveyModel *)obj).vote_id];
        
    }];
    
   
//    paramesAry
    
    [self.params setObject:[dics JSONString] forKey:@"options"];

    
    
    [NETWORK_ENGINE requestWithPath:GLOBALSHARE.CIRCLE_ASNWER Params:self.params CompletionHandler:^(MKNetworkOperation *completedOperation) {
        
        NSDictionary *dic = [completedOperation responseDecodeToDic];
        
        NSDictionary *statusDic = [dic objectForKey:@"status"];
        NSDictionary *dataDic = [dic objectForKey:@"data"];
        if ([@"1" isEqualToString:CHECK_VALUE([statusDic objectForKey:@"statu"])]){
            
            NSLog(@"%@",dataDic);
    
            [SVProgressHUD showSuccessWithStatus:@"提交成功"];

            CommWebView *vc =[[CommWebView alloc] initWithNibName:@"CommWebView" bundle:nil];
            vc.webUrl =[[dic objectForKey:@"data"] objectForKey:@"url"];
            [self.navigationController pushViewController:vc animated:YES];
            
            
        }
        else{
            [SVProgressHUD showErrorWithStatus:CHECK_VALUE([statusDic objectForKey:@"msg"])];
        }
        
        
    } ErrorHandler:^(MKNetworkOperation *completedOperation, NSError *error) {
        
        [SVProgressHUD showErrorWithStatus:@"服务器忙，请稍候再试"];
        
    }];
}
#pragma mark UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return dataAry.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return [[[dataAry objectAtIndex:section] optionAry] count];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 54;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SurveyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[SurveyTableViewCell cellIdentifier]];
    
    if (cell ==nil) {
        cell = (SurveyTableViewCell *)[[[NSBundle mainBundle] loadNibNamed:@"SurveyTableViewCell" owner:self options:nil] lastObject];
    }
    
    SurveyModel *suModel =[dataAry objectAtIndex:indexPath.section];
    
    //取出每个订单下的 每件商品 model
    OptionModel *model = [[[dataAry objectAtIndex:indexPath.section] optionAry] objectAtIndex:indexPath.row];
    
    cell.nameLab.text =[NSString stringWithFormat:@"%ld.  %@",indexPath.row+1 ,model.option_name];
    
    if (model.selectBool) {
        if ([suModel.can_multi integerValue] ==1) {
            cell.selectImg.image =[UIImage imageNamed:@"choose_active_btn.png"];
        }else{
            cell.selectImg.image =[UIImage imageNamed:@"single_active_btn.png"];
        }
        
        
    }else{
        if ([suModel.can_multi integerValue] ==1) {
            cell.selectImg.image =[UIImage imageNamed:@"choose_normal_btn.png"];
        }else{
            cell.selectImg.image =[UIImage imageNamed:@"single_normal_btn.png"];
        }
        
    }
    
    
    cell.selectBtn.tag =10000*indexPath.section+indexPath.row;
    [cell.selectBtn addTarget:self action:@selector(chooseSelect:) forControlEvents:UIControlEventTouchUpInside];
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
    
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    //订单号
    UIView *vc =[[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_SIZE.width, 40)];
    UILabel *laber =[[UILabel alloc] initWithFrame:CGRectMake(12, 10, 265, 20)];
    
    NSString *opionName =[[dataAry objectAtIndex:section] vote_name];
    laber.text =[NSString stringWithFormat:@"问题%ld :  %@",section+1,opionName];
    laber.font =[UIFont systemFontOfSize:12];
    laber.backgroundColor =[UIColor clearColor];
    [vc addSubview:laber];
    
    vc.backgroundColor =[UIColor clearColor];
    
    return vc;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 40;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0;
}

-(void)chooseSelect:(id)sender{
    
    UIButton *btn =(UIButton *)sender;
    
    NSInteger rowN =btn.tag%10000;
    NSInteger sectionN =(btn.tag-rowN)/10000;
    
    SurveyModel *suModel =[dataAry objectAtIndex:sectionN];
    
    OptionModel *model =[[[dataAry objectAtIndex:sectionN] optionAry] objectAtIndex:rowN];

    if ([suModel.can_multi integerValue] ==1) {
        if(model.selectBool){
            
            model.selectBool =NO;
        }else{
            
            model.selectBool =YES;
        }
    }else{
        
        [[[dataAry objectAtIndex:sectionN] optionAry] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            ((OptionModel *)obj).selectBool =NO;
        }];
        
        model.selectBool =YES;
        
    }
    
    [dataTableview reloadData];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
