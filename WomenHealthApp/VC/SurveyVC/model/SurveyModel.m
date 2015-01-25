//
//  SurveyModel.m
//  WomenHealthApp
//
//  Created by Daniel on 15/1/16.
//  Copyright (c) 2015年 WomenHealthApp. All rights reserved.
//

#import "SurveyModel.h"

@implementation SurveyModel
+(SurveyModel *)getSurverFromDic:(NSDictionary *)dic{
    SurveyModel *model =[[SurveyModel alloc] init];
    model.vote_id = CHECK_VALUE([dic objectForKey:@"vote_id"]);
    model.vote_name = CHECK_VALUE([dic objectForKey:@"vote_name"]);
    model.can_multi = CHECK_VALUE([dic objectForKey:@"can_multi"]);
    model.optionAry =[NSMutableArray array];
    
    [[dic objectForKey:@"option"] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
       
        [model.optionAry addObject:[OptionModel getOptionFromDic:obj]];
    }];

    
    return model;
    
}
@end


@implementation OptionModel

+(OptionModel *)getOptionFromDic:(NSDictionary *)dic{
    
    OptionModel *model =[[OptionModel alloc] init];
    model.option_id = CHECK_VALUE([dic objectForKey:@"option_id"]);
    model.option_name = CHECK_VALUE([dic objectForKey:@"option_name"]);
    model.selectBool =NO;
    
    
    return model;
    
    
}

@end