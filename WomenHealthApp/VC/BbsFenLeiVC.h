//
//  BbsFenLeiVC.h
//  WomenHealthApp
//
//  Created by Daniel on 14/11/15.
//  Copyright (c) 2014年 WomenHealthApp. All rights reserved.
//

#import "BasicVC.h"

@interface BbsFenLeiVC : BasicVC<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *menuBigTableView;

@property (strong, nonatomic) NSMutableArray *bigMenuArray;

@property (strong, nonatomic) NSMutableArray *subMenuArray;

@property (weak, nonatomic) IBOutlet UITableView *fenLeiRightTable;

@end
