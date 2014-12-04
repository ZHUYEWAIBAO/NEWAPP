//
//  CalculateHigh.h
//  CMCCMall
//
//  Created by 周易 on 13-7-13.
//  Copyright (c) 2013年 cmcc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CalculateHigh : NSObject

+ (float) heightForString:(NSString *)value fontSize:(float)fontSize andWidth:(float)width;

+ (float) widthForString:(NSString *)value fontSize:(float)fontSize andWidth:(float)width;

@end
