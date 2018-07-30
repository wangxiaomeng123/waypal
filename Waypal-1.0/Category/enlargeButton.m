//
//  enlargeButton.m
//  Waypal-1.0
//
//  Created by waypal on 2018/7/5.
//  Copyright © 2018年 waypal. All rights reserved.
//

#import "enlargeButton.h"

@implementation enlargeButton

- (instancetype)initWithFrame:(CGRect)frame 
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}
- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent*)event
{
    [super pointInside:point withEvent:event];
    CGRect bounds =CGRectMake(0, -70, self.bounds.size.width, self.bounds.size.height);
    CGFloat widthDelta =90- bounds.size.width;
    CGFloat heightDelta =90- bounds.size.height;
    bounds =CGRectInset(bounds, 0, -0.5* heightDelta);//注意这里是负数，扩大了之前的bounds的范围
    if ([self respondsToSelector:@selector(addTarget:action:forControlEvents:)])
    {
        [self addTarget:self action:@selector(tapButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return CGRectContainsPoint(bounds, point);
   
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
