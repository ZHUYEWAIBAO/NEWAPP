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
    self.user_id = CHECK_VALUE([dic objectForKey:@"user_id"]);
    self.username = CHECK_VALUE([dic objectForKey:@"username"]);
    self.code = CHECK_VALUE([dic objectForKey:@"code"]);
    self.head_pic = CHECK_VALUE([dic objectForKey:@"head_pic"]);
    self.nicheng = CHECK_VALUE([dic objectForKey:@"nicheng"]);
    self.lastlogintime = CHECK_VALUE([dic objectForKey:@"lastlogintime"]);
    self.email = CHECK_VALUE([dic objectForKey:@"email"]);
    self.realname = CHECK_VALUE([dic objectForKey:@"realname"]);
    self.money = CHECK_VALUE([dic objectForKey:@"money"]);
    
}

- (void)loginOutForUserInfoModel
{
    self.user_id = @"";
    self.username = @"";
    self.code = @"";
    self.head_pic = @"";
    self.nicheng = @"";
    self.lastlogintime = @"";
    self.email = @"";
    self.realname = @"";
    self.money = @"";
    
}

@end
