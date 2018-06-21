//
//  QuestionOptionModel.h
//  Waypal-1.0
//
//  Created by waypal on 2018/6/19.
//  Copyright © 2018年 waypal. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QuestionOptionModel : NSObject
@property(nonatomic,strong) NSString *booktest_id;
@property(nonatomic,strong)NSString  *content;
@property(nonatomic,strong)NSString * image_id;
@property(nonatomic,strong) NSString *options_id;
@property(nonatomic,strong)NSString  *is_answer;
@end
