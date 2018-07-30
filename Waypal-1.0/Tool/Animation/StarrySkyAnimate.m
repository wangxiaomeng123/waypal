//
//  MUNCelestialAnimate.m
//  MyUni
//
//  Created by Administrator on 2017/10/13.
//  Copyright © 2017年 tion_Z. All rights reserved.
//

#import "StarrySkyAnimate.h"


@implementation StarrySkyAnimate

{
    UIButton *_bigButton;
    UIButton *_centerButton;
    UIButton *_littleButton;
}

-(instancetype)init{
    if (self = [super init]) {
//        self.transform = CGAffineTransformRotate (self.transform, M_PI-M_PI_2/6);
     
    }
    return self;
}
-(void)createCircle{
    //创建运动的轨迹动画
    for (NSInteger i = 0; i < 3; i++) {
        CAKeyframeAnimation *pathAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
        pathAnimation.calculationMode = kCAAnimationPaced;
        pathAnimation.fillMode = kCAFillModeForwards;
        pathAnimation.removedOnCompletion = NO;
        pathAnimation.repeatCount = CGFLOAT_MAX;
        
        float ButtonWidth = 0.0;
        //外圆
        float radiuscale = 0.0;
        CGFloat origin_x = 0.0 ;
        CGFloat origin_y = 0.0;
        CGFloat radiusX = 0.0;
        float beginAng = M_PI;
        float endAng = M_PI;
        NSString *imageName = [NSString new];
        switch (i) {
            case 0:{
                pathAnimation.duration = 30.0;
                ButtonWidth = 35;
                //外圆
                radiuscale = (SCREEN_WIDTH/2.0)/View_width;
                origin_x = View_width/2.0;
                origin_y = SCREEN_WIDTH/2.0/2.0;
                radiusX = View_width/2.0;
                beginAng = M_PI / 6;
                endAng = M_PI/6 +M_PI*2;
                imageName = @"15";
            }
                break;
            case 1:{
                ButtonWidth = 35;
                pathAnimation.duration = 30.0;
                radiuscale = (SCREEN_WIDTH/2.0-50)/(SCREEN_WIDTH-40);
                origin_x = (SCREEN_WIDTH-40)/2+60;
                origin_y = (SCREEN_WIDTH/2-50)/2.0+25;
                radiusX = (SCREEN_WIDTH-40)/2;
                beginAng = M_PI  ;
                endAng = M_PI+M_PI*2;
                imageName = @"14";
            }
                break;
            case 2:{
                pathAnimation.duration = 30.0;
                ButtonWidth = 35;
                radiuscale = (SCREEN_WIDTH/4.5)/(SCREEN_WIDTH/2);
                origin_x = (SCREEN_WIDTH/2)/2+SCREEN_WIDTH/4+40;
                origin_y = (SCREEN_WIDTH/4.5)/2.0+SCREEN_WIDTH/7;
                radiusX = (SCREEN_WIDTH/2)/2;
                beginAng = M_PI / 2;
                endAng = M_PI/2 +M_PI*2;
                imageName = @"12";
            }
                break;
                
            default:
                break;
        }
        CGMutablePathRef ovalfromarc = CGPathCreateMutable();
        CGAffineTransform t2 = CGAffineTransformConcat(CGAffineTransformConcat(
                                                                               CGAffineTransformMakeTranslation(-origin_x,-origin_y),
                                                                               CGAffineTransformMakeScale(1, radiuscale)),
                                                       CGAffineTransformMakeTranslation(origin_x, origin_y));
        CGPathAddArc(ovalfromarc, &t2, origin_x, origin_y, radiusX,beginAng,endAng, 0);
        pathAnimation.path = ovalfromarc;
        CGPathRelease(ovalfromarc);
        
        switch (i) {
            case 0:{
                _bigButton = [UIButton buttonWithType:UIButtonTypeCustom];
                [_bigButton setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
                _bigButton.frame = CGRectMake(0, 0,ButtonWidth, ButtonWidth);
                _bigButton.tag = i;
                
                [_bigButton addTarget:self action:@selector(centerButtonAction:) forControlEvents:UIControlEventTouchUpInside];
                [self addSubview:_bigButton];
                [_bigButton.layer addAnimation:pathAnimation forKey:@"moveTheCircleOne"];
            }
                break;
            case 1:{
                _centerButton = [UIButton buttonWithType:UIButtonTypeCustom];
                [_centerButton setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
                _centerButton.frame = CGRectMake(0, 0, ButtonWidth, ButtonWidth);
                _centerButton.tag = i;
                [_centerButton addTarget:self action:@selector(centerButtonAction:) forControlEvents:UIControlEventTouchUpInside];
                [self addSubview:_centerButton];
                [_centerButton.layer addAnimation:pathAnimation forKey:@"moveTheCircleOne"];
            }
                break;
            case 2:{
                _littleButton = [UIButton buttonWithType:UIButtonTypeCustom];
                [_littleButton setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
                _littleButton.frame = CGRectMake(0, 0, ButtonWidth, ButtonWidth);
                _littleButton.tag = i;
                [_littleButton addTarget:self action:@selector(centerButtonAction:) forControlEvents:UIControlEventTouchUpInside];
                [self addSubview:_littleButton];
                [_littleButton.layer addAnimation:pathAnimation forKey:@"moveTheCircleOne"];
            }
                break;
                
            default:
                break;
        }
    }
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    CGPoint touchPoint = [[touches anyObject] locationInView:self];
    //获取动画当前中心点坐标
    CGPoint currentPosition = [[_bigButton.layer presentationLayer] position];
    if (touchPoint.x > currentPosition.x - 20 && touchPoint.x < currentPosition.x + 20 && touchPoint.y > currentPosition.y - 20 && touchPoint.y < currentPosition.y + 20) {
        [self centerButtonAction:_bigButton];
    }
    CGPoint currentPosition1 = [[_centerButton.layer presentationLayer] position];
    if (touchPoint.x > currentPosition1.x - 17 && touchPoint.x < currentPosition1.x + 17 && touchPoint.y > currentPosition1.y - 17 && touchPoint.y < currentPosition1.y + 17) {
        [self centerButtonAction:_centerButton];
    }
    CGPoint currentPosition2 = [[_littleButton.layer presentationLayer] position];
    if (touchPoint.x > currentPosition2.x - 17 && touchPoint.x < currentPosition2.x + 17 && touchPoint.y > currentPosition2.y - 17 && touchPoint.y < currentPosition2.y + 17) {
        [self centerButtonAction:_littleButton];
    }
}

//按钮点击
- (void)centerButtonAction:(UIButton *)sender{

    if ([self.delegate respondsToSelector:@selector(clickButtonAction:)]) {
        [self.delegate clickButtonAction:sender.tag];
    }
}

//字体的动画组
- (void)labelAnimationWithName:(NSArray *)names{
//    UILabel * label = [[UILabel alloc] init];
//    label.textAlignment = NSTextAlignmentCenter;
//    [self addSubview:label];
//    label.frame = CGRectMake(View_width/2-25-45, SCREEN_WIDTH/4-20, 50, 20);
////    label.text = @"话题中心";
//    label.textColor = [UIColor whiteColor];
//    label.font = [UIFont systemFontOfSize:12.f];
//    label.backgroundColor = COLOR(67, 84, 109, 0.7);
//    label.transform = CGAffineTransformRotate (label.transform,- (M_PI-M_PI_2/6));
    for (NSInteger i = 0; i < 3; i++) {
        CAKeyframeAnimation *pathAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
        pathAnimation.calculationMode = kCAAnimationPaced;
        pathAnimation.fillMode = kCAFillModeForwards;
        pathAnimation.removedOnCompletion = NO;
        pathAnimation.repeatCount = CGFLOAT_MAX;
        float x = 0.0;
        //外圆
        float radiuscale = 0.0;
        CGFloat origin_x = 0.0 ;
        CGFloat origin_y = 0.0;
        CGFloat radiusX = 0.0;
        float beginAng = M_PI;
        float endAng = M_PI;
        CGFloat deviationTextX = 0.0;
        CGFloat deviationTextY = 0.0;
        switch (i) {
            case 0:{
                pathAnimation.duration = 30.0;
                x = 40;
                //外圆
                radiuscale = (SCREEN_WIDTH/2.0)/View_width;
                origin_x = View_width/2.0;
                origin_y = SCREEN_WIDTH/2.0/2.0;
                radiusX = View_width/2.0;
                beginAng = M_PI / 6;
                endAng = M_PI/6 +M_PI*2;
                deviationTextX = origin_x-47;
                deviationTextY = origin_y-36;
            }
                break;
            case 1:{
                x = 30;
                pathAnimation.duration = 30.0;
                radiuscale = (SCREEN_WIDTH/2.0-50)/(SCREEN_WIDTH-40);
                origin_x = (SCREEN_WIDTH-40)/2+60;
                origin_y = (SCREEN_WIDTH/2-50)/2.0+25;
                radiusX = (SCREEN_WIDTH-40)/2;
                beginAng = M_PI  ;
                endAng = M_PI+M_PI*2;
                deviationTextX = origin_x-47;
                deviationTextY = origin_y-40;
            }
                break;
            case 2:{
                pathAnimation.duration = 30.0;
                x = 30;
                radiuscale = (SCREEN_WIDTH/4.5)/(SCREEN_WIDTH/2);
                origin_x = (SCREEN_WIDTH/2)/2+SCREEN_WIDTH/4+40;
                origin_y = (SCREEN_WIDTH/4.5)/2.0+SCREEN_WIDTH/7;
                radiusX = (SCREEN_WIDTH/2)/2;
                beginAng = M_PI / 2;
                endAng = M_PI/2 +M_PI*2;
                deviationTextX = origin_x-47;
                deviationTextY = origin_y-35;
            }
                break;
                
            default:
                break;
        }
        CGMutablePathRef ovalfromarc = CGPathCreateMutable();
        CGAffineTransform t2 = CGAffineTransformConcat(CGAffineTransformConcat(
                                                                               CGAffineTransformMakeTranslation(-origin_x,-origin_y),
                                                                               CGAffineTransformMakeScale(1, radiuscale)),
                                                       CGAffineTransformMakeTranslation(origin_x, origin_y));
        CGPathAddArc(ovalfromarc, &t2, deviationTextX, deviationTextY, radiusX,beginAng,endAng, 0);
        pathAnimation.path = ovalfromarc;
        CGPathRelease(ovalfromarc);
        
//        UILabel * label = [[UILabel alloc] init];
//        label.textAlignment = NSTextAlignmentCenter;
//        [self addSubview:label];
//        label.frame = CGRectMake(0, 0, 80, 20);
//        //    [label.layer setCornerRadius:x/2];
//        label.text = names[i];
//        label.textColor = [UIColor whiteColor];
//        label.font = [UIFont systemFontOfSize:12.f];
//        label.backgroundColor = COLOR(67, 84, 109, 0.7);
//        //设置运转的动画
//        [label.layer addAnimation:pathAnimation forKey:@"moveTheCircleOne"];
//        label.transform = CGAffineTransformRotate (label.transform,- (M_PI-M_PI_2/6));
    }
    UIButton *centerButton = [UIButton buttonWithType:UIButtonTypeCustom];
    centerButton.tag = 999;
    NSLog(@"View_width__%.2f",View_width);
    centerButton.frame = CGRectMake(View_width/2-25, SCREEN_WIDTH/4-25, 50, 50);
    [centerButton addTarget:self action:@selector(centerButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [centerButton setImage:[UIImage imageNamed:@"16"] forState:UIControlStateNormal];
    [self addSubview:centerButton];
//    centerButton.transform = CGAffineTransformRotate (centerButton.transform,- (M_PI-M_PI_2/6));
}
//贝塞尔
- (void)drawRect:(CGRect)rect {
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    //内园
//    UIColor *color = [UIColor whiteColor];
    UIBezierPath *ccc = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(SCREEN_WIDTH/4+40,  SCREEN_WIDTH/7, SCREEN_WIDTH/2, SCREEN_WIDTH/4.5)];
//    [COLOR(147.f, 151.f, 157.f,0.5f) setStroke];
    [[UIColor  clearColor] setStroke];
    [ccc stroke];
    //中园
    UIBezierPath *arc = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(20+40, 25, SCREEN_WIDTH-40,SCREEN_WIDTH/2-50)];
//    [COLOR(147.f, 151.f, 157.f,0.5f)  setStroke];
    [[UIColor  clearColor] setStroke];

    [arc stroke];
    //外圆
    UIBezierPath *acc = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, SCREEN_WIDTH+80, SCREEN_WIDTH/2)];
//    [COLOR(147.f, 151.f, 157.f,0.5f)  setStroke];
    [[UIColor  clearColor] setStroke];

    [acc stroke];
    CGContextRestoreGState(context);
   
}


-(void)setCelestialName:(NSArray *)names{

    self.userInteractionEnabled= YES;
    self.backgroundColor = [UIColor clearColor];
    [self labelAnimationWithName:names];
    [self createCircle];
//    [self createCircle: M_PI / 6 andEndAngle:M_PI / 6 + 2 * M_PI];
}
@end
