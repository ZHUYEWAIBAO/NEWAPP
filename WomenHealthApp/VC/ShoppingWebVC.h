//
//  ShoppingWebVC.h
//  WomenHealthApp
//
//  Created by 朱青 on 14/12/1.
//  Copyright (c) 2014年 WomenHealthApp. All rights reserved.
//

#import "BasicVC.h"

@interface ShoppingWebVC : BasicVC

@property (weak, nonatomic) IBOutlet UIWebView *webView;

@property (strong, nonatomic) NSString  *webUrl;

@end
