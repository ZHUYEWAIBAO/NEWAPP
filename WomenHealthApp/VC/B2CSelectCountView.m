//
//  B2CSelectCountView.m
//  CMCCMall
//
//  Created by 朱 青 on 14-7-29.
//  Copyright (c) 2014年 cmcc. All rights reserved.
//

#import "B2CSelectCountView.h"
#import "CustomItoast.h"
#import "SelectCountCell.h"
#import "ShoppingCartVC.h"

@implementation CountView

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
    [super awakeFromNib];
    
    //顶部加一条线
//    UIImageView *topLineImgV = [[UIImageView alloc]initWithFrame:CGRectMake(15, 0, self.frame.size.width, 0.5)];
//    [topLineImgV setBackgroundColor:[UIColor colorWithRed:199.0/255.0 green:199.0/255.0 blue:204.0/255.0 alpha:1.0]];
//    [self addSubview:topLineImgV];
//    
//    //底部加一条线
//    UIImageView *bottomLineImgV = [[UIImageView alloc]initWithFrame:CGRectMake(15, self.frame.size.height - 0.5, self.frame.size.width, 0.5)];
//    [bottomLineImgV setBackgroundColor:[UIColor colorWithRed:199.0/255.0 green:199.0/255.0 blue:204.0/255.0 alpha:1.0]];
//    bottomLineImgV.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
//    [self addSubview:bottomLineImgV];
    
    _totalNum = 1;
}

- (IBAction)addBtnClickAction:(id)sender
{
    
    maxNum = [_detailModel.infoModel.goods_number integerValue];
    
    
    if (_totalNum < maxNum) {
        _totalNum++;
        self.countTextField.text = [NSString stringWithFormat:@"%ld",_totalNum];
        
    }
    else if (_totalNum == [_detailModel.infoModel.goods_number integerValue]) {
        [[CustomItoast showText:@"数量超过范围～"] showInView:self];
    }
}

- (IBAction)minusBtnClickAction:(id)sender
{
    if (_totalNum > 1) {
        _totalNum--;
        self.countTextField.text=[NSString stringWithFormat:@"%ld",_totalNum];
        
    }
    else if (_totalNum == 1) {
        [[CustomItoast showText:@"数量不少于1件～"] showInView:self];
    }
    
}


@end


#define TAG_BUYNOW 100
#define TAG_ADDCAR 101
#define TAG_CANCEL 102
#define TAG_TOCART 103
#define MAXNUM 99           //最大购买数量
//#define selectbuttonInSetx 8
//#define selectbuttonInSety 4
//#define selectbuttonHeight 30
//#define selectbuttonWidth  70
#define catebuttonInSetx 8
#define catebuttonInSety 4
#define catebuttonHeight 30
#define catebuttonWidth  96

@implementation B2CSelectCountView

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
    [super awakeFromNib];
    
    //顶部加一条线
    UIImageView *lineImgV=[[UIImageView alloc]initWithFrame:CGRectMake(0, self.selectTopView.frame.size.height - 0.5, self.selectTopView.frame.size.width, 0.5)];
    [lineImgV setBackgroundColor:[UIColor colorWithRed:199.0/255.0 green:199.0/255.0 blue:204.0/255.0 alpha:1.0]];
    [self.selectTopView addSubview:lineImgV];
    
    _paramDic = [[NSMutableDictionary alloc]initWithCapacity:0];
    _goodsDic = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"1",@"quick",@"0",@"parent", nil];
    
}

- (void)layOutTheCountView
{
    _countView = (CountView *)[[[NSBundle mainBundle] loadNibNamed:@"B2CSelectCountView" owner:self options:nil] lastObject];
    self.selectTableView.tableFooterView = _countView;

}

- (void)layOutTopView:(GoodDetailModel *)model
{
    _detailModel = model;
    _countView.detailModel = model;

    //库存
    _countView.selectStockLabel.text = [NSString stringWithFormat:@"库存: %@件",model.infoModel.goods_number];
    
    
}

#pragma mark UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return self.detailModel.specificationModel.specificationArray.count;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *nibArr = [[NSBundle mainBundle] loadNibNamed:@"SelectCountCell" owner:self options:nil];
    SelectCountCell *cell = [nibArr objectAtIndex:0];

    NSMutableArray *valueArray = [[self.detailModel.specificationModel.specificationArray objectAtIndex:indexPath.row] valuesArray];
    
    NSMutableArray *keyBtnArray = [[NSMutableArray alloc]initWithCapacity:0];
    
    [valueArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {

        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        
        [keyBtnArray addObject:button];
        
        if (idx > 0) {
            
            UIButton *foreButton = [keyBtnArray objectAtIndex:idx - 1];
            
            if (idx%3 == 0) {
                [button setFrame:CGRectMake(catebuttonInSetx, catebuttonInSety + foreButton.frame.origin.y + foreButton.frame.size.height, catebuttonWidth, catebuttonHeight)];
            }
            else{
                
                [button setFrame:CGRectMake(catebuttonInSetx + foreButton.frame.origin.x + foreButton.frame.size.width, foreButton.frame.origin.y, catebuttonWidth, catebuttonHeight)];
            }
        }
        else{
            [button setFrame:CGRectMake(catebuttonInSetx, catebuttonInSety + 18, catebuttonWidth, catebuttonHeight)];
        }


        if (idx == valueArray.count - 1) {
            
            CGRect rect = cell.frame;
            
            rect.size.height = button.frame.origin.y + button.frame.size.height + 10;
            
            cell.frame = rect;
            
        }
        
        
    }];

    return cell.frame.size.height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    SelectCountCell *cell = [tableView dequeueReusableCellWithIdentifier:[SelectCountCell cellIdentifier]];
    if (cell == nil){
        
        NSArray *nibArr = [[NSBundle mainBundle] loadNibNamed:@"SelectCountCell" owner:self options:nil];
        cell = [nibArr objectAtIndex:0];
        
    }
    
    cell.nameLabel.text = [[self.detailModel.specificationModel.specificationArray objectAtIndex:indexPath.row] name];
  
    NSMutableArray *valueArray = [[self.detailModel.specificationModel.specificationArray objectAtIndex:indexPath.row] valuesArray];
    
    [valueArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        
        GoodValuesModel *model = (GoodValuesModel *)obj;
       
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:model.label forState:UIControlStateNormal];
        [button.titleLabel setFont:[UIFont systemFontOfSize:13.0]];
        [button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [button setTitleColor:MAIN_RED_COLOR forState:UIControlStateSelected];
        [button setBackgroundImage:[UIImage imageWithContentFileName:@"screening_btn_noraml"] forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage imageWithContentFileName:@"screening_btn_active"] forState:UIControlStateSelected];
        [button setTag:(indexPath.row + 1) * 100 +idx];
        [button addTarget:self action:@selector(tableViewBtnAction:) forControlEvents:UIControlEventTouchUpInside];

        if ([[_paramDic objectForKey:[NSString stringWithFormat:@"%ld",button.tag/100 - 1]] isEqualToString:model.value_id]) {
            button.selected = YES;
        }

        
        [cell.buttonArray addObject:button];

        if (idx > 0) {
            
            UIButton *foreButton = [cell.buttonArray objectAtIndex:idx - 1];
            
            if (idx%3 == 0) {
                [button setFrame:CGRectMake(catebuttonInSetx, catebuttonInSety + foreButton.frame.origin.y + foreButton.frame.size.height, catebuttonWidth, catebuttonHeight)];
            }
            else{
                
                [button setFrame:CGRectMake(catebuttonInSetx + foreButton.frame.origin.x + foreButton.frame.size.width, foreButton.frame.origin.y, catebuttonWidth, catebuttonHeight)];
            }
        }
        else{
            [button setFrame:CGRectMake(catebuttonInSetx, catebuttonInSety + 18, catebuttonWidth, catebuttonHeight)];
        }

        [cell.contentView addSubview:button];
        

    }];

    return cell;
    
    
}

//点击商品触发push详情页
-(void)tableViewBtnAction:(id)sender
{
    
    UIButton *button = (UIButton *)sender;
    
    SelectCountCell *cell=(SelectCountCell *)[self.selectTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:button.tag/100 - 1 inSection:0]];
    
    for (UIButton *btn in cell.buttonArray) {
        btn.selected = NO;
    }
   
    button.selected = YES;
    
    GoodSpecificationModel *model = [self.detailModel.specificationModel.specificationArray objectAtIndex:button.tag/100 - 1];
    
    GoodValuesModel *value = [model.valuesArray objectAtIndex:button.tag%100];
    
    NSLog(@"uuu-----%@",value.value_id);
    
    [_paramDic setObject:CHECK_VALUE(value.value_id) forKey:[NSString stringWithFormat:@"%ld",button.tag/100 - 1]];
}

#pragma mark - 按钮事件
- (IBAction)btnClickAction:(id)sender
{
    UIButton *button = (UIButton *)sender;
    
    switch (button.tag) {
            
        case TAG_BUYNOW:{
            NSMutableArray *array = [[NSMutableArray alloc]init];
            
            for (NSInteger i=0;i < [[_paramDic allValues]count];i++) {
                [array addObject:[[_paramDic allValues]objectAtIndex:i]];
            }
            
            if (array.count < self.detailModel.specificationModel.specificationArray.count) {
                [[CustomItoast showText:@"请选择您要的商品信息"] showInView:self];
                return;
            }
            
            [_goodsDic setObject:array forKey:@"spec"];
            [_goodsDic setObject:self.detailModel.infoModel.goods_id forKey:@"goods_id"];
            [_goodsDic setObject:[NSString stringWithFormat:@"%ld",self.countView.totalNum] forKey:@"number"];
            
            if ([self.delegate respondsToSelector:@selector(B2CSelectCountView:params:isAddToCar:)]) {
                [self.delegate B2CSelectCountView:self params:_goodsDic isAddToCar:NO];
            }
        }
            break;
            
        case TAG_ADDCAR:{
            NSMutableArray *array = [[NSMutableArray alloc]init];
            
            for (NSInteger i=0;i < [[_paramDic allValues]count];i++) {
                [array addObject:[[_paramDic allValues]objectAtIndex:i]];
            }
            if (array.count < self.detailModel.specificationModel.specificationArray.count) {
                [[CustomItoast showText:@"请选择您要的商品信息"] showInView:self];
                return;
            }
            [_goodsDic setObject:array forKey:@"spec"];
            [_goodsDic setObject:self.detailModel.infoModel.goods_id forKey:@"goods_id"];
            [_goodsDic setObject:[NSString stringWithFormat:@"%ld",self.countView.totalNum] forKey:@"number"];
            
            if ([self.delegate respondsToSelector:@selector(B2CSelectCountView:params:isAddToCar:)]) {
                [self.delegate B2CSelectCountView:self params:_goodsDic isAddToCar:YES];
            }
        }
            break;
            
        case TAG_TOCART:{
           
            
            
        }
            break;
            
        case TAG_CANCEL:{
            if ([self.delegate respondsToSelector:@selector(B2CSelectCountView:dismiss:)]) {
                [self.delegate B2CSelectCountView:self dismiss:YES];
            }
        }
            break;
            
        default:
            break;
    }

}


@end
