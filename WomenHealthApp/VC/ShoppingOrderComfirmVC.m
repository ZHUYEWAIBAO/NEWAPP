//
//  ShoppingOrderComfirmVC.m
//  WomenHealthApp
//
//  Created by 朱青 on 14/12/12.
//  Copyright (c) 2014年 WomenHealthApp. All rights reserved.
//

#import "ShoppingOrderComfirmVC.h"
#import "AddressViewController.h"
#import "ShoppingDetailVC.h"
#import "ShoppingOrderSuccessVC.h"
#import "ShoppingPaySuccessVC.h"
#import "PayTypeChooseVC.h"
#import "OrderGoodsCell.h"
#import "OrderSuccessModel.h"

@interface ShoppingOrderComfirmVC ()
{
    NSString  *currentType;
    NSString  *currentAddressId;
    
    NSString *currentPayTypeId;
    
    NSString *isUseTimeBuy;
    
    float totalPrice;
}

@end

@implementation ShoppingOrderComfirmVC

- (void)loadView
{
    [super loadView];
    
    self.title = @"订单确认";
    
    currentAddressId = @"";
    if (_isFromCar) {
        currentType = @"1";
        
    }
    else{
        currentType = @"2";
    }
    isUseTimeBuy = @"0";
    currentPayTypeId = @"4";
    
    totalPrice = 0.00;//默认
  
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(selectTheAddressAction:) name:NOTIFICATION_ADDRESS_SELECT object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(selectThePayTypeAction:) name:NOTIFICATION_PAYTYPE_SELECT object:nil];
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyboardHide)];
    //设置成NO表示当前控件响应后会传播到其他控件上，默认为YES。
    tapGestureRecognizer.cancelsTouchesInView = NO;
    //将触摸事件添加到当前view
    [self.layOutView addGestureRecognizer:tapGestureRecognizer];
    
    self.speakTextView.placeholder = @"给卖家留言";
    [self setViewLayer:self.speakTextView andCornerRadius:0 andBorderColor:[UIColor lightGrayColor] andBorderWidth:0.6f];
    
    [self setViewLayer:self.monthsTextField andCornerRadius:0 andBorderColor:[UIColor lightGrayColor] andBorderWidth:0.6f];
    [self setViewLayer:self.numTextField andCornerRadius:0 andBorderColor:[UIColor lightGrayColor] andBorderWidth:0.6f];
    
    [self getTheOrderInfo:self.jsonString];
}

- (void)selectTheAddressAction:(NSNotification *)notifi
{
    currentType = @"1";
    currentAddressId = notifi.object;
    
    [self getTheOrderInfo:self.jsonString];
    
}


- (void)selectThePayTypeAction:(NSNotification *)notifi
{
    currentPayTypeId = notifi.object;
    
    if ([@"4" isEqualToString:currentPayTypeId]) {
        self.payTypeLabel.text = @"支付宝支付";
        
    }
    else{
        self.payTypeLabel.text = @"微信支付";
    }
}

- (void)getTheOrderInfo:(NSString *)string
{
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];
    
    [self.params removeAllObjects];
    
    if ([@"2" isEqualToString:currentType]) {
        [self.params setObject:CHECK_VALUE(string) forKey:@"goods"];
    }
    else{
        [self.params setObject:CHECK_VALUE(self.shopCarId) forKey:@"rec_ids"];
    }
    NSString *path = [NSString stringWithFormat:@"/api/ec/flow.php?uid=%@&step=checkout&address_id=%@&type=%@",USERINFO.uid,currentAddressId,currentType];
    
    [NETWORK_ENGINE requestWithPath:path Params:self.params CompletionHandler:^(MKNetworkOperation *completedOperation) {
        
        NSDictionary *dic=[completedOperation responseDecodeToDic];
        
        NSDictionary *statusDic = [dic objectForKey:@"status"];
        
        if ([@"1" isEqualToString:CHECK_VALUE([statusDic objectForKey:@"statu"])]) {
         
            OrderComfirmModel *model = [OrderComfirmModel parseDicToOrderComfirmObject:[dic objectForKey:@"data"]];
            self.comfirmModel = model;
            
            self.shopCarId = model.rec_ids;
            NSMutableArray *array;
//            if ([[[[dic objectForKey:@"total"] objectForKey:@"user_near_order"] objectForKey:@"order_id"] floatValue]>0) {
                /*
                "user_near_order" =             {
                    "order_id" = 0;
                    "order_sn" = 0;
                    "shipping_time" = 0;
                };
                */

                array = [[NSMutableArray alloc]initWithObjects:_addressView,_payTypeView,_scoreView,_goodsTableView,_speakView,_dingQiGouView,_timeView, nil];
                self.dingQiLabel.text =[NSString stringWithFormat:@"您最近一期定期购订单:%@即将于%@发货,请选择是否要跟随此订单一起发货,以节省本次运费：",[[[[dic objectForKey:@"data"] objectForKey:@"total"] objectForKey:@"user_near_order"] objectForKey:@"order_sn"],[[[[dic objectForKey:@"data"] objectForKey:@"total"] objectForKey:@"user_near_order"] objectForKey:@"shipping_time"]];
//            }else{
//                array = [[NSMutableArray alloc]initWithObjects:_addressView,_payTypeView,_scoreView,_goodsTableView,_speakView,_timeView, nil];
//            }
            

            if (![@"1" isEqualToString:model.allow_use_integral]) {
                [array removeObject:_scoreView];
            }
            
            [self layOutMainView:array];
            [SVProgressHUD dismiss];
        }
        else{
            
            [SVProgressHUD showErrorWithStatus:CHECK_VALUE([statusDic objectForKey:@"msg"])];
        }
        
        
    } ErrorHandler:^(MKNetworkOperation *completedOperation, NSError *error) {
        
        [SVProgressHUD showErrorWithStatus:@"服务器忙，请稍候再试"];
        
    }];
    
}
/**
 *  是否选择最近一次定期购订单
 *
 *  @param sender <#sender description#>
 */
- (IBAction)choseDingQiClick:(id)sender {
    UIButton *btn =(UIButton *)sender;
    if (btn.selected) {
        self.choseDingQiImg.image =[UIImage imageNamed:@"chose_no_btn"];
        self.choseDingQiLabel.text =@"否";
    }else{
        self.choseDingQiImg.image =[UIImage imageNamed:@"chose_yes_btn"];
        self.choseDingQiLabel.text =@"是";
    }
    
    btn.selected =!btn.selected;
    
}


//布局整体页面
-(void)layOutMainView:(NSMutableArray *)viewArr
{
    [_layOutView removeAllItems];
    
    [self layOutAddressView];
    [self layOutPayTyeView];
    [self layOutTheScoreView];
    [self layOutTheTableView];
    
    self.totalTitleLabel.text = [NSString stringWithFormat:@"合计(含运费%@元):",self.comfirmModel.shipping_fee];
    totalPrice = [self.comfirmModel.goods_price floatValue] + [self.comfirmModel.shipping_fee floatValue];
    self.totalPriceLabel.text = [NSString priceStringWithOneFloat:[NSString stringWithFormat:@"%.2f",totalPrice]];
    
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

- (void)layOutAddressView
{
    if ([@"1" isEqualToString:self.comfirmModel.consignee_exist]) {
        [self.noneLabel setHidden:YES];
        self.addressLabel.text = self.comfirmModel.address;
        self.phoneLabel.text = self.comfirmModel.mobile;
        self.nameLabel.text = self.comfirmModel.consignee;
    }
    else{
        [self.noneLabel setHidden:NO];
    }
}

- (IBAction)pushToAddressListAction:(id)sender
{
    AddressViewController *vc = [[AddressViewController alloc]initWithNibName:@"AddressViewController" bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
}


- (void)layOutPayTyeView
{
    if ([@"4" isEqualToString:currentPayTypeId]) {
        self.payTypeLabel.text = @"支付宝支付";
        
    }
    else{
        self.payTypeLabel.text = @"微信支付";
    }
}

- (IBAction)payTypeChooseAction:(id)sender
{
    PayTypeChooseVC *vc = [[PayTypeChooseVC alloc]initWithNibName:@"PayTypeChooseVC" bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)layOutTheScoreView
{

    self.scoreLabel.text = self.comfirmModel.order_max_integral_str;

}

- (IBAction)scoreSwitchChangeAction:(id)sender
{
    UISwitch *swit = (UISwitch *)sender;
   
    if (swit.on) {
        totalPrice = [self.comfirmModel.goods_price floatValue] + [self.comfirmModel.shipping_fee floatValue] - [self.comfirmModel.order_reduce_moeny floatValue];
    }
    else{
        totalPrice = [self.comfirmModel.goods_price floatValue] + [self.comfirmModel.shipping_fee floatValue];
    }
    self.totalPriceLabel.text = [NSString priceStringWithOneFloat:[NSString stringWithFormat:@"%.2f",totalPrice]];
}

- (void)layOutTheTableView
{
    NSArray *nibArr = [[NSBundle mainBundle] loadNibNamed:@"OrderGoodsCell" owner:self options:nil];
    OrderGoodsCell *cell = [nibArr objectAtIndex:0];
    
    CGRect rect = self.goodsTableView.frame;
    rect.size.height = cell.frame.size.height * self.comfirmModel.goodListArray.count;
    self.goodsTableView.frame = rect;
    
    [self.goodsTableView reloadData];
    
}

#pragma mark UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return self.comfirmModel.goodListArray.count;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *nibArr = [[NSBundle mainBundle] loadNibNamed:@"OrderGoodsCell" owner:self options:nil];
    OrderGoodsCell *cell = [nibArr objectAtIndex:0];
    
    return cell.frame.size.height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    OrderGoodsCell *cell = [tableView dequeueReusableCellWithIdentifier:[OrderGoodsCell cellIdentifier]];
    if (cell == nil){
        
        NSArray *nibArr = [[NSBundle mainBundle] loadNibNamed:@"OrderGoodsCell" owner:self options:nil];
        cell = [nibArr objectAtIndex:0];
        
    }
    
    OrderListModel *model = [self.comfirmModel.goodListArray objectAtIndex:indexPath.row];
    cell.nameLabel.text = model.goods_name;
    cell.numLabel.text = [NSString stringWithFormat:@"数量:%@",model.goods_number];
    cell.attrTypeLabel.text = model.goods_attr;
    cell.priceLabel.text = [NSString priceStringWithOneFloat:model.goods_price];
    
    [cell.goodsImageView setImageWithURL:[NSURL URLWithString:model.goods_thumb]];
    
    return cell;
    
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    ShoppingDetailVC *vc = [[ShoppingDetailVC alloc]initWithNibName:@"ShoppingDetailVC" bundle:nil];
    
    vc.goodsId = [[self.comfirmModel.goodListArray objectAtIndex:indexPath.row]goods_id];
    
    [self.navigationController pushViewController:vc animated:YES];
}

//是否使用定时购
- (IBAction)useTimePayAction:(id)sender
{
    UISwitch *swit = (UISwitch *)sender;
    if (swit.on) {
        isUseTimeBuy = @"1";
        self.monthsTextField.enabled = YES;
        self.numTextField.enabled = YES;
    }
    else{
        isUseTimeBuy = @"0";
        self.monthsTextField.enabled = NO;
        self.numTextField.enabled = NO;
    }
}

//下单
- (IBAction)comfirmToGetTheOrder:(id)sender
{
    
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];
    
    [self.params removeAllObjects];
    [self.params setObject:CHECK_VALUE(isUseTimeBuy) forKey:@"timing"];
    [self.params setObject:CHECK_VALUE(self.numTextField.text) forKey:@"buy_nums"];
    [self.params setObject:CHECK_VALUE(self.monthsTextField.text) forKey:@"month"];
    [self.params setObject:CHECK_VALUE(self.comfirmModel.rec_ids) forKey:@"rec_ids"];
    [self.params setObject:CHECK_VALUE(self.speakTextView.text) forKey:@"postscript"];
    [self.params setObject:CHECK_VALUE(self.comfirmModel.address_id) forKey:@"address_id"];
    [self.params setObject:CHECK_VALUE(currentPayTypeId) forKey:@"payment"];
    
    if (self.scoreSwitch.on && [@"1" isEqualToString:self.comfirmModel.allow_use_integral]) {

        [self.params setObject:CHECK_VALUE(self.comfirmModel.order_max_integral) forKey:@"integral"];

    }
    else{
        [self.params setObject:@"0" forKey:@"integral"];
    }
    
    NSString *path = [NSString stringWithFormat:@"/api/ec/flow.php?uid=%@&step=done",USERINFO.uid];
    
    [NETWORK_ENGINE requestWithPath:path Params:self.params CompletionHandler:^(MKNetworkOperation *completedOperation) {
        
        NSDictionary *dic=[completedOperation responseDecodeToDic];
        
        NSDictionary *statusDic = [dic objectForKey:@"status"];
        
        if ([@"1" isEqualToString:CHECK_VALUE([statusDic objectForKey:@"statu"])]) {
            
            if (totalPrice > 0) {
                
                OrderSuccessModel *model = [OrderSuccessModel parseDicToOrderSuccessObject:[dic objectForKey:@"data"]];
                
                ShoppingOrderSuccessVC *vc = [[ShoppingOrderSuccessVC alloc]initWithNibName:@"ShoppingOrderSuccessVC" bundle:nil];
                vc.successModel = model;
                vc.payTypeId = currentPayTypeId;
                [self.navigationController pushViewController:vc animated:YES];
                
                
            }
            else{

                ShoppingPaySuccessVC *vc = [[ShoppingPaySuccessVC alloc]initWithNibName:@"ShoppingPaySuccessVC" bundle:nil];
                [self.navigationController pushViewController:vc animated:YES];
            }

            
            [SVProgressHUD dismiss];
            
        }
        else{
            
            [SVProgressHUD showErrorWithStatus:CHECK_VALUE([statusDic objectForKey:@"msg"])];
        }
        
        
    } ErrorHandler:^(MKNetworkOperation *completedOperation, NSError *error) {
        
        [SVProgressHUD showErrorWithStatus:@"服务器忙，请稍候再试"];
        
    }];

}

#pragma mark - UITextFiledDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (self.numTextField ==textField) {
        
        [[[UIApplication sharedApplication] keyWindow] addSubview:self.changeDingQiTwoView];
        self.changeDingQiTwoView.center =CGPointMake(self.view.center.x, SCREEN_SIZE.height-75);
        [self.choseDingQiTableview reloadData];
        [self animateTextField:150 up: YES];
        return ;
    }else{
        [self animateTextField:150 up: YES];
    }

    
}

- (IBAction)showListClick:(id)sender {
    
    [[[UIApplication sharedApplication] keyWindow] addSubview:self.changeDingQiTwoView];
    self.changeDingQiTwoView.center =CGPointMake(self.view.center.x, SCREEN_SIZE.height-75);
    [self.choseDingQiTableview reloadData];
    [self animateTextField:150 up: YES];
    
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    
    if (self.numTextField ==textField) {
        return NO;
    }else{
        return YES;
    }
    
}
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [self animateTextField:150 up: NO];
 
    
}
#pragma mark - UITextViewDelegate
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    [self animateTextField:150 up: YES];
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    [self animateTextField:150 up: NO];
}
//键盘弹出或落下时，调整self.view的高度
- (void) animateTextField: (NSInteger)height up: (BOOL) up
{
    const NSInteger movementDistance = height; // tweak as needed
    
    const float movementDuration = 0.2f; // tweak as needed
    
    NSInteger movement = (up ? -movementDistance : movementDistance);
    
    
    [UIView beginAnimations: @"anim" context: nil];
    
    [UIView setAnimationBeginsFromCurrentState: YES];
    
    [UIView setAnimationDuration: movementDuration];
    
    self.view.frame = CGRectOffset(self.view.frame, 0, movement);
    
    [UIView commitAnimations];
    
}

- (void)keyboardHide
{
    [self.numTextField resignFirstResponder];
    [self.monthsTextField resignFirstResponder];
    [self.speakTextView resignFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
