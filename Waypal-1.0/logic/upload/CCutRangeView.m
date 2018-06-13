//
//  CCutRangeView.m
//  CharlieDemo
//
//  Created by Charlie.W on 2017/12/22.
//  Copyright © 2017年 com.charlieW. All rights reserved.
//

#import "CCutRangeView.h"

@implementation CCutRangeView

- (instancetype)init {
    if (self = [super init]) {
        self.userInteractionEnabled = NO;
        _rangeBorderColor = [UIColor colorWithRed:1.0f green:1.0f blue:1.0f alpha:1.0];
    }
    return self;
}

- (void)setRangeBorderColor:(UIColor *)rangeBorderColor {
    _rangeBorderColor = rangeBorderColor;
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    CGRect rectangle = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height);
    //获得上下文句柄
    CGContextRef currentContext = UIGraphicsGetCurrentContext();
    
    //创建图形路径句柄
    CGMutablePathRef path = CGPathCreateMutable();
    //设置矩形的边界
    //添加矩形到路径中
    CGPathAddRect(path,NULL, rectangle);
    //添加路径到上下文中
    CGContextAddPath(currentContext, path);
    //填充颜色
    [[UIColor colorWithRed:1.0f green:1.0f blue:1.0f alpha:0] setFill];
    //设置画笔颜色
    [_rangeBorderColor setStroke];
    //设置边框线条宽度
    CGContextSetLineWidth(currentContext,1.0f);
    //画图
    CGContextDrawPath(currentContext, kCGPathFillStroke);
    /* 释放路径 */
    CGPathRelease(path);
    
}


@end
