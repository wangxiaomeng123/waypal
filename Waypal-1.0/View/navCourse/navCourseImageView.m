


//
//  navCourseImageView.m
//  Waypal-1.0
//
//  Created by waypal on 2018/6/13.
//  Copyright © 2018年 waypal. All rights reserved.
//

#import "navCourseImageView.h"

@implementation navCourseImageView


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
//- (void)drawRect:(CGRect)rect {
//    switch (self.tag) {
//        case 0:
//            self.image=[UIImage imageNamed:@"book_smart"];
//            break;
//        case 1:
//            self.image=[UIImage imageNamed:@"book_smart"];
//            
//            break;
//        case 2:
//            self.image=[UIImage imageNamed:@"book_smart"];
//            break;
//        case 3:
//            self.image=[UIImage imageNamed:@"book_smart"];
//
//            break;
//            
//        default:
//            break;
//    }
//    
//}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    self.orginPoint= self.center;
}
-(void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    
    // 当前触摸点
    CGPoint currentPoint = [touch locationInView:self.superview];
    // 上一个触摸点
    CGPoint previousPoint = [touch previousLocationInView:self.superview];
    
    // 当前view的中点
    CGPoint center = self.center;
    
    center.x += (currentPoint.x - previousPoint.x);
    center.y += (currentPoint.y - previousPoint.y);
    // 修改当前view的中点(中点改变view的位置就会改变)
    self.center = center;

}
-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [UIView animateWithDuration:2 animations:^{
        self.center =self.orginPoint;
    }];
    
}
@end
