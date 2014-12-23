//
//  ShoppingCommentView.m
//  WomenHealthApp
//
//  Created by 朱青 on 14/12/9.
//  Copyright (c) 2014年 WomenHealthApp. All rights reserved.
//

#import "ShoppingCommentView.h"

@implementation ShoppingCommentView

- (void)awakeFromNib
{
    //设置UIImageView显示为圆形
    self.userImageView.layer.cornerRadius = self.userImageView.frame.size.width / 2;
    self.userImageView.layer.masksToBounds = YES;
}

@end
