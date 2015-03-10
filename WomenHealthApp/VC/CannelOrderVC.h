//
//  CannelOrderVC.h
//  WomenHealthApp
//
//  Created by 朱青 on 15/3/6.
//  Copyright (c) 2015年 WomenHealthApp. All rights reserved.
//

#import "BasicVC.h"
#import "UIPlaceHolderTextView.h"

@interface CannelOrderVC : BasicVC

@property (weak, nonatomic) IBOutlet UIPlaceHolderTextView *contentTextView;

@property (strong, nonatomic) NSString *orderId;

@end
