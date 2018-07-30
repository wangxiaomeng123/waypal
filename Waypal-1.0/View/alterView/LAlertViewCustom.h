//
//  LAlertViewCustom.h
//  xiaojingyu
//
//  Created by lintao li on 2017/10/12.
//  Copyright © 2017年 kekejl. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Config.h" 

typedef void (^doingBlock)(void);
@interface LAlertViewCustom : NSObject


+ (LAlertViewCustom *)sharedInstance;



/**
 自定义的提示框，三种形态----包括有两个按钮的，一个按钮的，和无按钮的自动消失提示

 @param title 提示框标题，可为nil
 @param message 提示框内容文字，不可为nil
 @param leftTitle 左边取消按钮的文字，非自动消失状态不可为nil
 @param rightTitle 右边按钮的文字，两个按钮状态下不可为nil
 @param dismiss 是否自动消失，显示时长可配。
 @param tapDoingBlock 右边按钮的点击回调代码块，可为nil
 @param doingBlock dismiss==YES,则此代码块为提示消失后执行。否则视为左边按钮点击回调代码块，可为nil
 */
- (void) alertViewTitle:(NSString *)title content:(NSString *)message leftButtonTitle:(NSString *)leftTitle rightButtonTitle:(NSString *)rightTitle autoDismiss:(BOOL)dismiss rightButtonTapDoing:(doingBlock)tapDoingBlock leftButtonTapORDismissDoing:(doingBlock)doingBlock;


/**
 让当前的提示框消失
 */
- (void) alertViewDismiss;

@end
