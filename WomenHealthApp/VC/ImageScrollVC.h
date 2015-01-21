//
//  ImageScrollVC.h
//  WomenHealthApp
//
//  Created by 朱青 on 15/1/14.
//  Copyright (c) 2015年 WomenHealthApp. All rights reserved.
//

#import "BasicVC.h"

@interface ImageScrollVC : BasicVC

@property (weak,nonatomic)IBOutlet UIScrollView *imagesScrollView;

@property (strong,nonatomic)NSMutableArray *imagesArray;

@property (assign,nonatomic)NSInteger selectIndex;

@property (assign,nonatomic)BOOL isFromPostDetail;

@end
