//
//  PayTypeChooseVC.h
//  WomenHealthApp
//
//  Created by 朱青 on 14/12/13.
//  Copyright (c) 2014年 WomenHealthApp. All rights reserved.
//

#import "BasicVC.h"

@interface PayTypeChooseVC : BasicVC

@property (weak, nonatomic) IBOutlet UITableView *payTypeTableView;

@property (strong, nonatomic) NSMutableArray *payTypeArray;

@end
