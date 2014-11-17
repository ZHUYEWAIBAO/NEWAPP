//
//  UIColor+RGBCo.m
//  CloudMouse
//
//  Created by Daniel on 14-11-13.
//  Copyright (c) 2014年 kuanlian. All rights reserved.
//

#import "UIColor+RGBCo.h"

@implementation UIColor (RGBCo)

+(UIColor *)NewcolorWithRed:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue alpha:(CGFloat)alphaNew{
    
    
    UIColor *color =[UIColor colorWithRed:red/255.0f green:blue/255.0f blue:blue/255.0f alpha:alphaNew];
    return color;
    
}
@end
