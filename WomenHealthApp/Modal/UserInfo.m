//
//  UserInfo.m
//  YueDongApp
//
//  Created by 朱 青 on 14-8-5.
//  Copyright (c) 2014年 朱 青. All rights reserved.
//

#import "UserInfo.h"

@implementation UserInfo

+(UserInfo *) share
{
    static dispatch_once_t pred;
    static UserInfo *shared = nil;
    dispatch_once(&pred, ^{
        shared = [[UserInfo alloc] init];
    });
    return shared;
}

- (void)parseDicToUserInfoModel:(NSDictionary*)dic
{
    self.uid = CHECK_VALUE([dic objectForKey:@"uid"]);
    self.username = CHECK_VALUE([dic objectForKey:@"username"]);
    self.user_icon = CHECK_VALUE([dic objectForKey:@"user_icon"]);

    
}

- (void)loginOutForUserInfoModel
{
//    self.user_id = @"";
//    self.username = @"";
//    self.code = @"";
//    self.head_pic = @"";
//    self.nicheng = @"";
//    self.lastlogintime = @"";
//    self.email = @"";
//    self.realname = @"";
//    self.money = @"";
    
}

@end
