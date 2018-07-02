//
//  NavCourseView.m
//  Waypal-1.0
//
//  Created by waypal on 2018/6/30.
//  Copyright © 2018年 waypal. All rights reserved.
//

#import "NavCourseView.h"
#import "CourseModel.h"
@implementation NavCourseView
- (instancetype)initWithFrame:(CGRect)frame titileArr:(NSArray *)titleArr
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor =[UIColor clearColor];
        self.titleArr =titleArr;
        self.normalImagesArr=[NSMutableArray arrayWithObjects:@"pink_normal",@"yellow_normal",@"green_normal",@"blue_normal",nil];
        self.selectedImagesArr=[NSMutableArray arrayWithObjects:@"pink_select",@"yellow_select",@"green_select",@"blue_select", nil];
        self.shelfImagesArr=[NSMutableArray arrayWithObjects:@"book_shelfPink",@"book_shelfYellow",@"book_shelfGreen",@"book_shelfBlue", nil];
        [self initView];
    }
    return self;
}
-(void)initView{
    CGFloat Width=112;
    CGFloat Height=112;
    NSInteger count=  self.titleArr.count;
    CGFloat offset= self.frame.size.width-Width*count;
    UIView * bg;
    for (int i=0; i<count; i++) {
        bg=[[UIView alloc] initWithFrame:CGRectMake(offset+Width*i, 0, Height, Height)];
        UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame=CGRectMake(0, 0, Width, Height);
        UILabel *label=[[UILabel alloc] initWithFrame:CGRectMake((Width-50)/2, 30, 50, 50)];
//        [btn setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@",self.normalImagesArr[i]]] forState:UIControlStateNormal];
        [btn setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@",self.selectedImagesArr[i]]]  forState:UIControlStateNormal];
//        [btn setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@",self.selectedImagesArr[i]]] forState:UIControlStateSelected];
        btn.tag=i;
        if (i==0) {
            btn.selected=YES;
            self.selectedBtn=btn;
        }
        [self scaleWithView:btn];
        label.textColor=[UIColor whiteColor];
        label.textAlignment=NSTextAlignmentCenter;
        CourseModel *model=self.titleArr[i];
        label.text=[model name_chinese];
        [label setAdjustsFontSizeToFitWidth:YES];
        label.numberOfLines=0;
        label.font=[UIFont systemFontOfSize:16.0];
        [btn setTitle:[model name_chinese] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(changeStageAction:) forControlEvents:UIControlEventTouchUpInside];
        [bg addSubview:btn];
//        [btn addSubview:label];
        [self addSubview:bg];
    }
}
-(void)layoutSubviews{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self changeStageAction:self.selectedBtn];
        NSLog(@"layoutSubviews");
    });
    
}
-(void)changeStageAction:(UIButton *)optionBtn{
    
    if (optionBtn!= self.selectedBtn) {
        self.selectedBtn.selected = NO;
        [self scaleWithView:self.selectedBtn];

        optionBtn.selected = YES;
        self.selectedBtn = optionBtn;
   
    }else{
        self.selectedBtn.selected = YES;
    }
    [self scaleWithView:self.selectedBtn];

    CourseModel *model=self.titleArr[optionBtn.tag];
    if (self.chooseNavCourseDoingBlock){
        self.chooseNavCourseDoingBlock(model.NavCourseId,self.shelfImagesArr[optionBtn.tag]);
    }
}
-(void)scaleWithView:(UIButton *)animationView {
    animationView.transform = CGAffineTransformMake(1, 0, 0, 1, 0, 0);
    if (!animationView.selected) {
        [UIView animateWithDuration:0.3 animations:^{
            animationView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.7f, 0.7f);
        } completion:nil];
    }else{
        [UIView animateWithDuration:0.2 animations:^{
            animationView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.0f, 1.0f);
        } completion:nil];
    }
    
}


@end
