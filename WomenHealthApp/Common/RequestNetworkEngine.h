//
//  RequestNetworkEngine.h
//  YueDongApp
//
//  Created by 朱 青 on 14-8-5.
//  Copyright (c) 2014年 朱 青. All rights reserved.
//

#import "MKNetworkEngine.h"
#import "MKNetworkOperation+category.h"

@interface RequestNetworkEngine : MKNetworkEngine

/**
 生成请求
 @param path path description
 @param params params description
 @param  response  response description
 @param   description
 @returns return value description
 */
-(MKNetworkOperation*)requestWithPath:(NSString*)path Params:(NSMutableDictionary*)params  CompletionHandler:(MKNKResponseBlock) response ErrorHandler:(MKNKResponseErrorBlock) error;


/**
 生成请求
 @param remoteURL 远程文件地址
 @param filePath 本地文件地址
 @param  hostName
 @returns return value description
 */
-(MKNetworkOperation*) downloadFatAssFileFrom:(NSString*)remoteURL toFile:(NSString*) filePath CompletionHandler:(MKNKResponseBlock) response ErrorHandler:(MKNKResponseErrorBlock) error;

//单例
+(RequestNetworkEngine *)share;

@end

