//
//  AddressEditVC.h
//  CMCCMall
//
//  Created by 朱 青 on 14-11-10.
//  Copyright (c) 2014年 cmcc. All rights reserved.
//

#import "BasicVC.h"
#import "UIPlaceHolderTextView.h"
#import "AddressListModel.h"

@interface AddressDetailView : UIView

@end

@interface AddressEditVC : BasicVC<UIPickerViewDelegate,UIPickerViewDataSource,UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *contentScrollView;

@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *numberTextField;
@property (weak, nonatomic) IBOutlet UITextField *codeTextField;
@property (weak, nonatomic) IBOutlet UITextField *addressTextField;

/**
 *  填写详细地址的textview
 */
@property (weak, nonatomic) IBOutlet UIPlaceHolderTextView *detailTextView;

@property (strong, nonatomic) IBOutlet UIPickerView *cityPickerView;

@property (strong, nonatomic) NSMutableArray *provinceArray;

@property (strong, nonatomic) AddressListModel *changeModel;

@end
