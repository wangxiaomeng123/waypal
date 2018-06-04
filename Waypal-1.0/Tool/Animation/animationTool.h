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
- (void)animationWithSubView:(UIView *)superView ;

@end
