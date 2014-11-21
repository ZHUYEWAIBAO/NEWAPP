//
//  BBSMenuModal.m
//  WomenHealthApp
//
//  Created by 朱 青 on 14-11-20.
//  Copyright (c) 2014年 WomenHealthApp. All rights reserved.
//

#import "BBSMenuModal.h"

@implementation BBSMenuModal

+ (BBSMenuModal *)parseDicToMenuListObject:(NSDictionary*)dic
{
    BBSMenuModal *modal = [[BBSMenuModal alloc]init];
    
    modal.bbsFid = CHECK_VALUE([dic objectForKey:@"fid"]);
    modal.bbsName = CHECK_VALUE([dic objectForKey:@"name"]);
    modal.bbsDescription = CHECK_VALUE([dic objectForKey:@"description"]);
    modal.bbsIcon = CHECK_VALUE([dic objectForKey:@"icon"]);
    modal.bbs_is_attention = CHECK_VALUE([dic objectForKey:@"is_attention"]);
    
    return modal;
}

@end
