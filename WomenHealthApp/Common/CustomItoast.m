//
//  CustomItoast.m
//  CMCCMall
//
//  Created by 朱 青 on 14-7-29.
//  Copyright (c) 2014年 cmcc. All rights reserved.
//

#import "CustomItoast.h"

@implementation CustomItoast

- (id) initWithText:(NSString *)tex{
	if (self = [super init]) {
		text = [tex copy];
	}
	
	return self;
}

+ (CustomItoast *) showText:(NSString *)text{

	CustomItoast *toast = [[CustomItoast alloc] initWithText:text];
    
	return toast;
}

- (void)showInView:(UIView *)parentView
{
	UIFont *font = [UIFont systemFontOfSize:15];
	CGSize textSize = [text sizeWithFont:font constrainedToSize:CGSizeMake(130, 60)];
	
	UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, textSize.width + 25, textSize.height + 25)];
	label.backgroundColor = [UIColor clearColor];
	label.textColor = [UIColor whiteColor];
	label.font = font;
	label.text = text;
	label.numberOfLines = 0;
	label.textAlignment= NSTextAlignmentCenter;
    
	UIButton *v = [UIButton buttonWithType:UIButtonTypeCustom];

    v.frame = CGRectMake(0, 0, textSize.width + 30, textSize.height + 20);
    label.center = CGPointMake(v.frame.size.width / 2, v.frame.size.height / 2);
	
	[v addSubview:label];

	v.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.7];
	v.layer.cornerRadius = 5;
		
	CGPoint point = CGPointMake(parentView.frame.size.width/2, parentView.frame.size.height/2);
    
	v.center = point;
		
	[parentView addSubview:v];
	

    [self performSelector:@selector(hideToast:) withObject:v afterDelay:1.0f];


}

- (void) hideToast:(UIButton *)button
{
    [UIView animateWithDuration:1.5f animations:^{
        button.alpha = 0;
    } completion:^(BOOL finished) {
        [button removeFromSuperview];
    }];

}

@end
