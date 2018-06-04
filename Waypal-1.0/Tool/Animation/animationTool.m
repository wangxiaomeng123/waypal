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
@end



