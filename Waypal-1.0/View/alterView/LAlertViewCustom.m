//
//  LAlertViewCustom.m
//  xiaojingyu
//
//  Created by lintao li on 2017/10/12.
//  Copyright © 2017年 kekejl. All rights reserved.
//

#import "LAlertViewCustom.h"
#import <UIKit/UIKit.h>
//#import "General.h"
#import "UIView+Extension.h"


static LAlertViewCustom *alertObj = nil;

const CGFloat dismissLabelFontSize = 14;
const CGFloat dismissLabelDefWidthWithScreen = 0.8;
const CGFloat dismissLabelDefCenterYWithScreen = 0.85;


@interface LAlertViewCustom()<UIAlertViewDelegate>

@property (copy, nonatomic) doingBlock leftORDismissDoingBlock;
@property (copy, nonatomic) doingBlock rightDoingBlock;

@property (strong, nonatomic) UILabel *dismissLabel;
@property (strong, nonatomic) UIAlertView *alertView;
@end

@implementation LAlertViewCustom

+(LAlertViewCustom *)sharedInstance
{
    if (!alertObj)
    {
        alertObj = [[LAlertViewCustom alloc] init];
    }
    return alertObj;
}


- (void)alertViewTitle:(NSString *)title content:(NSString *)message leftButtonTitle:(NSString *)leftTitle rightButtonTitle:(NSString *)rightTitle autoDismiss:(BOOL)dismiss rightButtonTapDoing:(doingBlock)tapDoingBlock leftButtonTapORDismissDoing:(doingBlock)doingBlock
{
    if (dismiss)
    {
        [self changeLabelWithInit:message];
        [[UIApplication sharedApplication].keyWindow addSubview:self.dismissLabel];
        [self performSelector:@selector(dismissAlert) withObject:nil afterDelay:kAlertViewAutoDismissSecond];
    }
    else
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:leftTitle otherButtonTitles:rightTitle, nil];
        self.alertView = alertView;
        lDISPATCH_MAIN_THREAD(^{
            [alertView show];
            
        });
        self.rightDoingBlock = tapDoingBlock;

    }
    
    
    
    self.leftORDismissDoingBlock = doingBlock;

    
}

#pragma -mark 提示框消失
- (void) dismissAlert
{

    WeakSelf(self);
    
    [UIView animateWithDuration:0.6 animations:^{
//        weakself.dismissLabel.backgroundColor = [UIColor colorWithWhite:1 alpha:0.0];
        weakself.dismissLabel.alpha = 0;
    } completion:^(BOOL finished) {
        [weakself.dismissLabel removeFromSuperview];
        weakself.leftORDismissDoingBlock?self.leftORDismissDoingBlock():nil;
    }];
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)
    {
        self.leftORDismissDoingBlock?self.leftORDismissDoingBlock():nil;
    }
     if (buttonIndex == 1)
    {
        self.rightDoingBlock?self.rightDoingBlock():nil;
    }
}

- (void)alertViewDismiss
{
    [self.alertView dismissWithClickedButtonIndex:0 animated:YES];
}



- (void) changeLabelWithInit:(NSString *)message
{
    message = [NSString stringWithFormat:@" %@ ", message];
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    self.dismissLabel.width = lSCREEN_WIDTH * 0.8;
    [self.dismissLabel.layer addAnimation:[self getLabelAnimation] forKey:nil];
    self.dismissLabel.alpha = 1;
    self.dismissLabel.backgroundColor = [UIColor colorWithWhite:1 alpha:0.8];
    CGFloat height = [LInspectionClass stringHightWithUIWidth:self.dismissLabel.width fontSize:dismissLabelFontSize string:message];
    self.dismissLabel.height = height + 20;
    self.dismissLabel.centerY = lSCREEN_HEIGHT * dismissLabelDefCenterYWithScreen - height / 2;
    
    self.dismissLabel.text = message;
    
    NSDictionary *dic = @{NSFontAttributeName:[UIFont systemFontOfSize:dismissLabelFontSize]};
    CGRect rect = [message boundingRectWithSize:CGSizeMake(0, height) options:NSStringDrawingUsesLineFragmentOrigin |
                   NSStringDrawingUsesFontLeading attributes:dic context:nil];
    CGFloat width = rect.size.width + 6;
    
    if (width < self.dismissLabel.width)
    {
        self.dismissLabel.width = width;
        self.dismissLabel.centerX = lSCREEN_WIDTH / 2;
    }
    self.dismissLabel.centerX = lSCREEN_WIDTH / 2;
    
    
}
- (CAKeyframeAnimation *)getLabelAnimation
{
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    animation.duration = 0.5;
    NSMutableArray *values = [NSMutableArray arrayWithCapacity:5];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.1, 0.1, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.2, 1.2, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.9, 0.9, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]];
    animation.values = values;
    return animation;
}


- (UILabel *)dismissLabel
{
    if (!_dismissLabel)
    {
        _dismissLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, lSCREEN_WIDTH * dismissLabelDefWidthWithScreen, 30)];
        _dismissLabel.center = CGPointMake(lSCREEN_WIDTH / 2, dismissLabelDefCenterYWithScreen * lSCREEN_HEIGHT);
        _dismissLabel.backgroundColor = [UIColor colorWithWhite:1 alpha:0.8];
//        _dismissLabel.textColor = lColorFromHEX(0x333333, 1);
//        if ([Admin sharedInstance].isadmin)
//        {
//            _dismissLabel.textColor = [UIColor colorWithRed:245/255.0 green:150/255.0 blue:170/255.0 alpha:1.00f];
//
//        }
        _dismissLabel.font = [UIFont systemFontOfSize:dismissLabelFontSize];
        _dismissLabel.textAlignment = NSTextAlignmentCenter;
        _dismissLabel.numberOfLines = 0;
        _dismissLabel.layer.cornerRadius = 6;
        _dismissLabel.clipsToBounds = YES;
        
    }
    
    return _dismissLabel;
}

- (void)dealloc
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    
}



@end
