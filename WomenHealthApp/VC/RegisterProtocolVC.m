//
//  RegisterProtocolVC.m
//  YueDongApp
//
//  Created by 朱 青 on 14-8-6.
//  Copyright (c) 2014年 朱 青. All rights reserved.
//

#import "RegisterProtocolVC.h"

@interface RegisterProtocolVC ()

@end

@implementation RegisterProtocolVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)loadView
{
    [super loadView];
    
    self.title = @"用户协议";

}

- (void)viewDidLoad
{
    [super viewDidLoad];

    
    
    self.firstTitleLabel.frame = CGRectMake(self.firstTitleLabel.frame.origin.x, self.firstTitleLabel.frame.origin.y, self.firstTitleLabel.frame.size.width, HeightForString(self.firstTitleLabel.text, 10, 300)+10);
    self.firstContentLabel.frame = CGRectMake(self.firstContentLabel.frame.origin.x, self.firstTitleLabel.frame.origin.y + self.firstTitleLabel.frame.size.height, self.firstContentLabel.frame.size.width, HeightForString(self.firstContentLabel.text, 10, 300)+10);
    
    self.secondTitleLabel.frame = CGRectMake(self.secondTitleLabel.frame.origin.x, self.firstContentLabel.frame.origin.y + self.firstContentLabel.frame.size.height, self.secondTitleLabel.frame.size.width, HeightForString(self.secondTitleLabel.text, 10, 300)+10);
    self.secondContentLabel.frame = CGRectMake(self.secondContentLabel.frame.origin.x, self.secondTitleLabel.frame.origin.y + self.secondTitleLabel.frame.size.height, self.secondContentLabel.frame.size.width, HeightForString(self.secondContentLabel.text, 10, 300)+10);
    
    self.thirdTitleLabel.frame = CGRectMake(self.thirdTitleLabel.frame.origin.x, self.secondContentLabel.frame.origin.y + self.secondContentLabel.frame.size.height, self.thirdTitleLabel.frame.size.width, HeightForString(self.thirdTitleLabel.text, 10, 300)+10);
    self.thirdContentLabel.frame = CGRectMake(self.thirdContentLabel.frame.origin.x, self.thirdTitleLabel.frame.origin.y + self.thirdTitleLabel.frame.size.height, self.thirdContentLabel.frame.size.width, HeightForString(self.thirdContentLabel.text, 10, 300)+10);
    
    self.fourthTitleLabel.frame = CGRectMake(self.fourthTitleLabel.frame.origin.x, self.thirdContentLabel.frame.origin.y + self.thirdContentLabel.frame.size.height, self.fourthTitleLabel.frame.size.width, HeightForString(self.fourthTitleLabel.text, 10, 300)+10);
    self.fourthContentLabel.frame = CGRectMake(self.fourthContentLabel.frame.origin.x, self.fourthTitleLabel.frame.origin.y + self.fourthTitleLabel.frame.size.height, self.fourthContentLabel.frame.size.width, HeightForString(self.fourthContentLabel.text, 10, 300)+10);
    
    self.fifthTitleLabel.frame = CGRectMake(self.fifthTitleLabel.frame.origin.x, self.fourthContentLabel.frame.origin.y + self.fourthContentLabel.frame.size.height, self.fifthTitleLabel.frame.size.width, HeightForString(self.fifthTitleLabel.text, 10, 300)+10);
    self.fifthContentLabel.frame = CGRectMake(self.fifthContentLabel.frame.origin.x, self.fifthTitleLabel.frame.origin.y + self.fifthTitleLabel.frame.size.height, self.fifthContentLabel.frame.size.width, HeightForString(self.fifthContentLabel.text, 10, 300)+10);
    
    self.sixTitleLabel.frame = CGRectMake(self.sixTitleLabel.frame.origin.x, self.fifthContentLabel.frame.origin.y + self.fifthContentLabel.frame.size.height, self.sixTitleLabel.frame.size.width, HeightForString(self.sixTitleLabel.text, 10, 300)+10);
    self.sixContentLabel.frame = CGRectMake(self.sixContentLabel.frame.origin.x, self.sixTitleLabel.frame.origin.y + self.sixTitleLabel.frame.size.height, self.sixContentLabel.frame.size.width, HeightForString(self.sixContentLabel.text, 10, 300)+10);
    
    self.sevenTitleLabel.frame = CGRectMake(self.sevenTitleLabel.frame.origin.x, self.sixContentLabel.frame.origin.y + self.sixContentLabel.frame.size.height, self.sevenTitleLabel.frame.size.width, HeightForString(self.sevenTitleLabel.text, 10, 300)+10);
    self.sevenContentLabel.frame = CGRectMake(self.sevenContentLabel.frame.origin.x, self.sevenTitleLabel.frame.origin.y + self.sevenTitleLabel.frame.size.height, self.sevenContentLabel.frame.size.width, HeightForString(self.sevenContentLabel.text, 10, 300)+10);
    
    
    [self.textScrollView setContentSize:CGSizeMake(self.view.bounds.size.width, self.sevenContentLabel.frame.origin.y + self.sevenContentLabel.frame.size.height +10)];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
