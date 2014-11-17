//
//  WHSinger.m
//  WomenHealthApp
//
//  Created by Daniel on 14/11/15.
//  Copyright (c) 2014年 WomenHealthApp. All rights reserved.
//

#import "WHSinger.h"

@implementation WHSinger
/**
 单例
 @returns
 */
+(WHSinger *)share {
    static dispatch_once_t pred;
    static WHSinger *shared = nil;
    dispatch_once(&pred, ^{
        shared = [[WHSinger alloc] init];
    });
    return shared;
}

@end
