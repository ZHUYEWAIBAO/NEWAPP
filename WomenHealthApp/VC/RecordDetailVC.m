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
    NSMutableArray *tiwenAry0;
    NSMutableArray *tiwenAry1;
    
    NSMutableArray *tizhongAry0;
    NSMutableArray *tizhongAry1;
    
    NSInteger pickerChose;
    
    NSMutableDictionary *totalDic;// 存储所有数据的
    
    int aiaiIndex;
    
    int  tiwenRow0;
    int  tiwenRow1;
    
    int  tizhongRow0;
    int  tizhongRow1;

    
    __weak IBOutlet UISwitch *starSwitch;
    
    __weak IBOutlet UISwitch *endSwitch;
    
    NSString *liuliangData;
    NSString *tongjingData;
    
    NSString *TodayStr;
    
    NSMutableArray *shujuAry;
    
    NSMutableArray *ziAry;//显示cell上
}
@end

@implementation RecordDetailVC
-(void)loadView{
    [super loadView];
    liuliangData =@"平均";
    tongjingData =@"轻度";
    shujuAry =[NSMutableArray array];
    ziAry =[NSMutableArray arrayWithObjects:@"头疼",@"眩晕",@"粉刺",@"呕吐",@"失眠",@"贪冷饮",@"腹泻",@"小腹坠胀",@"头疼",@"食欲不振",@"腰酸",@"便秘",@"发热",@"身体酸痛",@"乳房胀痛",@"白带异常", nil];
    NSDateFormatter  *formater =[[NSDateFormatter alloc]init];
    [formater setDateFormat:@"yyyyMMdd"];
    TodayStr =[formater stringFromDate:self.passDate];
    [CMSinger share].singerDate =self.passDate;
    
    totalDic =[NSMutableDictionary dictionaryWithDictionary:[[[NSUserDefaults standardUserDefaults] objectForKey:@"resultDic"] objectForKey:TodayStr]];
    
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"resultDic"] objectForKey:TodayStr] ==nil) {
        totalDic =[NSMutableDictionary dictionary];
        aiaiIndex =0;
        [totalDic setObject:[NSNumber numberWithInt:aiaiIndex] forKey:@"aiaiIndex"];
        
        tiwenRow0 =0;
        tiwenRow1 =50;
        
        [totalDic setObject:[NSNumber numberWithInt:tiwenRow0] forKey:@"tiwenRow0"];
        [totalDic setObject:[NSNumber numberWithInt:tiwenRow1] forKey:@"tiwenRow1"];
        
        
        tizhongRow0 =30;
        tizhongRow1 =0;
        [totalDic setObject:[NSNumber numberWithInt:tizhongRow0] forKey:@"tizhongRow0"];
        [totalDic setObject:[NSNumber numberWithInt:tizhongRow1] forKey:@"tizhongRow1"];
        
    }else{
        //  do nothing
        NSLog(@"%@",totalDic);
    }

    aiaiAry =@[@"没带套套",@"带了套套"];
    tiwenAry0 =[NSMutableArray array];
    tiwenAry1 =[NSMutableArray array];
    tizhongAry0 =[NSMutableArray array];
    tizhongAry1 =[NSMutableArray array];
    for (int i=35; i<44; i++) {
        [tiwenAry0 addObject:[NSString stringWithFormat:@"%i",i]];
    }
    for (int i=0; i<100; i++) {
        [tiwenAry1 addObject:[NSString stringWithFormat:@".%i℃",i]];
    }
    
    
    for (int i=20; i<150; i++) {
        [tizhongAry0 addObject:[NSString stringWithFormat:@"%i",i]];
        
    }

    for (int i=0; i<10; i++) {
        [tizhongAry1 addObject:[NSString stringWithFormat:@".%iKG",i]];
        
    }
    
    
    
    
    //取出症状数据 新增功能
    
    NSDateFormatter  *formateraaaa =[[NSDateFormatter alloc]init];
    [formateraaaa setDateFormat:@"yyyyMMdd"];
    NSString * TodayStra =[formater stringFromDate:[CMSinger share].singerDate];
    NSDictionary* totalDica =[NSMutableDictionary dictionaryWithDictionary:[[[NSUserDefaults standardUserDefaults] objectForKey:@"resultDic"] objectForKey:TodayStra]];
    shujuAry=[NSMutableArray arrayWithArray:[totalDica objectForKey:@"shujuAry"]];
    

    
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
    _detailContentView.RDDate =self.passDate;
    _detailContentView.RDDelegete =self;
//    _detailContentView.backgroundColor = [UIColor blackColor];
    [self.headView addSubview:_detailContentView];
    [_detailContentView setFrame:CGRectMake(0, 162, _detailContentView.frame.size.width, 88)];
        _detailContentView.hidden =YES;
    self.detailTableView.tableHeaderView = self.headView;
    
    if ([totalDic objectForKey:@"starSwitch"] ==[NSNumber numberWithBool:YES]) {
        starSwitch.on  =YES;
    }else{
        starSwitch.on =NO;
    }
    
    if ([totalDic objectForKey:@"endSwitch"] ==[NSNumber numberWithBool:YES]) {
        endSwitch.on  =YES;
    }else{
        endSwitch.on =NO;
    }


    
    STView = [[UIView alloc]initWithFrame:self.view.bounds];
    [STView setBackgroundColor:[UIColor colorWithRed:0.3 green:0.3 blue:0.3 alpha:0.3]];
    UITapGestureRecognizer *tapDismssges =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissWindow)];
    [STView addGestureRecognizer:tapDismssges];
    
    STViewTwo = [[UIView alloc]initWithFrame:self.view.bounds];
    [STViewTwo setBackgroundColor:[UIColor colorWithRed:0.3 green:0.3 blue:0.3 alpha:0.3]];
    UITapGestureRecognizer *tapDismssgesTwo =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissWindow)];
    [STViewTwo addGestureRecognizer:tapDismssgesTwo];
    
    
    detail =(RecordViewItem *)[[[NSBundle mainBundle] loadNibNamed:@"RecordViewItem" owner:self options:nil] firstObject];
    detail.layer.cornerRadius =5.0f;
    detail.delegete =self;
    detail.zzzDate =self.passDate;
    [detail setFrame:CGRectMake(100, 50, detail.frame.size.width, detail.frame.size.height)];
    detail.center =CGPointMake(160, SCREEN_SIZE.height/2);
    [STView.subviews enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [obj removeFromSuperview];
    }];
    [STView addSubview:detail];
    
    
    
    detailTwo =(RecordViewItem *)[[[NSBundle mainBundle] loadNibNamed:@"RecordViewItem" owner:self options:nil] lastObject];
    detailTwo.layer.cornerRadius =5.0f;
    detailTwo.delegete =self;
    detailTwo.zzzDate =self.passDate;
    [detailTwo setFrame:CGRectMake(100, 50, detail.frame.size.width, detail.frame.size.height)];
    detailTwo.center =CGPointMake(160, SCREEN_SIZE.height/2);
    [STViewTwo.subviews enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [obj removeFromSuperview];
    }];
    [STViewTwo addSubview:detailTwo];
    

//    [self.detailTableView reloadData];
 
}
#pragma mark recordProtocal
-(void)didSelDismss{
    
    
    if (pickerChose ==0) {
        aiaiIndex =0;
        [totalDic setObject:[NSNumber numberWithInt:aiaiIndex] forKey:@"aiaiIndex"];
    }else if(pickerChose ==1){
        
        
        tiwenRow0 =0;
        tiwenRow1 =50;
        
        [totalDic setObject:[NSNumber numberWithInt:tiwenRow0] forKey:@"tiwenRow0"];
        [totalDic setObject:[NSNumber numberWithInt:tiwenRow1] forKey:@"tiwenRow1"];
        
    }else if(pickerChose ==2){
        
        [totalDic setObject:[NSMutableArray array] forKey:@"shujuAry"];
        
        
    }else if(pickerChose ==3){
        
        tizhongRow0 =30;
        tizhongRow1 =0;
        [totalDic setObject:[NSNumber numberWithInt:tizhongRow0] forKey:@"tizhongRow0"];
        [totalDic setObject:[NSNumber numberWithInt:tizhongRow1] forKey:@"tizhongRow1"];
        
        
    }

    
    [self dismissWindow];
}
-(void)comfirmSelect:(NSMutableArray *)zzzAry{
    
    shujuAry =zzzAry;
    /**
     *  保存数据
     */
//    totalDic =[NSMutableDictionary dictionaryWithDictionary:[[NSUserDefaults standardUserDefaults] objectForKey:@"totalDic"]];
    
    [self dismissWindow];
    [self.detailTableView reloadData];
    
    
}

-(void)setLiuLiang:(NSString *)liuliang AndTongjing:(NSString *)tongjing{
    

    liuliangData =liuliang;

    tongjingData =tongjing;
    
}

-(void)dismissWindow{
    
//    [UIView animateWithDuration:1 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
//        CATransform3D transform = CATransform3DMakeScale(0.1, 0.1, 1);
//        STView.layer.transform = transform;
//    } completion:^(BOOL finished) {
    
    [STView removeFromSuperview];
    [STViewTwo removeFromSuperview];
        
//    }];

}
- (void)recordDetailSureAction:(id)sender
{
    
    [totalDic setObject:[NSNumber numberWithInt:aiaiIndex] forKey:@"aiaiIndex"];
    [totalDic setObject:[NSNumber numberWithInt:tiwenRow0] forKey:@"tiwenRow0"];
    [totalDic setObject:[NSNumber numberWithInt:tiwenRow1] forKey:@"tiwenRow1"];
    [totalDic setObject:[NSNumber numberWithInt:tizhongRow0] forKey:@"tizhongRow0"];
    [totalDic setObject:[NSNumber numberWithInt:tizhongRow1] forKey:@"tizhongRow1"];
    if (shujuAry ==nil) {
        shujuAry =[NSMutableArray array];
    }
    [totalDic setObject:shujuAry forKey:@"shujuAry"];
    
    [totalDic setObject:[NSNumber numberWithBool:starSwitch.isOn] forKey:@"starSwitch"];
    [totalDic setObject:[NSNumber numberWithBool:endSwitch.isOn] forKey:@"endSwitch"];
    
    if (tongjingData.length ==0) {
        tongjingData =@"轻度";
    }
    if(liuliangData.length ==0){
        liuliangData =@"很少";
    }
    [totalDic setObject:tongjingData forKey:@"tongjing"];
    [totalDic setObject:liuliangData forKey:@"liuliang"];
    
    NSMutableDictionary *resultDic = [NSMutableDictionary dictionaryWithDictionary: [[NSUserDefaults standardUserDefaults] objectForKey:@"resultDic"]];
    if (totalDic ==nil) {
        totalDic =[NSMutableDictionary dictionary];
    }
    [resultDic setObject:totalDic forKey:TodayStr];
    
    NSLog(@"%@",totalDic);
    
    [[NSUserDefaults standardUserDefaults] setObject:resultDic forKey:@"resultDic"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    
    if (starSwitch.isOn==YES &&endSwitch.isOn ==NO) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadDataCl" object:[NSNumber numberWithInt:1]];
    }
    
    if (starSwitch.isOn==NO &&endSwitch.isOn ==YES) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadDataCl" object:[NSNumber numberWithInt:0]];
    }
    if (starSwitch.isOn==YES &&endSwitch.isOn ==YES) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadDataCl" object:[NSNumber numberWithInt:-1]];
    }
    if (starSwitch.isOn==NO &&endSwitch.isOn ==NO) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadDataCl" object:[NSNumber numberWithInt:-99]];
    }
    
    

    
    
    
    [self .navigationController popViewControllerAnimated:YES];
    
    
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
    if (indexPath.row ==2) {
        __block NSString *temozhengz=@"";
        [shujuAry enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            
            temozhengz =[temozhengz stringByAppendingString:[ziAry objectAtIndex:([obj intValue]-1000)]];
            if (idx<shujuAry.count-1) {
                temozhengz =[temozhengz stringByAppendingString:@","];
            }
            
        }];
        cell.zhengzhuangLab.text =temozhengz;
        cell.zhengzhuangLab.textColor =FENSERGB;
        cell.zhengzhuangLab.hidden =NO;
    }else{
        cell.zhengzhuangLab.hidden =YES;
    }
    
    return cell;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    NSLog(@"%li",(long)indexPath.row);
    
    aiaiIndex =[[totalDic objectForKey:@"aiaiIndex"] intValue];
    tiwenRow0=  [[totalDic objectForKey:@"tiwenRow0"] intValue];
    tiwenRow0=  [[totalDic objectForKey:@"tiwenRow0"] intValue];
    tizhongRow0=  [[totalDic objectForKey:@"tizhongRow0"] intValue];
    tizhongRow1=  [[totalDic objectForKey:@"tizhongRow1"] intValue];
    switch (indexPath.row) {
        case 0:{
            
           
            detail.titleNameLab.text =@"爱爱";
           detail.tishiLab.text =@"";
            pickerChose =0;
            [detail.pickerView reloadAllComponents];

            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                [detail.pickerView selectRow:[[totalDic objectForKey:@"aiaiIndex"] intValue] inComponent:0 animated:YES];

                pickerCell *tempView  =(pickerCell *)[detail.pickerView viewForRow:[[totalDic objectForKey:@"aiaiIndex"] intValue] forComponent:0];
                tempView.titleLab.text =[aiaiAry objectAtIndex:[[totalDic objectForKey:@"aiaiIndex"] intValue]];
                tempView.titleLab.textColor = FENSERGB;
                tempView.heartimg.image =[UIImage imageWithContentFileName:@"no_love_logo"];
            });
            
            
            
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
            [detail.pickerView selectRow:[[totalDic objectForKey:@"tiwenRow0"] intValue]  inComponent:0 animated:YES];
             [detail.pickerView selectRow:[[totalDic objectForKey:@"tiwenRow1"] intValue]  inComponent:1 animated:YES];

            
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                pickerCell *tempView  =(pickerCell *)[detail.pickerView viewForRow:[[totalDic objectForKey:@"tiwenRow0"] intValue] forComponent:0];
                

                tempView.titleLab.text  =[tiwenAry0 objectAtIndex:[[totalDic objectForKey:@"tiwenRow0"] intValue]];
                tempView.titleLab.textColor = FENSERGB;
                
                 pickerCell *tempView1  =(pickerCell *)[detail.pickerView viewForRow:[[totalDic objectForKey:@"tiwenRow1"] intValue] forComponent:1];

                tempView1.titleLab.text =[tiwenAry1 objectAtIndex:[[totalDic objectForKey:@"tiwenRow1"] intValue]];
                tempView1.titleLab.textColor = FENSERGB;

});
            
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
            [detailTwo.alterScrollview setContentSize:CGSizeMake(280, 680)];
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
            [detail.pickerView selectRow:[[totalDic objectForKey:@"tizhongRow0"] intValue]  inComponent:0 animated:YES];
            [detail.pickerView selectRow:[[totalDic objectForKey:@"tizhongRow1"] intValue]  inComponent:1 animated:YES];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                pickerCell *tempView  =(pickerCell *)[detail.pickerView viewForRow:[[totalDic objectForKey:@"tizhongRow0"] intValue] forComponent:0];
                
                
                tempView.titleLab.text  =[tizhongAry0 objectAtIndex:[[totalDic objectForKey:@"tizhongRow0"] intValue]];
                tempView.titleLab.textColor = FENSERGB;
                
                pickerCell *tempView1  =(pickerCell *)[detail.pickerView viewForRow:[[totalDic objectForKey:@"tizhongRow1"] intValue] forComponent:1];
                
                tempView1.titleLab.text =[tizhongAry1 objectAtIndex:[[totalDic objectForKey:@"tizhongRow1"] intValue]];
                tempView1.titleLab.textColor = FENSERGB;
                

                
            });
            
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
        aiaiIndex = (int)row;
        
        
    }else if(pickerChose ==1){
        pickerCell *tempView  =(pickerCell *)[pickerView viewForRow:row forComponent:component];
        
        if (component==0) {
            tempView.titleLab.text  =[tiwenAry0 objectAtIndex:row];
            tiwenRow0 =(int)row;
        }else{
            tempView.titleLab.text =[tiwenAry1 objectAtIndex:row];
            tiwenRow1 =(int)row;
        }
        tempView.titleLab.textColor = FENSERGB;
        
        
        
        

        
        
    }else if(pickerChose ==2){
        
        
    }else if(pickerChose ==3){
        
        pickerCell *tempView  =(pickerCell *)[pickerView viewForRow:row forComponent:component];
        
        if (component==0) {
            tempView.titleLab.text  =[tizhongAry0 objectAtIndex:row];
            tizhongRow0 =(int)row;
        }else{
            tempView.titleLab.text =[tizhongAry1 objectAtIndex:row];
            tizhongRow1 =(int)row;
        }
        tempView.titleLab.textColor = FENSERGB;
        
        
    }


   
    
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    
    if (pickerChose ==0) {
        pickerCell *tempView =(pickerCell *)[[[NSBundle mainBundle] loadNibNamed:@"pickerCell" owner:self options:nil] firstObject];
        tempView.titleLab.text =[aiaiAry objectAtIndex:row];

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

- (IBAction)startSwitchClick:(id)sender {
    
    [[NSUserDefaults standardUserDefaults] setBool:((UISwitch *)sender).on forKey:@"startSwitchClick"];
    
    
    
}

- (IBAction)endSwitchClick:(id)sender {
     [[NSUserDefaults standardUserDefaults] setBool:((UISwitch *)sender).on forKey:@"startSwitchClicktwo"];
}
@end
