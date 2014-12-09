//
//  CategoryViewController.m
//  WomenHealthApp
//
//  Created by 朱青 on 14/12/3.
//  Copyright (c) 2014年 WomenHealthApp. All rights reserved.
//

#import "CategoryViewController.h"
#import "CategoryModel.h"

@interface CategoryViewController ()
{
    NSMutableArray *btnArray;
}
@end

@implementation CategoryViewController

- (void)loadView
{
    [super loadView];
    
    self.title = @"筛选";

}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIButton *rightButton=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
    [rightButton addTarget:self action:@selector(categorySureAction:) forControlEvents:UIControlEventTouchUpInside];
    [rightButton setBackgroundImage:[UIImage imageWithContentFileName:@"Record_detail_sure_btn.png"] forState:UIControlStateNormal];
    UIBarButtonItem *rightButtonItem=[[UIBarButtonItem alloc]initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem = rightButtonItem;
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyboardHide)];
    //设置成NO表示当前控件响应后会传播到其他控件上，默认为YES。
    tapGestureRecognizer.cancelsTouchesInView = NO;
    //将触摸事件添加到当前view
    [self.linearLayoutView addGestureRecognizer:tapGestureRecognizer];
    
    btnArray = [[NSMutableArray alloc]initWithCapacity:5];
    
    [self setViewLayer:self.minTextField andCornerRadius:0 andBorderColor:[UIColor lightGrayColor] andBorderWidth:0.6f];
    
    [self setViewLayer:self.maxTextField andCornerRadius:0 andBorderColor:[UIColor lightGrayColor] andBorderWidth:0.6f];
    
    [self getTheCategoryData];
    
}

- (void)getTheCategoryData
{
    [self.params removeAllObjects];
    
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];
    
    [NETWORK_ENGINE requestWithPath:@"/api/ec/?mod=category&level=1" Params:self.params CompletionHandler:^(MKNetworkOperation *completedOperation) {
        
        NSDictionary *dic=[completedOperation responseDecodeToDic];
        
        NSDictionary *statusDic = [dic objectForKey:@"status"];
        
        if ([@"1" isEqualToString:CHECK_VALUE([statusDic objectForKey:@"statu"])]) {
            
            NSDictionary *data = [dic objectForKey:@"data"];
            
            NSMutableArray *strArray = [[NSMutableArray alloc]init];
            
            for (NSDictionary *dictionary in [data objectForKey:@"list"]) {
                
                CategoryModel *model = [CategoryModel parseDicToCategoryModelObject:dictionary];
                [strArray addObject:model];
            }
            
            [self layOutTheMenuView:strArray];
            
            [SVProgressHUD dismiss];
        }
        else{
            [SVProgressHUD showErrorWithStatus:CHECK_VALUE([statusDic objectForKey:@"msg"])];
        }
        
    } ErrorHandler:^(MKNetworkOperation *completedOperation, NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"服务器忙，请稍候再试"];
    }];

}

- (void)layOutTheMenuView:(NSMutableArray *)array
{
    [array enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        CategoryModel *model = (CategoryModel *)obj;
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:model.category_name forState:UIControlStateNormal];
        [button.titleLabel setFont:[UIFont systemFontOfSize:12.0]];
        [button setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [button setTitleColor:MAIN_RED_COLOR forState:UIControlStateSelected];
        [button setBackgroundImage:[UIImage imageWithContentFileName:@"screening_btn_noraml"] forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage imageWithContentFileName:@"screening_btn_active"] forState:UIControlStateSelected];
        [button addTarget:self action:@selector(categoryChooseAction:) forControlEvents:UIControlEventTouchUpInside];
        
        [btnArray addObject:button];
        
        if (idx > 0) {
            
            UIButton *foreButton = [btnArray objectAtIndex:idx - 1];
            
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

        [self.goodsMenuView addSubview:button];
        
        if (idx == array.count - 1) {
            
            CGRect rect = self.goodsMenuView.frame;

            rect.size.height = button.frame.origin.y + button.frame.size.height + catebuttonInSety;
            
            self.goodsMenuView.frame = rect;
            
        }

        
    }];
    
    NSMutableArray *arr = [NSMutableArray arrayWithObjects:self.priceHeadView,self.goodsMenuView,self.goodsTypeView, nil];
    [self layOutTheMainView:arr];

}

- (void)layOutTheMainView:(NSMutableArray *)viewArray
{
    //最外层
    _linearLayoutView.orientation = CSLinearLayoutViewOrientationVertical;
    _linearLayoutView.scrollEnabled = YES;
    _linearLayoutView.showsVerticalScrollIndicator = NO;
    _linearLayoutView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    

    for (UIView *view in viewArray) {
        CSLinearLayoutItem *item = [CSLinearLayoutItem layoutItemForView:view];
        item.padding = CSLinearLayoutMakePadding(5.0, 0.0, 0.0, 0.0);
        item.horizontalAlignment = CSLinearLayoutItemHorizontalAlignmentCenter;
        
        [_linearLayoutView addItem:item];
        
    }
}

#pragma mark - 按钮事件
- (void)categoryChooseAction:(id)sender
{

    for (UIButton *btn in btnArray) {
        btn.selected = NO;
    }
    UIButton *button = (UIButton *)sender;
    button.selected = YES;
}

- (IBAction)typeClickAction:(id)sender
{
    UIButton *button = (UIButton *)sender;
    button.selected = YES;
}

- (void)categorySureAction:(id)sender
{
    
}

- (void)keyboardHide
{
    [self.maxTextField resignFirstResponder];
    [self.minTextField resignFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
