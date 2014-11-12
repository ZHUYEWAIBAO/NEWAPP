//
//  UIImage+imageContent.m
//  CMCCMall
//
//  Created by user on 13-7-25.
//  Copyright (c) 2013年 cmcc. All rights reserved.
//

#import "UIImage+imageContent.h"

#define FILEPATH (@"ShareSDKiPhoneDefaultShareViewUI.bundle/RefreshHeader")
@implementation UIImage(imageContent)

+ (UIImage *)imageWithContentFileName:(NSString *)imageName{
    if (imageName.length == 0) {
        return nil;
    }
    NSArray *array = [imageName componentsSeparatedByString:@"."];
    if ([array count] > 1) {
        NSString *filePath = [[NSBundle mainBundle]pathForResource:[array objectAtIndex:0] ofType:[array objectAtIndex:1]];
        return [UIImage imageWithContentsOfFile:filePath];
    }
    return [UIImage imageNamed:imageName];

}

+ (UIImage *)imagesNamedFromCustomBundle:(NSString *)imgName
{
    if (imgName.length == 0) {
        return nil;
    }
    NSString *file_path = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:FILEPATH];
    if (FILEPATH) {
        NSString *img_path = [file_path stringByAppendingPathComponent:imgName];
        return [UIImage imageWithContentsOfFile:img_path];
    }
    return nil;
}

+ (UIImage *)resizableImageName:(NSString *)imgName  WithCapInsets:(UIEdgeInsets)capInsets
{
    if (imgName.length == 0) {
        return nil;
    }
    UIImage *img=[UIImage imageWithContentFileName:imgName];
    img=[img resizableImageWithCapInsets:capInsets resizingMode:UIImageResizingModeStretch];
    if (img) {
        return img;
    }
    return [UIImage imageWithContentFileName:imgName];
}


@end
