//
//  RecordDetailVC.m
//  WomenHealthApp
//
//  Created by 朱 青 on 14-11-17.
//  Copyright (c) 2014年 WomenHealthApp. All rights reserved.
//

#import "RecordDetailVC.h"
#import "RecordDetailCell.h"
#import "RecordViewItem.h"
#import "pickerCell.h"
@interface RecordDetailVC ()
{
    UIView *sectionView;
    BOOL isShowContentView;
    UIView *STView;
    RecordViewItem *detail;
    
    UIView *STViewTwo;
    RecordViewItem *detailTwo;
    
    NSArray *aiaiAry ;
    NSArray *tiwenAry0;
    NSArray *tiwenAry1;
    
    NSMutableArray *tizhongAry0;
    NSMutableArray *tizhongAry1;
    
    NSInteger pickerChose;

    
}
@end

@implementation RecordDetailVC
-(void)loadView{
    [super loadView];
    aiaiAry =@[@"没带套套",@"带了套套"];
    tiwenAry0 =@[@"46",@"37",@"36"];
    tiwenAry1=@[@".40C",@".41C",@".42C",@".43C",@".44C"];
    tizhongAry0 =[NSMutableArray array];
    
    for (int i=30; i<100; i++) {
        [tizhongAry0 addObject:[NSString stringWithFormat:@"%i",i]];
        
    }
    tizhongAry1 =[NSMutableArray arrayWithObjects:@".0kg",@".5kg", nil];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIButton *rightButton=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
    [rightButton addTarget:self action:@selector(recordDetailSureAction:) forControlEvents:UIControlEventTouchUpInside];
    [rightButton setBackgroundImage:[UIImage imageWithContentFileName:@"Record_detail_sure_btn.png"] forState:UIControlStateNormal];
    UIBarButtonItem *rightButtonItem=[[UIBarButtonItem alloc]initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem = rightButtonItem;
    
    UIButton *leftButton=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
    [leftButton addTarget:self action:@selector(recordDetailBackAction:) forControlEvents:UIControlEventTouchUpInside];
    [leftButton setBackgroundImage:[UIImage imageWithContentFileName:@"Record_detail_date_btn.png"] forState:UIControlStateNormal];
    UIBarButtonItem *leftButtonItem=[[UIBarButtonItem alloc]initWithCustomView:leftButton];
    self.navigationItem.leftBarButtonItem = leftButtonItem;
    
    _imageArray = [[NSMutableArray alloc]initWithObjects:@"Record_detail_love_logo.png",@"Record_detail_tiwen_logo.png",@"Record_detail_zhengzhuang_logo.png",@"Record_detail_weight_logo.png", nil];
    _dataArray = [[NSMutableArray alloc]initWithObjects:@"爱爱",@"体温",@"症状",@"体重", nil];
 
    
//    _detailContentView = [[RecordDetailContentView alloc]initWithFrame:CGRectMake(0, 162, SCREEN_SIZE.width, 0)];
    _detailContentView  =(RecordDetailContentView *)[[[NSBundle mainBundle] loadNibNamed:@"RecordDetailContentView" owner:self options:nil] lastObject];
//    _detailContentView.backgroundColor = [UIColor blackColor];
    [self.headView addSubview:_detailContentView];
    [_detailContentView setFrame:CGRectMake(0, 162, _detailContentView.frame.size.width, 88)];
        _detailContentView.hidden =YES;


    
    self.detailTableView.tableHeaderView = self.headView;
    
    
    
    STView = [[UIView alloc]initWithFrame:self.view.bounds];
    [STView setBackgroundColor:[UIColor colorWithRed:0.3 green:0.3 blue:0.3 alpha:0.7]];
    UITapGestureRecognizer *tapDismssges =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissWindow)];
    [STView addGestureRecognizer:tapDismssges];
    
    STViewTwo = [[UIView alloc]initWithFrame:self.view.bounds];
    [STViewTwo setBackgroundColor:[UIColor colorWithRed:0.3 green:0.3 blue:0.3 alpha:0.7]];
    UITapGestureRecognizer *tapDismssgesTwo =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissWindow)];
    [STViewTwo addGestureRecognizer:tapDismssgesTwo];
    
    
    detail =(RecordViewItem *)[[[NSBundle mainBundle] loadNibNamed:@"RecordViewItem" owner:self options:nil] firstObject];
    detail.layer.cornerRadius =5.0f;
    
    [detail setFrame:CGRectMake(100, 50, detail.frame.size.width, detail.frame.size.height)];
    detail.center =CGPointMake(160, SCREEN_SIZE.height/2);
    [STView.subviews enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [obj removeFromSuperview];
    }];
    [STView addSubview:detail];
    
    
    
    detailTwo =(RecordViewItem *)[[[NSBundle mainBundle] loadNibNamed:@"RecordViewItem" owner:self options:nil] lastObject];
    detailTwo.layer.cornerRadius =5.0f;
    
    [detailTwo setFrame:CGRectMake(100, 50, detail.frame.size.width, detail.frame.size.height)];
    detailTwo.center =CGPointMake(160, SCREEN_SIZE.height/2);
    [STViewTwo.subviews enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [obj removeFromSuperview];
    }];
    [STViewTwo addSubview:detailTwo];
 
}
-(void)dismissWindow{
    
//    [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
//        CATransform3D transform = CATransform3DMakeScale(0.1, 0.1, 1);
//        STView.layer.transform = transform;
//    } completion:^(BOOL finished) {
    
    [STView removeFromSuperview];
    [STViewTwo removeFromSuperview];
        
//    }];

}
- (void)recordDetailSureAction:(id)sender
{
    
}

- (void)recordDetailBackAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)showTheDetailContent:(id)sender
{
    if (isShowContentView) {
        [self contentViewReturnToTop];
        _detailContentView.hidden =YES;
    }
    else{
        [self contentViewShow];
        _detailContentView.hidden =NO;
    }
}

- (void)contentViewShow
{

    [UIView animateWithDuration:0.2f animations:^{
 
        [_detailContentView setHidden:NO];
//        [_detailContentView setFrame:CGRectMake(0, 162, _detailContentView.frame.size.width, 88)];
        
        [_headView setFrame:CGRectMake(0, _headView.frame.origin.y, _headView.frame.size.width, 250)];
        //箭头旋转
        self.contentArrowImgView.transform = CGAffineTransformMakeRotation(M_PI);
        self.detailTableView.tableHeaderView = self.headView;
    }];
    isShowContentView = YES;
}

- (void)contentViewReturnToTop
{
    
    [UIView animateWithDuration:0.2f animations:^{
        
       
//        [_detailContentView setFrame:CGRectMake(0, 162, _detailContentView.frame.size.width, 0)];
        
        [_headView setFrame:CGRectMake(0, _headView.frame.origin.y, _headView.frame.size.width, 162)];
        //箭头旋转
        self.contentArrowImgView.transform = CGAffineTransformMakeRotation(M_PI * 2);
        
        self.detailTableView.tableHeaderView = self.headView;
    }];
    
    isShowContentView = NO;

}

#pragma mark UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.dataArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSArray *nibArr = [[NSBundle mainBundle] loadNibNamed:@"RecordDetailCell" owner:self options:nil];
    RecordDetailCell *cell = [nibArr objectAtIndex:0];
    return cell.frame.size.height;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    RecordDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:[RecordDetailCell cellIdentifier]];
    
    if (cell == nil) {
        
        NSArray *nibArr = [[NSBundle mainBundle] loadNibNamed:@"RecordDetailCell" owner:self options:nil];
        cell = [nibArr objectAtIndex:0];
        
        UIImageView *lineImgV=[[UIImageView alloc]initWithFrame:CGRectMake(10, cell.frame.size.height-1, cell.frame.size.width, 0.5)];
        [cell.contentView addSubview:lineImgV];
        [lineImgV setBackgroundColor:RGBACOLOR(199, 199, 204, 1.0)];
        
    }
    cell.detailTitleLabel.text = [self.dataArray objectAtIndex:indexPath.row];
    [cell.detailImageView setImage:[UIImage imageWithContentFileName:[self.imageArray objectAtIndex:indexPath.row]]];
    
    return cell;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    NSLog(@"%li",(long)indexPath.row);

    
    switch (indexPath.row) {
        case 0:{
            
           
            detail.titleNameLab.text =@"爱爱";
           detail.tishiLab.text =@"";
            pickerChose =0;
            [detail.pickerView reloadAllComponents];
            [[[UIApplication sharedApplication] keyWindow] addSubview:STView];
            CAKeyframeAnimation *popAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
            popAnimation.duration = 0.2;
            popAnimation.values = @[[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.001f, 0.001f, 1.0f)],[NSValue valueWithCATransform3D:CATransform3DIdentity]];
            //    popAnimation.keyTimes = @[@0.2f, @1.0f];
            //    popAnimation.timingFunctions = @[[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut],
            //                                     [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut],
            //                                     [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
            [detail.layer addAnimation:popAnimation forKey:nil];
  
            break;
        }
        case 1:{
            

            detail.titleNameLab.text =@"体温";
            detail.tishiLab.text =@"记录体温能够帮助你监控生理周期状况,有利于避孕和备孕哦！测口腔温度哦！";
            pickerChose =1;
            [detail.pickerView reloadAllComponents];
            [[[UIApplication sharedApplication] keyWindow] addSubview:STView];
            CAKeyframeAnimation *popAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
            popAnimation.duration = 0.2;
            popAnimation.values = @[[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.001f, 0.001f, 1.0f)],[NSValue valueWithCATransform3D:CATransform3DIdentity]];
            //    popAnimation.keyTimes = @[@0.2f, @1.0f];
            //    popAnimation.timingFunctions = @[[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut],
            //                                     [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut],
            //                                     [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
            [detail.layer addAnimation:popAnimation forKey:nil];
            
            break;
        }
        case 2:{
            
            pickerChose =2;
            [detailTwo.pickerView reloadAllComponents];
            UIView *view =[[UIView alloc] initWithFrame:CGRectMake(0, 330, 100, 100)];
            view.backgroundColor =[UIColor blackColor];
            
            [detailTwo.alterScrollview addSubview:view];
            [detailTwo.alterScrollview setContentSize:CGSizeMake(280, 600)];
            [[[UIApplication sharedApplication] keyWindow] addSubview:STViewTwo];
            CAKeyframeAnimation *popAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
            popAnimation.duration = 0.2;
            popAnimation.values = @[[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.001f, 0.001f, 1.0f)],[NSValue valueWithCATransform3D:CATransform3DIdentity]];
            //    popAnimation.keyTimes = @[@0.2f, @1.0f];
            //    popAnimation.timingFunctions = @[[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut],
            //                                     [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut],
            //                                     [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
            [detailTwo.layer addAnimation:popAnimation forKey:nil];

            
            break;
        }
        case 3:{
            detail.titleNameLab.text =@"体重";
            detail.tishiLab.text =@"";
            pickerChose =3;
            [detail.pickerView reloadAllComponents];
            [[[UIApplication sharedApplication] keyWindow] addSubview:STView];
            CAKeyframeAnimation *popAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
            popAnimation.duration = 0.2;
            popAnimation.values = @[[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.001f, 0.001f, 1.0f)],[NSValue valueWithCATransform3D:CATransform3DIdentity]];
            //    popAnimation.keyTimes = @[@0.2f, @1.0f];
            //    popAnimation.timingFunctions = @[[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut],
            //                                     [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut],
            //                                     [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
            [detail.layer addAnimation:popAnimation forKey:nil];
            break;
        }
        default:
            break;
    }
    
    
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{

    if (nil == sectionView) {
        sectionView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_SIZE.width, 30)];
        sectionView.tintColor=[UIColor clearColor];
    }

    //Title
    UILabel *label = (UILabel *)[sectionView viewWithTag:1002];
    if (label == nil) {
        label = [[UILabel alloc]initWithFrame:CGRectMake(9, 4, 71, 21)];
        label.textAlignment = NSTextAlignmentLeft;
        label.backgroundColor = [UIColor clearColor];
        label.font = [UIFont systemFontOfSize:15.0f];
        label.textColor = [UIColor darkGrayColor];
        label.text = @"日常";
        [label setTag:1002];
        [sectionView addSubview:label];
    }
    
    return sectionView;
}
/**
 if (pickerChose ==0) {
 return 1;
 }else if(pickerChose ==1){
 
 
 }else if(pickerChose ==2){
 
 
 }else if(pickerChose ==3){
 
 
 }
 */
#pragma mark PICKVIEW
// returns the number of 'columns' to display.
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    if (pickerChose ==0) {
        return 1;
    }else if(pickerChose ==1){
        return 2;
        
    }else if(pickerChose ==2){
        
        
    }else if(pickerChose ==3){
        return 2;
        
    }
        
    return 1;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    
    if (pickerChose ==0) {
        return 2;
    }else if(pickerChose ==1){
        if (component==0) {
            return tiwenAry0.count;
        }else{
            return tiwenAry1.count;
        }
        
    }else if(pickerChose ==2){
        
        
    }else if(pickerChose ==3){
        if (component==0) {
            return tizhongAry0.count;
        }else{
            return tizhongAry1.count;
        }
        
    }
    return 2;
}
-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (pickerChose ==0) {

        
    }else if(pickerChose ==1){
        
        if (component==0) {
            return [tiwenAry0 objectAtIndex:row];
        }else{
            return [tiwenAry1 objectAtIndex:row];
        }
        
    }else if(pickerChose ==2){
        
        
    }else if(pickerChose ==3){
        
        if (component==0) {
            return [tizhongAry0 objectAtIndex:row];
        }else{
            return [tizhongAry1 objectAtIndex:row];
        }
    }
    
    return @"";
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    
    if (pickerChose ==0) {
        
        pickerCell *tempView  =(pickerCell *)[pickerView viewForRow:row forComponent:component];
        tempView.titleLab.text =[aiaiAry objectAtIndex:row];
        tempView.titleLab.textColor = FENSERGB;
        tempView.heartimg.image =[UIImage imageWithContentFileName:@"no_love_logo"];
        
        
    }else if(pickerChose ==1){
        pickerCell *tempView  =(pickerCell *)[pickerView viewForRow:row forComponent:component];
        
        if (component==0) {
            tempView.titleLab.text  =[tiwenAry0 objectAtIndex:row];
        }else{
            tempView.titleLab.text =[tiwenAry1 objectAtIndex:row];
        }        tempView.titleLab.textColor = FENSERGB;

        
        
    }else if(pickerChose ==2){
        
        
    }else if(pickerChose ==3){
        
        pickerCell *tempView  =(pickerCell *)[pickerView viewForRow:row forComponent:component];
        
        if (component==0) {
            tempView.titleLab.text  =[tizhongAry0 objectAtIndex:row];
        }else{
            tempView.titleLab.text =[tizhongAry1 objectAtIndex:row];
        }        tempView.titleLab.textColor = FENSERGB;
        
        
    }


   
    
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    
    if (pickerChose ==0) {
        pickerCell *tempView =(pickerCell *)[[[NSBundle mainBundle] loadNibNamed:@"pickerCell" owner:self options:nil] firstObject];
        tempView.titleLab.text =[aiaiAry objectAtIndex:row];
        if (row ==0) {
            tempView.heartimg.image =[UIImage imageWithContentFileName:@"no_love_logo"];
            tempView.titleLab.textColor = FENSERGB;
        }
        tempView.heartimg.image =[UIImage imageWithContentFileName:@"yes_love_logo"];
        return tempView;
    }else if(pickerChose ==1){
    
        pickerCell *tempView =(pickerCell *)[[[NSBundle mainBundle] loadNibNamed:@"pickerCell" owner:self options:nil] firstObject];
        if (component==0) {
            tempView.titleLab.text  =[tiwenAry0 objectAtIndex:row];
        }else{
            tempView.titleLab.text =[tiwenAry1 objectAtIndex:row];
        }
        tempView.heartimg.hidden =YES;
        return tempView;
        
    }else if(pickerChose ==3){
        
        pickerCell *tempView =(pickerCell *)[[[NSBundle mainBundle] loadNibNamed:@"pickerCell" owner:self options:nil] firstObject];
        if (component==0) {
            tempView.titleLab.text  =[tizhongAry0 objectAtIndex:row];
        }else{
            tempView.titleLab.text =[tizhongAry1 objectAtIndex:row];
        }
        tempView.heartimg.hidden =YES;
        return tempView;
    }
 
    return nil;

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
