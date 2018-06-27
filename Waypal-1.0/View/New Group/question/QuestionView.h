//
//  QuestionView.h
//  Waypal-1.0
//
//  Created by waypal on 2018/6/22.
//  Copyright © 2018年 waypal. All rights reserved.
//

typedef void(^chooseOptionBlock)(NSDictionary *chooseOptionInfoDict,NSInteger index);
typedef void(^playQuestionAudioBlock)(NSString *playAudioPath);
#import <UIKit/UIKit.h>
#import "QuestionModel.h"
#import "QuestionOptionModel.h"
@interface QuestionView : UIView
@property(nonatomic,strong)UIButton *selectedBtn;
@property(nonatomic,strong)QuestionModel * selectQuestionModel;
@property(nonatomic,strong)playQuestionAudioBlock questionAudioDoingBlock;
@property (nonatomic,strong) chooseOptionBlock chooseOptionDoingBlock;
@property(nonatomic,strong) NSString * answer_option_id;
@property(nonatomic,strong) NSString * right_option_id;
@property(nonatomic,strong)NSString  * booktest_id;


-(void)setViewData:(QuestionModel *)model;

@end
