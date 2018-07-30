//
//  animationTool.m
//  Waypal-1.0
//
//  Created by waypal on 2018/6/1.
//  Copyright © 2018年 waypal. All rights reserved.
//

#import "animationTool.h"
#import "Config.h"
@implementation animationTool
+(instancetype)shareInstance{
    
    static dispatch_once_t onceToken;
    static animationTool *anTool=nil;
    dispatch_once(&onceToken, ^{
        anTool=[[animationTool alloc] init];
    });
    return anTool;
}
-(void)shakeToShow:(UIButton *)button{
    CAKeyframeAnimation* animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    animation.duration = 1.0;
    NSMutableArray *values = [NSMutableArray array];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.1, 0.1, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.2, 1.2, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.9, 0.9, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]];
    animation.values = values;
    [button.layer addAnimation:animation forKey:nil];
}
- (void)animationWithSubView:(UIView *)superView {
    
    //粒子发射器
    CAEmitterLayer *snowEmitter = [CAEmitterLayer layer];
    //粒子发射的位置
    snowEmitter.emitterPosition = CGPointMake(lSCREEN_WIDTH/2, 0);
    //发射源的大小
    snowEmitter.emitterSize        = CGSizeMake(lSCREEN_WIDTH, 0.0);
    //发射模式
    snowEmitter.emitterMode        = kCAEmitterLayerOutline;
    //发射源的形状
    snowEmitter.emitterShape    = kCAEmitterLayerLine;
    
    //创建雪花粒子
    CAEmitterCell *snowflake = [CAEmitterCell emitterCell];
    //粒子的名称
    snowflake.name = @"snow";
    //粒子参数的速度乘数因子。越大出现的越快
    snowflake.birthRate        = 1.0;
    //存活时间
    snowflake.lifetime        = 100.0;
    //粒子速度
    snowflake.velocity        = 10;                // falling down slowly
    //粒子速度范围
    snowflake.velocityRange = 10;
    //粒子y方向的加速度分量
    snowflake.yAcceleration = 80;
    //周围发射角度
    snowflake.emissionRange = 0.5 * M_PI;        // some variation in angle
    //子旋转角度范围
    snowflake.spinRange        = 0.25 * M_PI;        // slow spin
    //粒子图片
    snowflake.contents        = (id) [[UIImage imageNamed:@"DazStarOutline"] CGImage];
    //粒子颜色
    snowflake.color            = [[UIColor whiteColor] CGColor];
    //设置阴影
    snowEmitter.shadowOpacity = 1.0;
    snowEmitter.shadowRadius  = 0.0;
    snowEmitter.shadowOffset  = CGSizeMake(0.0, 1.0);
    snowEmitter.shadowColor   = [[UIColor whiteColor] CGColor];
    // 将粒子添加到粒子发射器上
    snowEmitter.emitterCells = [NSArray arrayWithObject:snowflake];
    [superView.layer insertSublayer:snowEmitter atIndex:0];
}

-(void)bgAnimationWithSubView:(UIView *)superView{
    CABasicAnimation *animation =  [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    //默认是顺时针效果，若将fromValue和toValue的值互换，则为逆时针效果
    animation.fromValue = [NSNumber numberWithFloat:0.f];
    animation.toValue =  [NSNumber numberWithFloat: M_PI *2];
    animation.duration  = 200;
    animation.autoreverses = NO;
    animation.fillMode =kCAFillModeForwards;
    animation.repeatCount = MAXFLOAT; //如果这里想设置成一直自旋转，可以设置为MAXFLOAT，否则设置具体的数值则代表执行多少次
    [ superView.layer addAnimation:animation forKey:nil];
}






-(void)transformAnimationGroupWithLayer:(CALayer *)layer
{
    //平移
    CABasicAnimation *transition = [CABasicAnimation animationWithKeyPath:@"transform.translation.x"];
    transition.toValue = @(300);
    
    //旋转
    CABasicAnimation *rotation = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    rotation.toValue = @(M_PI);
    
    //缩放
    CABasicAnimation *scale = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    scale.toValue = @(0.2);
    
    
    CABasicAnimation *opacity = [CABasicAnimation animationWithKeyPath:@"opacity"];//必须写opacity才行。
    opacity.fromValue = [NSNumber numberWithFloat:1.0f];
    opacity.toValue = [NSNumber numberWithFloat:0.0f];//这是透明度。
    
    
    
    //添加组动画
    CAAnimationGroup *group = [CAAnimationGroup animation];
    
    
    //注意这里动画的效果 要设置成group的
    group.duration = 2.0;
    group.animations = @[rotation, scale, transition,opacity];
    group.removedOnCompletion = NO;
    group.fillMode = kCAFillModeForwards;
    
    [layer addAnimation:group forKey:nil];
}






@end



