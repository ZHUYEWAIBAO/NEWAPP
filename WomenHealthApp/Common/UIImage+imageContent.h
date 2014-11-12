//
//  UIImage+imageContent.h
//  CMCCMall
//
//  Created by user on 13-7-25.
//  Copyright (c) 2013年 cmcc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UIImage(imageContent)

+ (UIImage *)imageWithContentFileName:(NSString *)imageName;

//读取bundle中的图片
+ (UIImage *)imagesNamedFromCustomBundle:(NSString *)imgName;

//部分拉伸图片方法（ios6以上支持）
+ (UIImage *)resizableImageName:(NSString *)imgName WithCapInsets:(UIEdgeInsets)capInsets;
@end
