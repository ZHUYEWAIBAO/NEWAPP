//
//  CMSinger.m
//  CloudMouse
//
//  Created by Daniel on 14-10-30.
//  Copyright (c) 2014年 kuanlian. All rights reserved.
//

#import "CMSinger.h"

@implementation CMSinger

+(CMSinger *) share {
    static dispatch_once_t onceToken;
    static CMSinger *shared = nil;
    dispatch_once(&onceToken, ^{
        shared =[[CMSinger alloc]init];
    });
    
    return shared;
}
-(id)init{
    
    if (self =[super init]) {
        self.currenYuejingDayAry =[NSMutableArray array];
        self.paiRuanDateAry =[NSMutableArray array];
        self.yueJingDayAry =[NSMutableArray array];
        self.weixianqiDayAry =[NSMutableArray array];
        
        
    }
    return self;
}
@end
