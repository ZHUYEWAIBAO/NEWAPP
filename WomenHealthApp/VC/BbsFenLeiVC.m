//
//  BbsFenLeiVC.m
//  WomenHealthApp
//
//  Created by Daniel on 14/11/15.
//  Copyright (c) 2014年 WomenHealthApp. All rights reserved.
//

#import "BbsFenLeiVC.h"
#import "BbsFenLeiCell.h"
@interface BbsFenLeiVC ()

@end

@implementation BbsFenLeiVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.title =@"圈子分类";
    
    // Do any additional setup after loading the view from its nib.
}

#pragma mark tableview
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 7;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    static NSString *indertifier =@"BbsFenLeiCell";
    
    BbsFenLeiCell *cell =[tableView dequeueReusableCellWithIdentifier:indertifier];
    if (cell ==nil) {
        cell =(BbsFenLeiCell *)[[[NSBundle mainBundle] loadNibNamed:@"BbsFenLeiCell" owner:self options:nil] lastObject];
    }
    
    
    return cell;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    [UIView animateWithDuration:0.5 animations:^{
        
        self.fenleiTable.frame =CGRectMake(-100, 50, 320, 518);
        
    }];
    
    
    [UIView animateWithDuration:0.5 animations:^{
        
        self.fenLeiRightTable.frame =CGRectMake(50, 50, 270, 518);
        
    }];
    
    

    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 60;
}


- (void)didReceiveMemoryWarning
{
    
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
