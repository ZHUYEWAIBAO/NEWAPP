//
//  AddressViewController.h
//  CMCCMall
//
//  Created by 朱 青 on 14-11-11.
//  Copyright (c) 2014年 cmcc. All rights reserved.
//

#import "BasicVC.h"

@interface AddressViewController : BasicVC

@property (strong, nonatomic) NSMutableArray *addressArray;
@property (strong, nonatomic) NSString *chooseId;//用于标识当前选中地址

@property (weak, nonatomic) IBOutlet UITableView *addressTableView;

@property (strong, nonatomic) IBOutlet UIView *footView;

@end
