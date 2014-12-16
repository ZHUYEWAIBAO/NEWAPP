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
    
    self.title = @"服务条款";

}

- (void)viewDidLoad
{
    [super viewDidLoad];

    
    self.firstContentLabel.frame = CGRectMake(self.firstContentLabel.frame.origin.x, self.firstContentLabel.frame.origin.y, self.firstContentLabel.frame.size.width, HeightForString(self.firstContentLabel.text, 10, 300)+10);
     
    [self.textScrollView setContentSize:CGSizeMake(self.view.bounds.size.width, self.firstContentLabel.frame.origin.y + self.firstContentLabel.frame.size.height +10)];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
