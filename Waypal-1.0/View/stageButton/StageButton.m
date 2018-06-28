//
//  StageButton.m
//  Waypal-1.0
//
//  Created by waypal on 2018/6/28.
//  Copyright © 2018年 waypal. All rights reserved.
//

#import "StageButton.h"

@implementation StageButton
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initLayoutSubView];
    }
    return self;
}

-(void)initLayoutSubView{
    
    self.imageView=[[UIImageView alloc] initWithFrame:self.frame];
    CGFloat label_orgin_y=(self.imageView.frame.size.height-30)/2;
    self.titleLabel=[[UILabel alloc] initWithFrame:CGRectMake(0,label_orgin_y,self.frame.size.width , 30)];
    [self addSubview:self.imageView];
    [self addSubview:self.titleLabel];
    
    
    
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    
//    UITouch * touch
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
