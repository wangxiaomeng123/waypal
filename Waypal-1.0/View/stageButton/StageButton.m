//
//  StageButton.m
//  Waypal-1.0
//
//  Created by waypal on 2018/6/26.
//  Copyright © 2018年 waypal. All rights reserved.
//

#import "StageButton.h"

@implementation StageButton
-(instancetype)initWithFrame:(CGRect)frame
{
    if (self=[super initWithFrame:frame]) {
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.titleLabel.textColor=[UIColor whiteColor];
        self.titleLabel.font = [UIFont systemFontOfSize:16.0];
        self.backgroundColor=[UIColor greenColor];
        [self setBackgroundColor:[UIColor clearColor]];
    }
    return self;
}
-(void)drawRect:(CGRect)rect
{
    
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
