//
//  CustomAlterView.h
//  Waypal-1.0
//
//  Created by waypal on 2018/5/21.
//  Copyright © 2018年 waypal. All rights reserved.
//

typedef void(^rightBtnActionBlock)(void);
typedef void(^leftBtnActionBlock)(void);
#import <UIKit/UIKit.h>

@interface CustomAlterView : UIView
+(void)showAlterViewWithTitle:(NSString *)title message:(NSString *)message  rightBtnText:(NSString *)right_Text leftBtnText:(NSString *)left_Text  rightBtnBlock:(rightBtnActionBlock)rightDoingBlock  leftBtnBlock:(leftBtnActionBlock)leftDoingBlock  presentViewController:(UIViewController *)prensentVC;

@end
