//
//  SurveyModel.h
//  WomenHealthApp
//
//  Created by Daniel on 15/1/16.
//  Copyright (c) 2015年 WomenHealthApp. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SurveyModel : NSObject
/**
 *  问卷问题ID
 */
@property(nonatomic,strong)   NSString *vote_id;
/**
 *  问卷问题标题
 */
@property(nonatomic,strong)   NSString *vote_name;
/**
 *  是否多选
 */
@property(nonatomic,strong)   NSString *can_multi;
/**
 *  问卷问题答案对象数组
 */
@property(nonatomic,strong)   NSMutableArray *optionAry;


+(SurveyModel *)getSurverFromDic:(NSDictionary *)dic;

@end


@interface OptionModel : NSObject
/**
 *   答案ID
 */
@property(nonatomic,strong)   NSString *option_id;
/**
 *  答案名称
 */
@property(nonatomic,strong)   NSString *option_name;

@property(nonatomic,assign)   BOOL selectBool;

+(OptionModel *)getOptionFromDic:(NSDictionary *)dic;

@end