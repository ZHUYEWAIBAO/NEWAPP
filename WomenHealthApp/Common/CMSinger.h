//
//  CMSinger.h
//  CloudMouse
//
//  Created by Daniel on 14-10-30.
//  Copyright (c) 2014年 kuanlian. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CMSinger : NSObject

+(CMSinger *) share ;
@property(nonatomic,strong) NSDate *singerDate;


@property(nonatomic,strong)   NSMutableArray *currenYuejingDayAry;
@property(nonatomic,strong)   NSMutableArray *paiRuanDateAry;

@property(nonatomic,strong)   NSMutableArray *yueJingDayAry;
@property(nonatomic,strong)   NSMutableArray *weixianqiDayAry;

@property(nonatomic)    int durationDay;

@end
