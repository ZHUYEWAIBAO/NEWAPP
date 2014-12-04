//
//  BannerImageView.m
//  WomenHealthApp
//
//  Created by 朱青 on 14/12/2.
//  Copyright (c) 2014年 WomenHealthApp. All rights reserved.
//

#import "BannerImageView.h"

@implementation BannerImageView

//实现NSCopying协议的方法，来使此类具有copy功能
- (id)copyWithZone:(NSZone *)zone
{
    BannerImageView *newFract = [[BannerImageView allocWithZone:zone] init];
    
    return newFract;
}


@end
