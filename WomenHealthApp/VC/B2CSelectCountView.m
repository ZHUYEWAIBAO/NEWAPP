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
    totalNum = 1;
}

- (IBAction)addBtnClickAction:(id)sender
{
    
    maxNum = [_detailModel.infoModel.goods_number integerValue];
    
    
    if (totalNum < maxNum) {
        totalNum++;
        self.countTextField.text = [NSString stringWithFormat:@"%ld",totalNum];
        
    }
    else if (totalNum == [_detailModel.infoModel.goods_number integerValue]) {
        [[CustomItoast showText:@"数量超过范围～"] showInView:self];
    }
}

- (IBAction)minusBtnClickAction:(id)sender
{
    if (totalNum > 1) {
        totalNum--;
        self.countTextField.text=[NSString stringWithFormat:@"%ld",totalNum];
        
    }
    else if (totalNum == 1) {
        [[CustomItoast showText:@"数量不少于1件～"] showInView:self];
    }
    
}


@end

#define btn_close 100       //关闭按钮
#define btn_add 101         //数量增加
#define btn_minus 102       //数量减少
#define btn_descide 103     //确定下单
#define MAXNUM 99           //最大购买数量
#define selectbuttonInSetx 8
#define selectbuttonInSety 4
#define selectbuttonHeight 30
#define selectbuttonWidth  70

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

    totalNum = 1;
    
    
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
    
    return cell.frame.size.height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    SelectCountCell *cell = [tableView dequeueReusableCellWithIdentifier:[SelectCountCell cellIdentifier]];
    if (cell == nil){
        
        NSArray *nibArr = [[NSBundle mainBundle] loadNibNamed:@"SelectCountCell" owner:self options:nil];
        cell = [nibArr objectAtIndex:0];
        
    }

    __block NSInteger row = 0;
    
    NSMutableArray *keyBtnArray = [[NSMutableArray alloc]initWithCapacity:0];
    
    NSMutableArray *valueArray = [[self.detailModel.specificationModel.specificationArray objectAtIndex:indexPath.row] valuesArray];
    
    [valueArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        
        GoodValuesModel *model = (GoodValuesModel *)obj;
       
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:model.label forState:UIControlStateNormal];
        [button.titleLabel setFont:[UIFont systemFontOfSize:13.0]];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button setBackgroundColor:[UIColor lightGrayColor]];
        
//        [button addTarget:self action:@selector(keyWordsSearch:) forControlEvents:UIControlEventTouchUpInside];
        
        [keyBtnArray addObject:button];

        if (idx > 0) {
            
            UIButton *foreButton = [keyBtnArray objectAtIndex:idx - 1];
            [button setFrame:CGRectMake(selectbuttonInSetx + foreButton.frame.origin.x + foreButton.frame.size.width, selectbuttonInSety * (row + 1) + selectbuttonHeight * row, selectbuttonWidth, selectbuttonHeight)];
            
            if (button.frame.origin.x + button.frame.size.width > SCREEN_SIZE.width) {
                
                row++;
                [button setFrame:CGRectMake(selectbuttonInSetx, selectbuttonInSety * (row + 1) + selectbuttonHeight * row, selectbuttonWidth, selectbuttonHeight)];
            }
        }
        else{
            [button setFrame:CGRectMake(selectbuttonInSetx, 21+selectbuttonInSety, selectbuttonWidth, selectbuttonHeight)];
        }

        [cell.contentView addSubview:button];
        
        if (idx == valueArray.count - 1) {
            
            CGRect rect = cell.frame;
            
            rect.size.height = button.frame.origin.y + button.frame.size.height + 10;
            
            cell.frame = rect;

        }
        
        
    }];

    return cell;
    
    
}

//点击商品触发push详情页
-(void)tableViewBtnAction:(id)sender
{

}

#pragma mark - 按钮事件
- (IBAction)btnClickAction:(id)sender
{
//    UIButton *button = (UIButton *)sender;
//    
//    if ([self.delegate respondsToSelector:@selector(B2CSelectCountView:btnClick:goodsCount:)]) {
//        [self.delegate B2CSelectCountView:self btnClick:button.tag goodsCount:[self.countTextField.text integerValue]];
//    }
}


@end
