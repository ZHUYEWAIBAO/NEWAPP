//
//  MyOrderListCell.m
//  WomenHealthApp
//
//  Created by 朱青 on 14/12/14.
//  Copyright (c) 2014年 WomenHealthApp. All rights reserved.
//

#import "MyOrderListCell.h"
#import "MyOrderListModel.h"
#import "LineImageView.h"

@implementation HeadView

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

    
}

@end

@implementation FootView

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
    
    
}

@end

@implementation MyOrderListCell

- (void)awakeFromNib {

}

- (void)layOutTheHeadView
{
    _headView = (HeadView *)[[[NSBundle mainBundle]loadNibNamed:@"MyOrderListCell" owner:self options:nil] objectAtIndex:2];

    self.goodsTableView.tableHeaderView = _headView;
    
}

- (void)layOutTheFootView
{
    _footView = (FootView *)[[[NSBundle mainBundle]loadNibNamed:@"MyOrderListCell" owner:self options:nil] objectAtIndex:3];
    
    self.goodsTableView.tableFooterView = _footView;
    
}

#pragma mark UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return self.goodsArray.count;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *nibArr = [[NSBundle mainBundle] loadNibNamed:@"MyOrderListCell" owner:self options:nil];
    MyOrderGoodsCell *cell = [nibArr objectAtIndex:1];
    
    return cell.frame.size.height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    MyOrderGoodsCell *cell = [tableView dequeueReusableCellWithIdentifier:[MyOrderGoodsCell cellIdentifier]];
    if (cell == nil){
        
        NSArray *nibArr = [[NSBundle mainBundle] loadNibNamed:@"MyOrderListCell" owner:self options:nil];
        cell = [nibArr objectAtIndex:1];
        
        LineImageView *lineImgV=[[LineImageView alloc]initWithFrame:CGRectMake(10, cell.frame.size.height-1, cell.frame.size.width - 20, 0.5)];
        [cell.contentView addSubview:lineImgV];
        
    }
    
    MyOrderGoodsModel *model = [self.goodsArray objectAtIndex:indexPath.row];
    cell.nameLabel.text = model.goods_name;
    cell.priceLabel.text = [NSString priceStringWithOneFloat:model.shop_price];
    cell.numLabel.text = [NSString stringWithFormat:@"x%@",model.goods_number];
    
    [cell.goodsImageView setImageWithURL:[NSURL URLWithString:model.goods_thumb]];
    
    if ([@"7" isEqualToString:_currentStatus]) {
        
        [cell.commentBtn setHidden:NO];
        [cell.commentBtn setTag:(_currentRow + 1)*100 + indexPath.row];
        [cell.commentBtn addTarget:currentTarget action:currentAction forControlEvents:UIControlEventTouchUpInside];
        
    }

    return cell;
    
    
}

-(void)setItemWithArray:(NSMutableArray *)goodsArray orderStatus:(NSString *)status currentRow:(NSInteger)row target:(id)target detailAction:(SEL)detailAction commentAction:(SEL)commentAction
{
    _currentStatus = status;
    _currentRow = row;
    currentTarget = target;
    currentAction = commentAction;
    [self.orderButton addTarget:target action:detailAction forControlEvents:UIControlEventTouchUpInside];
    self.goodsArray = goodsArray;
    [self.goodsTableView reloadData];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

@implementation MyOrderGoodsCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end