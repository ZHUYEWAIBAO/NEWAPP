//
//  AddressEditVC.m
//  CMCCMall
//
//  Created by 朱 青 on 14-11-10.
//  Copyright (c) 2014年 cmcc. All rights reserved.
//

#import "AddressEditVC.h"
#import "AddressModel.h"

@implementation AddressDetailView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
    }
    return self;
}

- (void)awakeFromNib
{

    //底部加一条线
    UIImageView *bottomLineImgV = [[UIImageView alloc]initWithFrame:CGRectMake(0, self.frame.size.height - 0.5, self.frame.size.width, 0.5)];
    [bottomLineImgV setBackgroundColor:[UIColor colorWithRed:199.0/255.0 green:199.0/255.0 blue:204.0/255.0 alpha:1.0]];
    [self addSubview:bottomLineImgV];

}

@end


@interface AddressEditVC ()
{

    NSString *provinceStr;
    NSString *cityStr;
    NSString *areaStr;
    
    NSString *addressId;
    
    NSInteger provinceCurrentRow;
    NSInteger cityCurrentRow;
    NSInteger areaCurrentRow;
}

@end

@implementation AddressEditVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (self.changeModel.address_id.length > 0) {
    
        self.title = @"编辑收货地址";
        [self layOutTheAddress];
        
    }
    else{
        self.title = @"新建收货地址";
    }
    
    UIButton *rightButton=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
    [rightButton addTarget:self action:@selector(saveAddressAction:) forControlEvents:UIControlEventTouchUpInside];
    [rightButton setBackgroundImage:[UIImage imageWithContentFileName:@"Record_detail_sure_btn.png"] forState:UIControlStateNormal];
    UIBarButtonItem *rightButtonItem=[[UIBarButtonItem alloc]initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem = rightButtonItem;
    
    [self.contentScrollView setContentSize:CGSizeMake(SCREEN_SIZE.width, self.view.frame.size.height - 44)];
    
    self.detailTextView.placeholder = @"详细地址";


    self.addressTextField.inputView = self.cityPickerView;
    self.addressTextField.delegate = self;
    [self.addressTextField.inputView setBackgroundColor:RGBACOLOR(243, 240, 234, 1.0)];
    
    provinceCurrentRow = 0;
    cityCurrentRow = 0;
    areaCurrentRow = 0;
    
    //默认值
    provinceStr = @"北京";
    cityStr = @"北京";
    areaStr = @"东城区";
    
    _provinceArray = [[NSMutableArray alloc]initWithCapacity:0];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSString *jsonTxtPath = [[NSBundle mainBundle] pathForResource:@"region" ofType:@"json"];
        NSString *string = [NSString stringWithContentsOfFile:jsonTxtPath encoding:NSUTF8StringEncoding error:nil];
        
        NSDictionary *chinaDic = [NSJSONSerialization JSONObjectWithData:[string dataUsingEncoding:NSUTF8StringEncoding] options:0 error:nil];
        
        for (NSDictionary *proDic in CHECK_ARRAY_VALUE([chinaDic objectForKey:@"region_child"])) {
            AddressModel *model = [AddressModel parseDicToAddressProvinceObject:proDic];
            [_provinceArray addObject:model];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
          
            [self.cityPickerView reloadAllComponents];
        });
        
        
    });

}

- (void)layOutTheAddress
{
    self.nameTextField.text = self.changeModel.consignee;
    self.numberTextField.text = self.changeModel.mobile;
    self.codeTextField.text = self.changeModel.zipcode;
    self.detailTextView.text = self.changeModel.address;
    self.addressTextField.text = [NSString stringWithFormat:@"%@%@%@",self.changeModel.province_name,self.changeModel.city_name,self.changeModel.county_name];

    
}

#pragma mark 保存收获地址
- (void)saveAddressAction:(id)sender
{
    [self.params removeAllObjects];

    if (self.changeModel.address_id.length > 0) {
        [self.params setObject:CHECK_VALUE(self.changeModel.address_id) forKey:@"address_id"];
    }
    
    if([self.nameTextField.text isEqualToString:@""]){

        [SVProgressHUD showErrorWithStatus:@"请填写收货人姓名"];
        return;
    }
    else{
        [self.params setObject:CHECK_VALUE(self.nameTextField.text) forKey:@"consignee"];//名字
    }
    
    if(self.numberTextField.text.length!=11){
 
        [SVProgressHUD showErrorWithStatus:@"请填写11位手机号码"];
        return;
    }
    else{
        [self.params setObject:CHECK_VALUE(self.numberTextField.text) forKey:@"mobile"];//电话
    }
 
    if (self.addressTextField.text.length == 0) {

        [SVProgressHUD showErrorWithStatus:@"未选择省、市、地"];
        return;
        
    }
    
    [self.params setObject:CHECK_VALUE([[_provinceArray objectAtIndex:provinceCurrentRow]province_Id]) forKey:@"province"];
    [self.params setObject:CHECK_VALUE([[[[_provinceArray objectAtIndex:provinceCurrentRow] cityArray] objectAtIndex:cityCurrentRow]city_Id]) forKey:@"city"];
    [self.params setObject:CHECK_VALUE([[[[[[_provinceArray objectAtIndex:provinceCurrentRow] cityArray] objectAtIndex:cityCurrentRow]areaArray]objectAtIndex:areaCurrentRow]area_Id]) forKey:@"district"];

    if([self.detailTextView.text isEqualToString:@""]){
 
        [SVProgressHUD showErrorWithStatus:@"请填写详细地址"];
        return;
    }
    else{
        [self.params setObject:CHECK_VALUE(self.detailTextView.text) forKey:@"address"];//地址信息
    }
    
    if(self.codeTextField.text.length!=6){
   
        [SVProgressHUD showErrorWithStatus:@"请填写6位邮编"];
        return;
    }
    else{
        [self.params setObject:CHECK_VALUE(self.codeTextField.text) forKey:@"zipcode"];//邮编
    }

    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];
    
    [NETWORK_ENGINE requestWithPath:[NSString stringWithFormat:@"/api/ec/user.php?mod=act_edit_address&uid=%@",USERINFO.uid] Params:self.params CompletionHandler:^(MKNetworkOperation *completedOperation) {
        
        [SVProgressHUD dismiss];
        
        NSDictionary *dic=[completedOperation responseDecodeToDic];
        
        NSDictionary *statusDic = [dic objectForKey:@"status"];
        
        if ([@"1" isEqualToString:CHECK_VALUE([statusDic objectForKey:@"statu"])]) {
            
            [SVProgressHUD showSuccessWithStatus:@"保存成功"];
            
            [self performSelector:@selector(backToAddressList) withObject:nil afterDelay:1.0f];
            
            
        }
        else{
            [SVProgressHUD showErrorWithStatus:CHECK_VALUE([statusDic objectForKey:@"msg"])];
        }
        
    } ErrorHandler:^(MKNetworkOperation *completedOperation, NSError *error) {
        
        [SVProgressHUD showErrorWithStatus:@"服务器忙，请稍候再试"];
    }];

}

- (void)backToAddressList
{
    
    [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFICATION_ADDRESS_REQUEST object:nil];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark UIPickerViewDelegate
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 3;
}

- (NSInteger) pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    
    switch (component) {
        case 0:{
            return [_provinceArray count];
        }
            break;
        
        case 1:{
            return [[[_provinceArray objectAtIndex:provinceCurrentRow] cityArray] count];
        }
            break;
            
        case 2:{
            return [[[[[_provinceArray objectAtIndex:provinceCurrentRow] cityArray] objectAtIndex:cityCurrentRow]areaArray] count];
        }
            break;
            
        default:
            break;
    }
    return 0;
}

- (NSString *) pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    
    switch (component) {
        case 0:{
            return [[_provinceArray objectAtIndex:row] province_Name];
        }
            break;
            
        case 1:{
            return [[[[_provinceArray objectAtIndex:provinceCurrentRow] cityArray] objectAtIndex:row] city_Name];
        }
            break;
            
        case 2:{
            return [[[[[[_provinceArray objectAtIndex:provinceCurrentRow] cityArray] objectAtIndex:cityCurrentRow]areaArray]objectAtIndex:row]area_Name];
        }
            break;
            
        default:
            break;
    }
    return @"";
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {

    switch (component) {
        case 0:{

            //市和区返回第一行
            [self.cityPickerView selectRow:0 inComponent:1 animated:NO];
            [self.cityPickerView selectRow:0 inComponent:2 animated:NO];
            
            provinceStr = [[_provinceArray objectAtIndex:row] province_Name];
            cityStr = [[[[_provinceArray objectAtIndex:row]cityArray] objectAtIndex:0] city_Name];
            areaStr = [[[[[[_provinceArray objectAtIndex:row]cityArray] objectAtIndex:0] areaArray]objectAtIndex:0]area_Name];
            
            provinceCurrentRow = row;
            cityCurrentRow = 0;
            areaCurrentRow = 0;
            
            [self.cityPickerView reloadAllComponents];
        }
            break;
            
        case 1:{

            //区返回第一行
            [self.cityPickerView selectRow:0 inComponent:2 animated:NO];
            
            cityStr = [[[[_provinceArray objectAtIndex:provinceCurrentRow]cityArray] objectAtIndex:row] city_Name];
            areaStr = [[[[[[_provinceArray objectAtIndex:provinceCurrentRow]cityArray] objectAtIndex:row] areaArray]objectAtIndex:0]area_Name];
            
            cityCurrentRow = row;
            areaCurrentRow = 0;
            
            [self.cityPickerView reloadAllComponents];
            
        }
            break;
            
        case 2:{
            areaStr = [[[[[[_provinceArray objectAtIndex:provinceCurrentRow]cityArray] objectAtIndex:cityCurrentRow] areaArray]objectAtIndex:row]area_Name];
            areaCurrentRow = row;

        }
            break;
            
        default:
            break;
    }
    
    [self.addressTextField setText:[NSString stringWithFormat:@"%@%@%@",provinceStr,cityStr,areaStr]];
}

#pragma mark UITextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (textField == self.addressTextField) {
        if (_provinceArray.count > 0) {
            [self.addressTextField setText:[NSString stringWithFormat:@"%@%@%@",provinceStr,cityStr,areaStr]];
        }

        
    }
    return YES;
}

#pragma mark --UITextFiled的观察者方法
- (void)textFiledEditChanged:(NSNotification *)obj
{
    UITextField *textField = (UITextField *)obj.object;
    
    NSString *toBeString = textField.text;
    
    if (textField == self.numberTextField) {
        //这里默认是最多输入11位
        if (toBeString.length >= 11){
            textField.text = [toBeString substringToIndex:11];
        }
        
    }
    else if (textField == self.codeTextField) {
        if (toBeString.length >= 6) {
            
            textField.text = [toBeString substringToIndex:6];
        }
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
