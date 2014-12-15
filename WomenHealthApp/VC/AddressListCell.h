//
//  AddressListCell.h
//  CMCCMall
//
//  Created by 朱 青 on 14-11-11.
//  Copyright (c) 2014年 cmcc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddressListCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView *addressView;

@property (weak, nonatomic) IBOutlet UILabel *addressNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressPhoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressDetailLabel;

@property (weak, nonatomic) IBOutlet UIButton *editButton;
@property (weak, nonatomic) IBOutlet UIButton *deleteButton;
@property (weak, nonatomic) IBOutlet UIButton *setDefaultButton;

@end
