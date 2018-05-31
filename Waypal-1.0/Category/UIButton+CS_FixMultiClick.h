//
//  UIButton+CS_FixMultiClick.h
//  Waypal-1.0
//
//  Created by waypal on 2018/5/30.
//  Copyright © 2018年 waypal. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (CS_FixMultiClick)
@property (nonatomic, assign) NSTimeInterval cs_acceptEventInterval; // 重复点击的间隔

@property (nonatomic, assign) NSTimeInterval cs_acceptEventTime;

@end
