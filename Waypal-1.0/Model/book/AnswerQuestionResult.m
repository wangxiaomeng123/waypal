//
//  AnswerQuestionResult.m
//  Waypal-1.0
//
//  Created by waypal on 2018/6/25.
//  Copyright © 2018年 waypal. All rights reserved.
//

#import "AnswerQuestionResult.h"
#import "Config.h"
@implementation AnswerQuestionResult
-(BOOL)isCorrect
{
    [lUSER_DEFAULT setObject:[NSNumber numberWithBool:_isCorrect] forKey:@"isCorrect"];
    return _isCorrect;
}

-(NSInteger )optionIndex{
    [lUSER_DEFAULT setObject:[NSNumber numberWithInteger:_optionIndex] forKey:@"optionIndex"];
    return _optionIndex;
}
@end
