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
#import "OrderComfirmModel.h"
#import "ShoppingOrderComfirmVC.h"
@interface ShoppingCartVC (){
    
    BOOL selsectBool;
    NSString *shopCartId;//购物车Id
    
    IBOutlet UIImageView *noOrderImg;
    
}

@property (weak, nonatomic) IBOutlet UITableView *shopCartTableView;
@property (strong, nonatomic) IBOutlet UIView *goToOrderView;
@property (weak, nonatomic) IBOutlet UIButton *xiaDanbtn;
@property (weak, nonatomic) IBOutlet UILabel *totocalPriceLab;
- (IBAction)goToOrderClick:(id)sender;

- (IBAction)selctAllClick:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *sleallbtn;

@property (weak, nonatomic) IBOutlet UIImageView *iconAllImage;



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
//    self.isNeedLoadMore=YES;
    self.page = 1;
//    
//    currentSortId = @"is_best";
//    currentMin_price = @"0";
//    currentMax_price = @"0";
//    currentKeyWords = @"";
//    currentCategoryId = @"";
//    currentOrdergoryId = @"";
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES];
    
    
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [NETWORK_ENGINE requestWithPath:[NSString stringWithFormat:@"/api/ec/flow.php?uid=%@",USERINFO.uid] Params:nil CompletionHandler:^(MKNetworkOperation *completedOperation) {
        NSDictionary *dic =[completedOperation responseDecodeToDic];
        NSLog(@"%@",dic);
        //        shopCartId =[[dic objectForKey:@"data"] objectForKey:@""];
        
        [self.dataArray removeAllObjects];
        [[[dic objectForKey:@"data"] objectForKey:@"goods_list"] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            [self.dataArray addObject:([shopCartListModel parseDicToShopCartListObject:obj])];
            totalPriceAll =totalPriceAll+[[obj objectForKey:@"goods_price"] floatValue];
        }];
        
        
        [self getSAllInfo];
        
        
    } ErrorHandler:^(MKNetworkOperation *completedOperation, NSError *error) {
        
        
    }];
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
//    [self.params removeAllObjects];
//    [self.params setObject:@"73" forKey:@"uid"];
    
    self.tableView.tableFooterView =[[UIView alloc]init];
    // Do any additional setup after loading the view from its nib.
}

#pragma mark - 下拉刷新
- (void)reloadTableViewDataSource
{
    
    if (self.isLoading) { return;}
    self.page = 1;
    [self getOrderListData];
    [super reloadTableViewDataSource];
    
}
-(void)getOrderListData{
    //根据订单状态得到订单列表
    //1处理中 2完成 3取消
    
    [NETWORK_ENGINE requestWithPath:[NSString stringWithFormat:@"/api/ec/flow.php?uid=%@",USERINFO.uid] Params:nil CompletionHandler:^(MKNetworkOperation *completedOperation){
        NSDictionary *dic =[completedOperation responseDecodeToDic];
        NSLog(@"%@",dic);
        
        if ([[[dic objectForKey:@"status"] objectForKey:@"statu"] isEqualToString:@"1"]) {
            

            if (self.page ==1) {
                [self.dataArray removeAllObjects];
                [[[dic objectForKey:@"data"] objectForKey:@"goods_list"] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                    [self.dataArray addObject:[shopCartListModel parseDicToShopCartListObject:obj]];
                }];
                
                
            }else{
                
                [[[dic objectForKey:@"data"] objectForKey:@"goods_list"] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                    [self.dataArray addObject:[shopCartListModel parseDicToShopCartListObject:obj]];
                }];
                
            }
            
            
            if (self.page <[[[dic objectForKey:@"result"] objectForKey:@"totalPages"] intValue]) {
                self.page ++;
                self.isNeedLoadMore =YES;
                self.footview.hidden=NO;
            }else if(self.page ==[[[dic objectForKey:@"result"] objectForKey:@"totalPages"] intValue]){
                
                self.isNeedLoadMore =NO;
                self.footview.hidden=YES;
            }
            
            [self.tableView reloadData];
            
        }else{
            self.isNeedLoadMore =NO;
            self.footview.hidden=YES;
        }
        
        [self getSAllInfo];
        [self doneLoadingTableViewData];
        [self.footview endRefreshing];
        
    } ErrorHandler:^(MKNetworkOperation *completedOperation, NSError *error) {
        
        [self doneLoadingTableViewData];
        [self.footview endRefreshing];
        self.isNeedLoadMore =NO;
        self.footview.hidden=YES;
        
    }];
}
- (void)doneLoadingTableViewData
{
    
    [super doneLoadingTableViewData];
    
}



/**
 *  删除购物车
 */
-(void)CanelCart{
    NSLog(@"删除");
  __block  NSString *tempIdString=@"";
    [self.dataArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if (((shopCartListModel *)obj).selectIndex ==1){
            //拼接要删的参数
            tempIdString =[tempIdString stringByAppendingString:((shopCartListModel *)obj).rec_id];
            if (idx<self.dataArray.count-1 && self.dataArray.count !=1) {
                tempIdString =[tempIdString stringByAppendingString:@","];
            }
        }
    }];
    if(tempIdString.length==0){
        [OMGToast showWithText:@"请选择要删除的商品"];
        return ;
    }
    
    [self.params removeAllObjects];
    [NETWORK_ENGINE requestWithPath:[NSString stringWithFormat:@"/api/ec/flow.php?uid=%@&id=%@&step=drop_goods",USERINFO.uid,tempIdString] Params:self.params CompletionHandler:^(MKNetworkOperation *completedOperation) {
        NSDictionary *dic =[completedOperation responseDecodeToDic];
        NSLog(@"%@",dic);

        if([[[dic objectForKey:@"status"] objectForKey:@"statu"] isEqualToString:@"1"]){
            [OMGToast showWithText:@"删除成功"];
            
            NSMutableArray *tempAry =[NSMutableArray arrayWithArray:self.dataArray];
            [tempAry enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                if (((shopCartListModel *)obj).selectIndex ==1){
                    
                    [self.dataArray removeObject:obj];
                    
                }
            }];


            [self getSAllInfo];
        }
        
        
        
    } ErrorHandler:^(MKNetworkOperation *completedOperation, NSError *error) {
        
        
    }];
    
    
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
    cell.selectBtnClick.tag =100+indexPath.section;
    [cell.selectBtnClick addTarget:self action:@selector(changeSelecrIndex:) forControlEvents:UIControlEventTouchUpInside];
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
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    return cell;
    
    
}
/**
 *  编辑购物车数量 增加
 *
 *  @param sender <#sender description#>
 */
-(void)addCount:(id)sender{
    UIButton *btn =(UIButton *)sender;
    [self.params removeAllObjects];
    shopCartListModel *tempModel =[self.dataArray objectAtIndex:btn.tag-2000];
    int temp =[tempModel.goods_number intValue];
    [self.params removeAllObjects];

    [self.params setObject:[NSString stringWithFormat:@"{\"%@\":\"%i\"}",tempModel.rec_id,temp+1] forKey:@"goods_number"];
    [NETWORK_ENGINE requestWithPath:[NSString stringWithFormat:@"/api/ec/flow.php?uid=%@&step=update_cart",USERINFO.uid]  Params:self.params CompletionHandler:^(MKNetworkOperation *completedOperation) {
        NSDictionary *dic =[completedOperation responseDecodeToDic];
        if ([[dic objectForKey:@"status"] objectForKey:@"statu"]) {
            
            tempModel.goods_number =[NSString stringWithFormat:@"%i",temp +1];
            [self.shopCartTableView reloadData];
            self.totocalPriceLab.text =[NSString stringWithFormat:@"%.2f",[self getTotalPrice]];
        }else{
            [OMGToast showWithText:@"添加失败"];
        }
        NSLog(@"%@",dic);
    } ErrorHandler:^(MKNetworkOperation *completedOperation, NSError *error) {
            [OMGToast showWithText:@"添加失败"];
    }];
 
   
    
    
}

/**
 *  减少数量
 *
 *  @param sender <#sender description#>
 */
-(void)plusCount:(id)sender{
    UIButton *btn =(UIButton *)sender;
    shopCartListModel *tempModel =[self.dataArray objectAtIndex:btn.tag-3000];
    int temp =[tempModel.goods_number intValue];
    if (temp ==1) {

        return;
    }
    [self.params removeAllObjects];
    [self.params setObject:[NSString stringWithFormat:@"{\"%@\":\"%i\"}",tempModel.rec_id,temp-1] forKey:@"goods_number"];
    
    
    [NETWORK_ENGINE requestWithPath:[NSString stringWithFormat:@"/api/ec/flow.php?uid=%@&step=update_cart",USERINFO.uid]  Params:self.params CompletionHandler:^(MKNetworkOperation *completedOperation) {
        NSDictionary *dic =[completedOperation responseDecodeToDic];
        if ([[dic objectForKey:@"status"] objectForKey:@"statu"]) {
            
            tempModel.goods_number =[NSString stringWithFormat:@"%i",temp -1];
            [self.shopCartTableView reloadData];
            self.totocalPriceLab.text =[NSString stringWithFormat:@"%.2f",[self getTotalPrice]];
        }else{
            [OMGToast showWithText:@"添加失败"];
        }
        NSLog(@"%@",dic);
    } ErrorHandler:^(MKNetworkOperation *completedOperation, NSError *error) {
        [OMGToast showWithText:@"添加失败"];
    }];
    
}

/**
 *  获得总价
 *
 *  @return <#return value description#>
 */
-(float)getTotalPrice{
   __block float price =0;
    [self.dataArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if (((shopCartListModel *)obj).selectIndex ==1) {
            price =price +[((shopCartListModel *)obj).goods_number floatValue]*[((shopCartListModel *)obj).goods_price floatValue];
        }
        
    }];
    
    return price;
}
/**
 *  复选
 *
 *  @param sender <#sender description#>
 */
-(void)changeSelecrIndex:(id)sender{
    
    UIButton *btn =(UIButton *)sender;
    shopCartListModel *tempModel =[self.dataArray objectAtIndex:btn.tag-100];
    if (tempModel.selectIndex ==1) {
        tempModel.selectIndex =0;
    }else{
        tempModel.selectIndex =1;
    }
    [self getSAllInfo];
    
}

-(void)getSAllInfo{
    __block int shoudelSele =0;
    [self.dataArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if(((shopCartListModel *)obj).selectIndex ==1){
            shoudelSele++;
        }
        
    }];
    
    if (shoudelSele ==self.dataArray.count&&shoudelSele !=0) {
        [self.iconAllImage setImage:[UIImage imageNamed:@"chose_yes_btn.png"]];
    }else {
        [self.iconAllImage setImage:[UIImage imageNamed:@"chose_no_btn.png"]];
    }
    
    if (self.dataArray.count ==0) {
        if (self.shopCartTableView.scrollEnabled ==YES) {
            [self.shopCartTableView addSubview:noOrderImg];


            self.shopCartTableView.scrollEnabled =NO;
        }
        
    }else{
        [noOrderImg removeFromSuperview];

        self.shopCartTableView.scrollEnabled =YES;
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
/**
 *  下单
 timing string 是否定时够
 buy_nums string 定时够的期数
 month string 定时够每期间隔多久
 integral string 使用多少积分来抵扣
 rec_ids string 选择下单的购物车ID 不传则默认全部 多个商品用逗号隔开
 postscript string 用户留言
 address_id string 收货地址ID
 payment string 支付方式ID 默认4 支付宝支付
 *
 
 
 data =     {
 "goods_list" =         (
 {
 "goods_attr" = "";
 "goods_id" = 5;
 "goods_name" = "\U7d22\U7231\U539f\U88c5M2\U5361\U8bfb\U5361\U5668";
 "goods_number" = 4;
 "goods_price" = "20.00";
 "goods_thumb" = "http://123.57.46.174/ec/images/200905/thumb_img/5_thumb_G_1241422518886.jpg";
 "is_real" = 1;
 "market_price" = "24.00";
 "rec_id" = 135;
 subtotal = "80.00";
 }
 );
 total =         {
 "allow_use_integral" = 1;
 consignee =             {
 consignee =                 {
 };
 "consignee_exist" = 0;
 };
 "goods_price" = "80.00";
 "market_price" = "96.00";
 "order_max_integral" = 0;
 "order_max_integral_str" = "\U53ef\U7528\U8212\U670d0\U79ef\U5206\U62b5\U62630\U5143";
 "order_reduce_moeny" = 0;
 "rec_ids" = 135;
 "save_rate" = "17%";
 saving = "16.00";
 "shipping_fee" = 15;
 "your_integral" = 0;
 };
 };
 status =     {
 msg = "api request success";
 statu = 1;
 };
 }

 

 */
- (IBAction)goToOrderClick:(id)sender {
    
//    [self.params removeAllObjects];
//    [self.params setObject:@"" forKey:@"timing"];
//    [self.params setObject:@"" forKey:@"buy_nums"];
//    [self.params setObject:@"" forKey:@"month"];
//    [self.params setObject:@"" forKey:@"integral"];
//    [self.params setObject:@"" forKey:@"rec_ids"];
//    [self.params setObject:@"" forKey:@"postscript"];
//    [self.params setObject:@"" forKey:@"address_id"];
//    [self.params setObject:@"" forKey:@"payment"];
//    
//    NSString *path = [NSString stringWithFormat:@"http://123.57.46.174/api/ec/flow.php?uid=%@&step=done",USERINFO.uid];
//    
//    [NETWORK_ENGINE requestWithPath:path Params:self.params CompletionHandler:^(MKNetworkOperation *completedOperation) {
//        
//        NSDictionary *dic=[completedOperation responseDecodeToDic];
//        
//        NSDictionary *statusDic = [dic objectForKey:@"status"];
//        
//        if ([@"1" isEqualToString:CHECK_VALUE([statusDic objectForKey:@"statu"])]) {
//            
//          
//        }
//        else{
//            
//            [SVProgressHUD showErrorWithStatus:CHECK_VALUE([statusDic objectForKey:@"msg"])];
//        }
//        
//        
//    } ErrorHandler:^(MKNetworkOperation *completedOperation, NSError *error) {
//        
//        [SVProgressHUD showErrorWithStatus:@"服务器忙，请稍候再试"];
//        
//    }];

    
    
    //遍历 找出需要支付的商品
    NSMutableArray *payShopAry =[NSMutableArray array];
    [self.dataArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if (((shopCartListModel *)obj).selectIndex ==1) {
            [payShopAry addObject:obj];
            
        }
    }];
    
    __block  NSString *tempIdString=@"";
    [payShopAry enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if (((shopCartListModel *)obj).selectIndex ==1){
            //拼接要删的参数
            tempIdString =[tempIdString stringByAppendingString:((shopCartListModel *)obj).rec_id];
            if (idx<payShopAry.count-1 && payShopAry.count !=1) {
                tempIdString =[tempIdString stringByAppendingString:@","];
            }
            
        }
    }];
    
    [self.params removeAllObjects];
    [self.params setObject:tempIdString forKey:@"rec_ids"];
    
    
    //payShopAry 就是用户选中的商品   都是 shopCartListModel 类型
    [NETWORK_ENGINE requestWithPath:[NSString stringWithFormat:@"/api/ec/flow.php?uid=%@&step=checkout&address_id=&type=1",USERINFO.uid]  Params:self.params CompletionHandler:^(MKNetworkOperation *completedOperation) {
        NSDictionary *dic =[completedOperation responseDecodeToDic];
        if ([[dic objectForKey:@"status"] objectForKey:@"statu"]) {
            
        }else{

        }
        NSLog(@"%@",dic);
    } ErrorHandler:^(MKNetworkOperation *completedOperation, NSError *error) {

    }];
    
    
    ShoppingOrderComfirmVC *vc =[[ShoppingOrderComfirmVC alloc] initWithNibName:@"ShoppingOrderComfirmVC" bundle:nil];

    vc.isFromCar =YES;
    vc.shopCarId =tempIdString;

    [self.navigationController pushViewController:vc animated:YES];
    
    
}

/**
 *  全选
 *
 *  @param sender <#sender description#>
 */
- (IBAction)selctAllClick:(id)sender {
    
        if (selsectBool ==NO) {
            [self.iconAllImage setImage:[UIImage imageNamed:@"chose_yes_btn.png"]];
        }else {
            [self.iconAllImage setImage:[UIImage imageNamed:@"chose_no_btn.png"]];
        }
    [self.dataArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        
        if (selsectBool ==NO) {
            ((shopCartListModel *)obj).selectIndex =1;
        }else{
            ((shopCartListModel *)obj).selectIndex =0;
        }
        
        
    }];

    selsectBool =!selsectBool;
    [self getSAllInfo];
    
}
@end
