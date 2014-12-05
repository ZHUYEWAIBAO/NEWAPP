//
//  UITabbarCommonViewController.m
//  CMCCMall
//
//  Created by user on 13-11-14.
//  Copyright (c) 2013年 cmcc. All rights reserved.
//

#import "UITabbarCommonViewController.h"

//底部Tab高度
#define TABBAR_HEIGHT 49
#define ITEM_IMAGE_HEIGHT 25

@interface UITabBarCommonView()
{
    UIImage *mSlImage;
    UIImage *mUnSImage;
}

@end

@implementation UITabBarCommonView

- (id)initWithFrame:(CGRect)frame ItemImage:(UIImage *)mImage selectItemImage:(UIImage *)slImage itemTitle:(NSString*)mTitle
{
    if (self = [super initWithFrame:frame]) {
       
        //底部view
        UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        bgView.backgroundColor =[UIColor clearColor];

        [self addSubview:bgView];
                                 
        //item图片
        _itemImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 80, TABBAR_HEIGHT)];
        [_itemImage setImage:mImage];
        [bgView addSubview:_itemImage];


        //覆盖button
        _cupBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_cupBtn setFrame:bgView.bounds];
        [bgView addSubview:_cupBtn];
        
        mSlImage = slImage;
        mUnSImage = mImage;

        //add by zhuqing-----tabbar上显示badge
        _showBadgeView = [[UIView alloc]initWithFrame:CGRectMake(_itemImage.frame.origin.x + _itemImage.frame.size.width,2,22, 13)];
        _showBadgeView.backgroundColor =[UIColor clearColor];
        
        //默认隐藏
        [_showBadgeView setHidden:YES];
        [self addSubview:_showBadgeView];
        
        UIImageView *badgeBgImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, _showBadgeView.frame.size.width, _showBadgeView.frame.size.height)];
        [badgeBgImageView setImage:[UIImage imageWithContentFileName:@"b2c_shopcar_badge.png"]];
        
        [_showBadgeView addSubview:badgeBgImageView];
        
        _showBadgeLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, _showBadgeView.frame.size.width, _showBadgeView.frame.size.height)];
        _showBadgeLabel.font = [UIFont systemFontOfSize:9.0];
        _showBadgeLabel.backgroundColor = [UIColor clearColor];
        _showBadgeLabel.textAlignment = NSTextAlignmentCenter;
        _showBadgeLabel.textColor = [UIColor whiteColor];
        
        [_showBadgeView addSubview:_showBadgeLabel];
        
        //============================================
        

    }
    return self;
}

- (void)setItemSelected
{
    [_itemImage setImage:mSlImage];

}

- (void)setItemUnSelected
{
    [_itemImage setImage:mUnSImage];

}

@end

@interface UITabbarCommonViewController ()
{
    UIView *contentView;
}

@end

@implementation UITabbarCommonViewController

@synthesize mTabbarView;
@synthesize mContentView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    if (self.viewControllers.count == self.images.count && self.viewControllers.count == self.titles.count) {
        _itemArys = [[NSMutableArray alloc]initWithCapacity:self.viewControllers.count];
        [self setUpTabBar];
        //默认选中
        [self setSelectWithIndex:0];
    }
    // Do any additional setup after loading the view from its nib.
}

//tabbar View
- (void)setUpTabBar
{
    //内容view
    contentView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_SIZE.width, SCREEN_SIZE.height - TABBAR_HEIGHT - 20)];
    contentView.backgroundColor = [UIColor clearColor];
    self.mContentView = contentView;
    [self.view addSubview:mContentView];
    
    UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(0, SCREEN_SIZE.height - TABBAR_HEIGHT - 20, SCREEN_SIZE.width, TABBAR_HEIGHT)];
    //解决ios7中tabbar20像素的问题
    if (IOS7) {
        [backView setFrame:CGRectMake(0, SCREEN_SIZE.height - TABBAR_HEIGHT, SCREEN_SIZE.width, TABBAR_HEIGHT)];
        CGRect cFrame = contentView.frame;
        cFrame.size.height += 20;
        contentView.frame = cFrame;
    }
    self.mTabbarView = backView;
    [self.view addSubview:mTabbarView];
    
    //item背景
//    UIImageView *bgImageV = [[UIImageView alloc]initWithFrame:backView.bounds];
//    [bgImageV setImage:[UIImage imageWithContentFileName:@"new_tab_bg.png"]];
//    [backView addSubview:bgImageV];
   
    UIImageView *bgImageV = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, backView.bounds.size.width, 0.5)];
    [bgImageV setBackgroundColor:[UIColor colorWithRed:178.0/255.0 green:178.0/255.0 blue:178.0/255.0 alpha:1.0]];
    [backView addSubview:bgImageV];
    [backView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageWithContentFileName:@"new_tab_bg.png"]]];
    
    for (int i = 0; i < [self.images count]; i++) {
        UIImage *image = [self.images objectAtIndex:i];
        UIImage *sImage = [self.selectImages objectAtIndex:i];
        NSString *title = [self.titles objectAtIndex:i];
        
        CGFloat width = SCREEN_SIZE.width / self.images.count;

        UITabBarCommonView *tabItem = [[UITabBarCommonView alloc]initWithFrame:CGRectMake(width * i, 0, width, TABBAR_HEIGHT) ItemImage:image selectItemImage:sImage itemTitle:title];
        
        tabItem.tag = i+4000;
        [tabItem.cupBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        tabItem.cupBtn.tag  = i;
        [backView addSubview:tabItem];
        [_itemArys addObject:tabItem];
        


    }

}

//选中的index
- (void)setSelectWithIndex:(NSUInteger)index
{
    self.title = [self.titles objectAtIndex:index];

    if ([self.viewControllers count] > index) {
        self.currentIndex=index;
        [self setTheTitleWithIndex:index];
        [self setSelectItemWithIndex:index];
        [self setContentViewWithIndex:index];
    }
}

//设置title
- (void)setTheTitleWithIndex:(NSInteger)index
{
//    UIViewController *controller = [self.viewControllers objectAtIndex:index];
//    if (![self whetherTheMainListVC:controller]) {
//        [self setTitle:[self.titles objectAtIndex:index]];
//    }
//    else{
//        self.title = @"";
//    }
}

//设置controller的view
- (void)setContentViewWithIndex:(NSInteger)index
{
    if ([self.viewControllers count] > index) {
        for (UIView *view in [contentView subviews]) {
            [view removeFromSuperview];
        }
        UIViewController *controller = [self.viewControllers objectAtIndex:index];
        if ([controller isKindOfClass:[UINavigationController class]]) {
//            [(UINavigationController *)controller popToRootViewControllerAnimated:NO];
        }
        [controller.view setFrame:contentView.bounds];
        self.currentController = controller;
        [contentView addSubview:controller.view];
    }
}

//设置tabbar点中效果
- (void)setSelectItemWithIndex:(NSUInteger)index
{
    if ([_itemArys count] > index) {
        for (int i = 0; i < [_itemArys count]; i++) {
             UITabBarCommonView *item = [_itemArys objectAtIndex:i];
            if (i == index) {
                [item setItemSelected];
            }
            else{
                [item setItemUnSelected];
            }
        }
    }
}

- (void)btnClick:(id)sender
{
    UIButton *button = (UIButton *)sender;
    [self setSelectWithIndex:button.tag];
   
}

//设置底部tabbar隐藏
+ (void)setTabbarViewHidden
{
       
    UITabbarCommonViewController *controller =(UITabbarCommonViewController *)[WHSinger share].customTabbr;
    if (![controller isKindOfClass:[UITabbarCommonViewController class]]) {
        return;
    }
    [controller.mTabbarView setHidden:YES];
    CGRect cFrame = controller.mContentView.frame;
    
    //判断mContentView的高度是否等于屏幕高度，如果等于就返回，不等于就加Tabbar高度
    if (IOS7&&cFrame.size.height==SCREEN_SIZE.height) {

        return;

    }
    if (!IOS7&&cFrame.size.height==SCREEN_SIZE.height-20) {
        return;
    }
    cFrame.size.height += TABBAR_HEIGHT;
    controller.mContentView.frame = cFrame;

}

//设置底部tabbar显示
+ (void)setTabbarViewShow
{
    
    UITabbarCommonViewController *controller=(UITabbarCommonViewController *) [WHSinger share].customTabbr;
    if (![controller isKindOfClass:[UITabbarCommonViewController class]]) {
        return;
    }
    

    [controller.mTabbarView setHidden:NO];
    CGRect cFrame = controller.mContentView.frame;
    
    //判断mContentView的高度是否等于屏幕高度，如果不等于就返回，等于就减去Tabbar高度
    if (IOS7&&cFrame.size.height!=SCREEN_SIZE.height) {
        return;
    }
    if (!IOS7&&cFrame.size.height!=SCREEN_SIZE.height-20) {
        return;
    }
    cFrame.size.height -= TABBAR_HEIGHT;
    controller.mContentView.frame = cFrame;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
