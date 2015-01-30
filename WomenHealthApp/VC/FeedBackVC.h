//
//  FeedBackVC.h
//  WomenHealthApp
//
//  Created by 朱青 on 15/1/21.
//  Copyright (c) 2015年 WomenHealthApp. All rights reserved.
//

#import "BasicVC.h"
#import "CSLinearLayoutView.h"
#import "UIPlaceHolderTextView.h"

@interface FeedBackVC : BasicVC

@property (weak, nonatomic) IBOutlet UIScrollView *suggestScrollView;

@property (strong, nonatomic) IBOutlet UIView *titleView;
@property (strong, nonatomic) IBOutlet UIView *contentView;
@property (strong, nonatomic) IBOutlet UIView *emailView;
@property (strong, nonatomic) IBOutlet UIView *typeView;

@property (weak, nonatomic) IBOutlet UITextField *titleTextField;
@property (weak, nonatomic) IBOutlet UIPlaceHolderTextView *contentTextView;
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
//@property (weak, nonatomic) IBOutlet UITextField *titleTextField;

@property (weak, nonatomic) IBOutlet UIImageView *selectImageV0;
@property (weak, nonatomic) IBOutlet UIImageView *selectImageV1;
@property (weak, nonatomic) IBOutlet UIImageView *selectImageV2;
@property (weak, nonatomic) IBOutlet UIImageView *selectImageV3;
@property (weak, nonatomic) IBOutlet UIImageView *selectImageV4;

@property (strong, nonatomic) NSMutableArray *imageArray;

@end
