//
//  NavCourseView.m
//  Waypal-1.0
//
//  Created by waypal on 2018/6/30.
//  Copyright © 2018年 waypal. All rights reserved.
//

#import "NavCourseView.h"
#import "CourseModel.h"
#import "Config.h"
@implementation NavCourseView
- (instancetype)initWithFrame:(CGRect)frame titileArr:(NSArray *)titleArr
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor =[UIColor clearColor];
        self.pageNum=0;
        self.titleArr =titleArr;
        self.normalImagesArr=[NSMutableArray arrayWithObjects:@"pink_normal",@"yellow_normal",@"green_normal",@"blue_normal",nil];
        self.selectedImagesArr=[NSMutableArray arrayWithObjects:@"pink_select",@"yellow_select",@"green_select",@"blue_select", nil];
        self.shelfImagesArr=[NSMutableArray arrayWithObjects:@"book_shelfPink",@"book_shelfYellow",@"book_shelfGreen",@"book_shelfBlue", nil];
        [self initView];
    }
    return self;
}
-(void)initView{
    
    CGFloat Width=136*0.8;
    CGFloat Height=128*0.8;
    NSInteger count=  self.titleArr.count;
    CGFloat offset= self.frame.size.width-Width*count;
    UIView * bg;
    for (int i=0; i<count; i++) {
        bg=[[UIView alloc] initWithFrame:CGRectMake(offset+Width*i, 0, Height, Height)];
        UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame=CGRectMake(0, 0, Width, Height);
        UILabel *label=[[UILabel alloc] initWithFrame:CGRectMake((Width-50)/2, Height/2-25, 50, 50)];
//        [btn setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@",self.normalImagesArr[i]]] forState:UIControlStateNormal];
        [btn setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@",self.selectedImagesArr[i]]]  forState:UIControlStateNormal];

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
        label.font=[UIFont boldSystemFontOfSize:22.0];
        NSString * titleName= [model name_chinese];
        NSMutableString* str1=[[NSMutableString alloc]initWithString:titleName];//存在堆区，可变字符串
        NSLog(@"str1:%@",str1);
        if (str1.length>2) {
            [str1 insertString:@"\n"atIndex:2];

        }
        label.text=[NSString stringWithFormat:@"%@",str1];
        btn.titleLabel.backgroundColor=[UIColor redColor];
        [btn addTarget:self action:@selector(changeStageAction:) forControlEvents:UIControlEventTouchUpInside];
        [bg addSubview:btn];
        [btn addSubview:label];
        [self addSubview:bg];
    }
}
-(void)layoutSubviews{
    self.pageNum++;
    if (self.pageNum<2) {
        [self changeStageAction:self.selectedBtn];
        NSLog(@"layoutSubviews");
    }
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
            animationView .transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.7f, 0.7f);
        } completion:nil];
    }else{
        [UIView animateWithDuration:0.2 animations:^{
            animationView .transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.0f, 1.0f);
        } completion:nil];
    }
    
}


@end
