//
//  LoginDataModel.m
//  YueDongApp
//
//  Created by 朱 青 on 14-8-7.
//  Copyright (c) 2014年 朱 青. All rights reserved.
//

#import "LoginDataModel.h"

@implementation LoginDataModel

- (id)initWithCoder:(NSCoder *)aDecoder
{
     self = [super init];
     if (self) {
         self.loginPhoneNum = [aDecoder decodeObjectForKey:@"loginPhoneNum"];
         self.loginPassword = [aDecoder decodeObjectForKey:@"loginPassword"];
         self.thirdUid = [aDecoder decodeObjectForKey:@"thirdUid"];
         self.loginType = [aDecoder decodeObjectForKey:@"loginType"];
     }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.loginPhoneNum forKey:@"loginPhoneNum"];
    [aCoder encodeObject:self.loginPassword forKey:@"loginPassword"];
    [aCoder encodeObject:self.thirdUid forKey:@"thirdUid"];
    [aCoder encodeObject:self.loginType forKey:@"loginType"];
}


+ (LoginDataModel *)rememberLoginPhoneNum:(NSString *)phoneNum andPassword:(NSString *)password andThirdUid:(NSString *)thirdUid andLoginType:(NSString *)loginType remember:(BOOL)isRemember
{
    LoginDataModel *model = [[LoginDataModel alloc]init];
    
    if (isRemember) {
        
        model.loginType = loginType;
        
        if ([@"3" isEqualToString:loginType]) {
            model.loginPhoneNum = phoneNum;
            model.loginPassword = password;
            model.thirdUid = @"";
           
        }
        else{
            model.loginPhoneNum = @"";
            model.loginPassword = @"";
            model.thirdUid = thirdUid;
        }
        
    }
    else {
        model.loginPhoneNum = @"";
        model.loginPassword = @"";
        model.thirdUid = @"";
        model.loginType = @"";
    }
    
    return model;
    
}

@end
