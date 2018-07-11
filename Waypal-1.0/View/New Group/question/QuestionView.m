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
#import "enlargeButton.h"
#import "ScaleImageView.h"
@implementation QuestionView
-(instancetype)initWithFrame:(CGRect)frame
{
    if (self=[super initWithFrame:frame])
    {
        self.userInteractionEnabled=YES;
    }
    return self;
}
-(void)setViewData:(QuestionModel *)model
{
    self.booktest_id =model.booktest_id;
    //    背景
    UIImageView *imageV=[[UIImageView alloc] initWithFrame:self.frame];
    imageV.image =[UIImage imageNamed:@"question_bgView"];
    imageV.contentMode=UIViewContentModeScaleAspectFill;
    CGFloat leftPadding=150;
    
    // 问题label
    UILabel * questionLabel=[[UILabel alloc] initWithFrame:CGRectMake(leftPadding, 160, self.frame.size.width-leftPadding*2, 30)];
    questionLabel.text =[NSString stringWithFormat:@"%ld、 %@",self.tag+1,model.content];
    questionLabel.numberOfLines=0;
    [questionLabel setAdjustsFontSizeToFitWidth:YES];
    questionLabel.font=[UIFont boldSystemFontOfSize:24];
    questionLabel.textAlignment=NSTextAlignmentLeft;
    
    //   大图
    CGFloat bigImageHeight=50;
    UIImageView * questionImageView=[[UIImageView alloc] initWithFrame:CGRectMake(leftPadding+30, questionLabel.frame.origin.y+40, 0, bigImageHeight)];
    questionImageView.layer.cornerRadius=5.0;
    questionImageView.layer.masksToBounds=YES;
    questionImageView.contentMode=UIViewContentModeScaleAspectFit;
    [questionImageView sd_setImageWithURL:[NSURL URLWithString:model.image_path]];
    if ([model.category integerValue]==2)
    {
        bigImageHeight=230;
        questionLabel.frame=CGRectMake(leftPadding, 80, self.frame.size.width-leftPadding*2, 30);
        questionImageView.frame=CGRectMake(leftPadding+30, questionLabel.frame.origin.y+40, 229, bigImageHeight);
    }
    
    UIView *optionView=[self optionsBgViewWithQuestionModel:model];
    optionView.userInteractionEnabled=YES;
    UIButton *voiceBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    voiceBtn.frame=CGRectMake(self.frame.size.width-153, self.frame.size.height-73, 135, 60);
    
    
    
    
    [voiceBtn setImage:[UIImage imageNamed:@"question_play"] forState:UIControlStateNormal];
    [voiceBtn addTarget:self action:@selector(playVoice) forControlEvents:UIControlEventTouchUpInside];
    
    
    [self addSubview:imageV];
    [self addSubview:questionLabel];
    [self addSubview:optionView];
    
    //    "category": 1, // 类型, '1' => '仅文字', '2' => '含图片', '4' => '含音频' '5' => '含图片和音频'
    if ([model.category integerValue]==4) {
        [self addSubview:voiceBtn];
    }
    optionView.frame=CGRectMake(leftPadding, bigImageHeight+questionImageView.frame.origin.y+20, self.frame.size.width-300, 100);
    
    if ([model.category integerValue]==2) {
        optionView.frame=CGRectMake(leftPadding, bigImageHeight+questionImageView.frame.origin.y+20, self.frame.size.width-300, 100);
    };
    if ([model.category integerValue]==5)
    {
        [self addSubview:voiceBtn];
    }
    
    
    [self addSubview:questionImageView];
    
}

-(UIView *)optionsBgViewWithQuestionModel:(QuestionModel *)model {
    self.selectQuestionModel=model;
    CGFloat y=250;
    if ([model.category integerValue]==2) {
        y=370;
    }
    UIView * bg=[[UIView alloc] initWithFrame: CGRectMake(80, y, self.frame.size.width, 100)];
    bg.userInteractionEnabled =YES;
    NSInteger  optionCount= model.optionsArr.count;
    CGFloat width =(self.frame.size.width-300)/optionCount;
    NSString *key=[NSString stringWithFormat:@"%@",self.selectQuestionModel.booktest_id];
    NSString *selectionOptionValue=[lUSER_DEFAULT objectForKey:key];
    for (int i=0; i<model.optionsArr.count; i++)
    {
        UIView *optionView=[[UIView alloc] initWithFrame:CGRectMake(width*i , 0, width, 140)];
        optionView.userInteractionEnabled=YES;
        UIButton * btn=[UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame=CGRectMake(0 , 0, width, 40);
        NSString * text= [[model.optionsArr objectAtIndex:i] content];
        btn.tag =i;
        [btn.titleLabel setAdjustsFontSizeToFitWidth:YES];
        btn.titleLabel.numberOfLines=0;
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn setTitle:text forState:UIControlStateNormal];
        btn.titleLabel.font=[UIFont boldSystemFontOfSize:18];
        [btn setImage:[UIImage imageNamed:@"register_disagree"] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@"register_agree"] forState:UIControlStateSelected];
        if ( [[[model.optionsArr objectAtIndex:i] isanswer] boolValue]==YES) {
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
        UIImageView * optionImageView=[[UIImageView alloc] initWithFrame:CGRectMake(30, 40, width-40,100)];
        QuestionOptionModel *questionModel=[model.optionsArr objectAtIndex:i];
        [optionImageView sd_setImageWithURL:[NSURL URLWithString:questionModel.image_path] ];
        optionImageView.contentMode=UIViewContentModeScaleAspectFit;
        optionImageView.layer.cornerRadius=5.0;
        optionImageView.tag =i;
        optionImageView.layer.masksToBounds=YES;
        [optionView addSubview:btn];
        [optionView addSubview:optionImageView];
        
        [bg addSubview:optionView];
        
        UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(scaleImage:)];
        optionImageView.userInteractionEnabled=YES;
        tap.numberOfTapsRequired = 1;
        tap.numberOfTouchesRequired = 1;
        [optionImageView addGestureRecognizer:tap];
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
        DDLog(@"questionInfoDict:%@",questionInfoDict);
    }
    NSString * key =[NSString stringWithFormat:@"%@",self.selectQuestionModel.booktest_id];
    NSInteger  selectionOptionTag=optionBtn.tag;
    [lUSER_DEFAULT setObject:[NSNumber numberWithInteger:selectionOptionTag] forKey:key];
    
}
-(void)scaleImage:(UITapGestureRecognizer *)tap{
    UIImageView *img=(UIImageView *)tap.view;
    ScaleImageView *alert = [[[NSBundle mainBundle] loadNibNamed:@"ScaleImageView" owner:self options:0] lastObject];
    alert.frame=CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    alert.orginImage=img.image;
    [alert  jk_showInWindowWithMode:JKCustomAnimationModeAlert inView:nil bgAlpha:0.2 needEffectView:YES];
}

-(void)playVoice{
    if (self.questionAudioDoingBlock) {
        self.questionAudioDoingBlock(self.selectQuestionModel.audio_path,self.selectQuestionModel.filname);
    }
}

@end
