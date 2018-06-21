//
//  QuestionModel.m
//  Waypal-1.0
//
//  Created by waypal on 2018/6/19.
//  Copyright © 2018年 waypal. All rights reserved.
//

#import "QuestionModel.h"
#import "QuestionOptionModel.h"
@implementation QuestionModel
-(void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    if ([key isEqualToString:@"id"]) {
        self.booktest_id =value;
    }
    if ([key isEqualToString:@"options"]) {
        
        NSMutableArray * optionsArrary=[NSMutableArray array];
        NSArray * optionsArr=(NSArray *)value;
        for(NSDictionary * optionDict in optionsArr){
            QuestionOptionModel *optionModel=[[QuestionOptionModel alloc] init];
            [optionModel setValuesForKeysWithDictionary:optionDict];
            [optionsArrary addObject:optionModel];
        }
        self.optionsArr = optionsArrary;
    }
    
}
@end
