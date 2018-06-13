//
//  animationTool.h
//  Waypal-1.0
//
//  Created by waypal on 2018/6/1.
//  Copyright © 2018年 waypal. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface animationTool : NSObject
+(instancetype)shareInstance;
-(void)shakeToShow:(UIButton *)button;

- (void)animationWithSubView:(UIView *)superView ;
-(void)bgAnimationWithSubView:(UIView *)superView;
-(void)transformAnimationGroupWithLayer:(CALayer *)layer;

@end
