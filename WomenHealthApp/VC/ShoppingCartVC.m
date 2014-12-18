//
//  ShoppingCartVC.m
//  WomenHealthApp
//
//  Created by Daniel on 14/12/9.
//  Copyright (c) 2014年 WomenHealthApp. All rights reserved.
//
#import "ShoppingCartVC.h"
#import "ShopCartTabCell.h"
#import "shopCartListModel.h"
@interface ShoppingCartVC (){
    
    BOOL selsectBool;
}

@property (weak, nonatomic) IBOutlet UITableView *shopCartTableView;
@property (strong, nonatomic) IBOutlet UIView *goToOrderView;
@property (weak, nonatomic) IBOutlet UIButton *xiaDanbtn;
@property (weak, nonatomic) IBOutlet UILabel *totocalPriceLab;
- (IBAction)goToOrderClick:(id)sender;

- (IBAction)selctAllClick:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *sleallbtn;


@end

@implementation ShoppingCartVC{
    float totalPriceAll;
    
    
    

}
- (void)loadView
{
    [super loadView];
    
    self.xiaDanbtn.layer.masksToBounds =YES;
    self.xiaDanbtn.layer.cornerRadius =5.0f;
    
    //允许下拉刷新
    self.tableView = self.shopCartTableView;
    
    //允许上拉分页加载
    self.isNeedLoadMore=YES;
    self.page = 1;
//    
//    currentSortId = @"is_best";
//    currentMin_price = @"0";
//    currentMax_price = @"0";
//    currentKeyWords = @"";
//    currentCategoryId = @"";
//    currentOrdergoryId = @"";
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title =@"购物车";
     self.dataArray =[NSMutableArray array];
    //添加分享按钮
    UIButton *rightButton=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
    [rightButton addTarget:self action:@selector(CanelCart) forControlEvents:UIControlEventTouchUpInside];
    [rightButton setBackgroundImage:[UIImage imageWithContentFileName:@"cancel_btn"] forState:UIControlStateNormal];
    UIBarButtonItem *rightButtonItem=[[UIBarButtonItem alloc]initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem = rightButtonItem;
    [self.params removeAllObjects];
    [self.params setObject:@"73" forKey:@"uid"];
    [NETWORK_ENGINE requestWithPath:@"/api/ec/flow.php?uid=73" Params:self.params CompletionHandler:^(MKNetworkOperation *completedOperation) {
        NSDictionary *dic =[completedOperation responseDecodeToDic];
        NSLog(@"%@",dic);
        
        [[[dic objectForKey:@"data"] objectForKey:@"goods_list"] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            [self.dataArray addObject:([shopCartListModel parseDicToShopCartListObject:obj])];
            totalPriceAll =totalPriceAll+[[obj objectForKey:@"goods_price"] floatValue];
        }];
        self.totocalPriceLab.text =[NSString stringWithFormat:@"%.2f",[self getTotalPrice]];
        [self.shopCartTableView reloadData];
        
        
    } ErrorHandler:^(MKNetworkOperation *completedOperation, NSError *error) {
        
        
    }];
    
    // Do any additional setup after loading the view from its nib.
}


-(void)CanelCart{
    NSLog(@"删除");
    
}

#pragma mark UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//    if (section==0) {
//        return 1;
//    }else if(section ==1){
//        return 2;
//    }else if(section ==2){
//        return 3;
//    }else{
//        return 4;
//    }
//
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *nibArr = [[NSBundle mainBundle] loadNibNamed:@"ShopCartTabCell" owner:self options:nil];
    ShopCartTabCell *cell = [nibArr objectAtIndex:0];
    
    return cell.frame.size.height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    ShopCartTabCell *cell = [tableView dequeueReusableCellWithIdentifier:[ShopCartTabCell cellIdentifier]];
    if (cell == nil){
        
        NSArray *nibArr = [[NSBundle mainBundle] loadNibNamed:@"ShopCartTabCell" owner:self options:nil];
        cell = [nibArr objectAtIndex:0];
        
    }
    cell.selectGouBtn.tag =100+indexPath.section;
    [cell.selectGouBtn addTarget:self action:@selector(changeSelecrIndex:) forControlEvents:UIControlEventTouchUpInside];
    shopCartListModel *tempModel =[self.dataArray objectAtIndex:indexPath.section];
    cell.shopNameLab.text =[tempModel goods_name];
    cell.shopCountLab.text =[NSString stringWithFormat:@"数量:%@",[tempModel goods_number]];
    cell.xiaoJiNumber.text =tempModel.goods_number;
    
    cell.xiaoJiMoneyLab.text =[NSString stringWithFormat:@"%.2f",[[tempModel goods_number] intValue]*[[tempModel goods_price] floatValue]];
    cell.colorTypeLab.text =[tempModel goods_attr];
    if (tempModel.selectIndex ==1) {
        [cell.selectGouBtn setBackgroundImage:[UIImage imageNamed:@"chose_yes_btn.png"] forState:UIControlStateNormal];
    }else {
        [cell.selectGouBtn setBackgroundImage:[UIImage imageNamed:@"chose_no_btn.png"] forState:UIControlStateNormal];
    }
    [cell.addBtnv addTarget:self action:@selector(addCount:) forControlEvents:UIControlEventTouchUpInside];
    cell.addBtnv.tag =2000+indexPath.section;
    [cell.plusBtnv addTarget:self action:@selector(plusCount:) forControlEvents:UIControlEventTouchUpInside];
    cell.plusBtnv.tag =3000+indexPath.section;
    
    [cell.shopImageView setImageWithURL:[NSURL URLWithString:tempModel.goods_thumb ] placeholderImage:[UIImage imageNamed:@""]];
    
    
    return cell;
    
    
}
-(void)addCount:(id)sender{
    UIButton *btn =(UIButton *)sender;
    shopCartListModel *tempModel =[self.dataArray objectAtIndex:btn.tag-2000];
    int temp =[tempModel.goods_number intValue];
    tempModel.goods_number =[NSString stringWithFormat:@"%i",temp +1];
    [self.shopCartTableView reloadData];
  self.totocalPriceLab.text =[NSString stringWithFormat:@"%.2f",[self getTotalPrice]];
    
    
}
-(void)plusCount:(id)sender{
    UIButton *btn =(UIButton *)sender;
    shopCartListModel *tempModel =[self.dataArray objectAtIndex:btn.tag-3000];
    int temp =[tempModel.goods_number intValue];
    tempModel.goods_number =[NSString stringWithFormat:@"%i",temp -1];
    [self.shopCartTableView reloadData];
    
    self.totocalPriceLab.text =[NSString stringWithFormat:@"%.2f",[self getTotalPrice]];
}

-(float)getTotalPrice{
   __block float price =0;
    [self.dataArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if (((shopCartListModel *)obj).selectIndex ==1) {
            price =price +[((shopCartListModel *)obj).goods_number floatValue]*[((shopCartListModel *)obj).goods_price floatValue];
        }
        
    }];
    
    return price;
}
-(void)changeSelecrIndex:(id)sender{
    
    UIButton *btn =(UIButton *)sender;
    shopCartListModel *tempModel =[self.dataArray objectAtIndex:btn.tag-100];
    if (tempModel.selectIndex ==1) {
        tempModel.selectIndex =0;
    }else{
        tempModel.selectIndex =1;
    }
    
    
    [self.shopCartTableView reloadData];
    self.totocalPriceLab.text =[NSString stringWithFormat:@"%.2f",[self getTotalPrice]];
    
}
//- (UITableViewHeaderFooterView *)headerViewForSection:(NSInteger)section NS_AVAILABLE_IOS(6_0){
//    if(section ==0){
//        UITableViewHeaderFooterView *vc =[[UITableViewHeaderFooterView alloc] initWithFrame:CGRectMake(0, 0, 320, 40)];
//        vc.backgroundColor =[UIColor redColor];
//        return vc;
//    }else{
//        return nil;
//    }
//    
//}

//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
//
//    UIView *vc =[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 40)];
//    UIButton *btn =[[UIButton alloc] initWithFrame:CGRectMake(10, 12, 17 , 17)];
//    [btn setBackgroundImage:[UIImage imageWithContentFileName:@"chose_no_btn"] forState:UIControlStateNormal];
//    [btn addTarget:self action:@selector(chooseSelect:) forControlEvents:UIControlEventTouchUpInside];
//    [vc addSubview:btn];
//    
//    UILabel *laber =[[UILabel alloc] initWithFrame:CGRectMake(32, 10, 265, 20)];
//    laber.text =@"韩都衣舍旗舰店";
//    [vc addSubview:laber];
//    vc.backgroundColor =[UIColor whiteColor];
//    return vc;
//    
//    
//}
-(void)chooseSelect:(id)sender{
    NSLog(@"sssss");
  UIButton *tempBtn = (UIButton *)sender;
    [tempBtn setBackgroundImage:[UIImage imageWithContentFileName:@"chose_yes_btn"] forState:UIControlStateNormal];
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 20;
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

- (IBAction)goToOrderClick:(id)sender {
}

- (IBAction)selctAllClick:(id)sender {
    
        if (selsectBool ==NO) {
            [_sleallbtn setBackgroundImage:[UIImage imageNamed:@"chose_yes_btn.png"] forState:UIControlStateNormal];
        }else {
            [_sleallbtn setBackgroundImage:[UIImage imageNamed:@"chose_no_btn.png"] forState:UIControlStateNormal];
        }
    [self.dataArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        
        if (selsectBool ==NO) {
            ((shopCartListModel *)obj).selectIndex =1;
        }else{
            ((shopCartListModel *)obj).selectIndex =0;
        }
        
        
    }];

    selsectBool =!selsectBool;
    [self.shopCartTableView reloadData];
    self.totocalPriceLab.text =[NSString stringWithFormat:@"%.2f",[self getTotalPrice]];
    
}
@end
