//
//  SubmitChooseOption.m
//  Waypal-1.0
//
//  Created by waypal on 2018/6/25.
//  Copyright © 2018年 waypal. All rights reserved.
//

#import "SubmitChooseOption.h"

@implementation SubmitChooseOption

-(instancetype)initWithFrame:(CGRect)frame
{
    self=[super initWithFrame:frame];
    if (self) {
        [self initUI];
    }
    return self;
}
-(void)setDataWithDict:(NSDictionary *)dataDict{
    if (dataDict) {
        self.dataDict=dataDict;
        self.rightratioLabel.text=[NSString stringWithFormat:@"正确率:%@",self.dataDict[@"rightratio"]];
        self.totalQuestionLabel.text=[NSString stringWithFormat:@"总计测试题:%@",self.dataDict[@"total"]];
        self.rightcountLabel.text=[NSString stringWithFormat:@"正确测试题:%@",self.dataDict[@"rightcount"]];
    }
 }
#pragma mark 再读一次
- (IBAction)readAgainAction:(id)sender {
        if (self.readAgainDoingBlock) {
        self.readAgainDoingBlock();
    }
}
-(void)initUI{
    UIImageView *  bgImage=[[UIImageView alloc] initWithFrame:self.frame];
    bgImage.image=[UIImage imageNamed:@"question_bgView"];
    [self addSubview:bgImage];
    UIImageView * imageView=[[UIImageView alloc] initWithFrame:CGRectMake((self.frame.size.width-280)/2, 100, 280, 78)];
    imageView.image=[UIImage imageNamed:@"book_lastPage"];
    [self addSubview:imageView];
    self.totalQuestionLabel=[[UILabel alloc] initWithFrame:CGRectMake(0, imageView.frame.origin.y+100, self.frame.size.width, 30)];
    self.totalQuestionLabel.textAlignment=NSTextAlignmentCenter;
    self.rightcountLabel=[[UILabel alloc] initWithFrame:CGRectMake(0, self.totalQuestionLabel.frame.origin.y+50, self.frame.size.width, 30)];
    self.rightcountLabel.textAlignment=NSTextAlignmentCenter;
    self.rightratioLabel=[[UILabel alloc] initWithFrame:CGRectMake(0,  self.rightcountLabel.frame.origin.y+50, self.frame.size.width, 30)];
    self.rightratioLabel.textAlignment=NSTextAlignmentCenter;
    UIButton *btn=[[UIButton alloc] initWithFrame:CGRectMake(self.frame.size.width/2-70, self.rightratioLabel.frame.origin.y+50, 140, 35)];
    [btn addTarget:self action:@selector(readAgainAction) forControlEvents:UIControlEventTouchUpInside];
    [btn setBackgroundImage:[UIImage imageNamed:@"verification_code"] forState:UIControlStateNormal];
    [btn setTitle:@"再次阅读" forState:UIControlStateNormal];
    [self addSubview:self.rightcountLabel];
    [self addSubview:self.rightratioLabel];
    [self addSubview:self.totalQuestionLabel];
    [self addSubview:btn];
}
-(void)readAgainAction{
    if (self.readAgainDoingBlock) {
        self.readAgainDoingBlock();
}
    
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
