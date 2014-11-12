//
//  MKNetworkOperation+category.m
//  CMCCMall
//
//  Created by 萧 曦 on 13-4-28.
//  Copyright (c) 2013年 cmcc. All rights reserved.
//

#import "MKNetworkOperation+category.h"

@implementation MKNetworkOperation (category)

/**
	返回解码json
	@returns dic
 */
-(id)responseDecodeToDic
{
    if([self responseData] == nil) return nil;
    
    NSString *str = [self responseString];
    
    NSError *error = nil;
    id returnValue = [NSJSONSerialization JSONObjectWithData:[str dataUsingEncoding:NSUTF8StringEncoding] options:0 error:&error];
    if(error) DLog(@"JSON Parsing Error: %@", error);
    
    return returnValue;
}

@end
