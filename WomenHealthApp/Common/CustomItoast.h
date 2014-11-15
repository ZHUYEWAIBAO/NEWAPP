//
//  CustomItoast.h
//  CMCCMall
//
//  Created by 朱 青 on 14-7-29.
//  Copyright (c) 2014年 cmcc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CustomItoast : NSObject
{
    NSString *text;
}

+ (CustomItoast *) showText:(NSString *)text;

- (void)showInView:(UIView *)parentView;

@end
