//
//  LessonViewController.h
//  iPad_wayPal
//
//  Created by waypal on 2018/5/16.
//  Copyright © 2018年 waypal. All rights reserved.
//
typedef void(^loginOutComebackAction)(void);
#import <UIKit/UIKit.h>

@interface LessonViewController : UIViewController
@property(nonatomic,strong) loginOutComebackAction comebackAction;

@end
