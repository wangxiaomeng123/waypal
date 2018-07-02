//
//  QuestionView.m
//  Waypal-1.0
//
//  Created by waypal on 2018/6/22.
//  Copyright © 2018年 waypal. All rights reserved.
//

#import "QuestionView.h"
#import "AnswerQuestionResult.h"
#import "Config.h"
@implementation QuestionView
-(instancetype)initWithFrame:(CGRect)frame
{
    if (self=[super initWithFrame:frame])
    {
    }
    return self;
}
-(void)setViewData:(QuestionModel *)model
{
    self.booktest_id =model.booktest_id;
    UIImageView *imageV=[[UIImageView alloc] initWithFrame:self.frame];
    imageV.image =[UIImage imageNamed:@"question_bgView"];
    
    UILabel * questionLabel=[[UILabel alloc] initWithFrame:CGRectMake(0, 120, self.frame.size.width, 50)];
    questionLabel.text =model.content;
    questionLabel.numberOfLines=0;
    questionLabel.textAlignment=NSTextAlignmentCenter;
    UIImageView * questionImageView=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        [questionImageView sd_setImageWithURL:[NSURL URLWithString:model.image_path]];
    if (questionImageView.image!=nil) {
        CGSize  size=  questionImageView.image.size;
        questionImageView.size=size;
        questionImageView.frame=CGRectMake(
                                           (self.frame.size.width-size.width*0.6)/2, 175, size.width*0.6, size.height*0.6);
    }
    UIView *optionView=[self optionsBgViewWithQuestionModel:model];
    UIButton *voiceBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    voiceBtn.frame=CGRectMake(self.frame.size.width-153, self.frame.size.height-73, 135, 60);
    [voiceBtn setImage:[UIImage imageNamed:@"question_play"] forState:UIControlStateNormal];
    [voiceBtn addTarget:self action:@selector(playVoice) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:imageV];
    [self addSubview:questionLabel];
    [self addSubview:optionView];
    [self addSubview:voiceBtn];
    [self addSubview:questionImageView];

}

-(UIView *)optionsBgViewWithQuestionModel:(QuestionModel *)model{
    
    self.selectQuestionModel=model;
    UIView * bg=[[UIView alloc] initWithFrame:CGRectMake(0, 250, self.frame.size.width, 100)];
    CGFloat width=150;
    NSInteger  optionCount=   model.optionsArr.count;
    CGFloat spacing =(659-150*optionCount)/(optionCount+1);
    NSString *key=[NSString stringWithFormat:@"%@",self.selectQuestionModel.booktest_id];
    NSString *selectionOptionValue=[lUSER_DEFAULT objectForKey:key];
    for (int i=0; i<model.optionsArr.count; i++)
    {
        UIView *optionView=[[UIView alloc] initWithFrame:CGRectMake(spacing+(width+spacing)*i , 0, width, 40)];
        UIButton * btn=[UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame=CGRectMake(0 , 0, 40, 40);
        UILabel *label =[[UILabel alloc] initWithFrame:CGRectMake(50, 0, width-50, 40)];
        label.numberOfLines=0;
        label.text= [[model.optionsArr objectAtIndex:i] content];
        [label setAdjustsFontSizeToFitWidth:YES];
        btn.tag =i;
        [btn setImage:[UIImage imageNamed:@"register_disagree"] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@"register_agree"] forState:UIControlStateSelected];
        if ( [[model.optionsArr objectAtIndex:i] isanswer]) {
               self.right_option_id =[[model.optionsArr objectAtIndex:i] options_id];
        }
        [btn addTarget:self action:@selector(selectOption:) forControlEvents:UIControlEventTouchUpInside];
        if (selectionOptionValue) {
                if ([selectionOptionValue integerValue]==i)
                {
                      btn.selected =YES;
                    self.selectedBtn =btn;
                }
           }
        
        UIImageView * optionImageView=[[UIImageView alloc] initWithFrame:CGRectMake(50, 50, 100,50 )];
        QuestionOptionModel *questionModel=[model.optionsArr objectAtIndex:i];
        [optionImageView sd_setImageWithURL:[NSURL URLWithString:questionModel.image_path] ];
        [optionView addSubview:optionImageView];
        [optionView addSubview:btn];
        [optionView addSubview:label];
        [bg addSubview:optionView];
    }
    return bg;
}

-(void)selectOption:(UIButton *)optionBtn{
    if (optionBtn!= self.selectedBtn) {
        self.selectedBtn.selected = NO;
        optionBtn.selected = YES;
        self.selectedBtn = optionBtn;
    }else{
        self.selectedBtn.selected = YES;
    }
   QuestionOptionModel *model= [self.selectQuestionModel.optionsArr objectAtIndex:optionBtn.tag ];
   self.answer_option_id=model.options_id;
    if (self.chooseOptionDoingBlock) {
        NSDictionary*  questionInfoDict=@{@"book_test_id":[NSNumber numberWithInt:[self.selectQuestionModel.booktest_id intValue]],
                                             @"right_option_id":[NSNumber numberWithInt:[self.right_option_id intValue]],
                                             @"answer_option_id":[NSNumber numberWithInt:[self.answer_option_id  intValue]]};
        self.chooseOptionDoingBlock(questionInfoDict,self.tag);
    }
    NSString * key =[NSString stringWithFormat:@"%@",self.selectQuestionModel.booktest_id];
    NSInteger  selectionOptionTag=optionBtn.tag;
     [lUSER_DEFAULT setObject:[NSNumber numberWithInteger:selectionOptionTag] forKey:key];
   

}
-(void)playVoice{
    if (self.questionAudioDoingBlock) {
        self.questionAudioDoingBlock(self.selectQuestionModel.audio_path);
    }
}

@end
