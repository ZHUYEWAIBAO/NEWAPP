//
//  RequestNetworkEngine.m
//  YueDongApp
//
//  Created by 朱 青 on 14-8-5.
//  Copyright (c) 2014年 朱 青. All rights reserved.
//

#import "RequestNetworkEngine.h"

@implementation RequestNetworkEngine

/**
 添加特定header
 @returns
 */
-(NSMutableDictionary*)makeCustomHeaders
{
    NSMutableDictionary* headers=[NSMutableDictionary dictionaryWithCapacity:5];
    
    
    //版本号
    //    [headers setObject:CLIENT_VERSION forKey:version];
    
    
    return headers;
}


/**
 发起请求
 @param path 请求地址路径
 @param params 参数
 @param  response
 @param
 @returns
 */
-(MKNetworkOperation*)requestWithPath:(NSString*)path Params:(NSMutableDictionary*)params  CompletionHandler:(MKNKResponseBlock) response ErrorHandler:(MKNKResponseErrorBlock) error{
    
    //extra params 增加特殊参数
    //    [params addEntriesFromDictionary:[self makeCustomParams]];
    
    
    MKNetworkOperation *op;
    
    if (params) {
        op =[self operationWithPath:path params:params httpMethod:@"POST"];

    }
    else{
        op = [self operationWithPath:path params:nil httpMethod:@"GET"];
    }
    
    
    //处理句柄
    [op addCompletionHandler:response errorHandler:error];
    
    
    //加入队列
    [self enqueueOperation:op];
    
    
    return op;
    
}

/**
 生成请求
 @param remoteURL 远程文件地址
 @param filePath 本地文件地址
 @param  hostName
 @returns return value description
 */
-(MKNetworkOperation*) downloadFatAssFileFrom:(NSString*)remoteURL toFile:(NSString*) filePath CompletionHandler:(MKNKResponseBlock) response ErrorHandler:(MKNKResponseErrorBlock) error
{
    MKNetworkEngine *engine = [[MKNetworkEngine alloc] initWithHostName:GLOBALSHARE.SERVER_HOST customHeaderFields:nil];
    MKNetworkOperation *op = [engine operationWithURLString:remoteURL
                                                     params:nil
                                                 httpMethod:@"GET"];
    
    [op addDownloadStream:[NSOutputStream outputStreamToFileAtPath:filePath
                                                            append:YES]];

    //处理句柄
    [op addCompletionHandler:response errorHandler:error];
    
    
    //加入队列
    [engine enqueueOperation:op];
    
    return op;
}

/**
 *  上传多张图片
 *
 *  @param path     请求地址路径
 *  @param params   参数
 *  @param array    文件数组
 *  @param key      关键词
 *  @param response
 *  @param error
 *
 *  @return
 */
-(MKNetworkOperation*)requestWithPath:(NSString*)path Params:(NSMutableDictionary*)params  fileArray:(NSMutableArray *)array keyString:(NSString *)key CompletionHandler:(MKNKResponseBlock) response ErrorHandler:(MKNKResponseErrorBlock) error{
    
    MKNetworkOperation *op;
    
    if (params) {
        op = [self operationWithPath:path params:params httpMethod:@"POST"];
        
    }
    else{
        op = [self operationWithPath:path params:nil httpMethod:@"GET"];
    }
    
    for (NSInteger i=0; i < array.count; i++) {
        
        [op addData:[array objectAtIndex:i] forKey:[NSString stringWithFormat:@"%@%ld",key,i+1]];
        
    }
    //处理句柄
    [op addCompletionHandler:response errorHandler:error];
    
    
    //加入队列
    [self enqueueOperation:op];
    
    
    return op;
    
}

/**
 *  上传单张张图片
 *
 *  @param path           请求地址路径
 *  @param params         参数
 *  @param imageData      图片数据
 *  @param response
 *  @param error
 *
 *  @return
 */
-(MKNetworkOperation*)requestWithPath:(NSString*)path Params:(NSMutableDictionary*)params imageData:(NSData *)fileData keyString:(NSString *)key CompletionHandler:(MKNKResponseBlock) response ErrorHandler:(MKNKResponseErrorBlock) error{
    
    MKNetworkOperation *op;
    
    if (params) {
        op =[self operationWithPath:path params:params httpMethod:@"POST"];
        
    }
    else{
        op = [self operationWithPath:path params:nil httpMethod:@"GET"];
    }
    

    [op addData:fileData forKey:key];
        

    //处理句柄
    [op addCompletionHandler:response errorHandler:error];
    
    
    //加入队列
    [self enqueueOperation:op];
    
    
    return op;
    
}


/**
 单例
 @returns
 */
+(RequestNetworkEngine *)share {
    static dispatch_once_t pred;
    static RequestNetworkEngine *shared = nil;
    dispatch_once(&pred, ^{
        shared = [[RequestNetworkEngine alloc]initWithHostName: GLOBALSHARE.SERVER_HOST ];
        [shared useCache];
    });
    return shared;
}


@end


