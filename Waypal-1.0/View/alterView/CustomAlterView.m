

//
//  CustomAlterView.m
//  Waypal-1.0
//
//  Created by waypal on 2018/5/21.
//  Copyright © 2018年 waypal. All rights reserved.
//

#import "CustomAlterView.h"

@implementation CustomAlterView
+(void)showAlterViewWithTitle:(NSString *)title message:(NSString *)message  rightBtnText:(NSString *)right_Text leftBtnText:(NSString *)left_Text  rightBtnBlock:(rightBtnActionBlock)rightDoingBlock  leftBtnBlock:(leftBtnActionBlock)leftDoingBlock  presentViewController:(UIViewController *)prensentVC
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:right_Text style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        rightDoingBlock();
        
    }];
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:left_Text style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
//        leftDoingBlock();
        
    }];
    
    [alert addAction:action1];
    [alert addAction:action2];
    [prensentVC presentViewController:alert animated:YES completion:nil];
}

//-(void)showActionView{
//    UIActionSheetStyle   * actionsheet=[UIActionSheet ]
//}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
