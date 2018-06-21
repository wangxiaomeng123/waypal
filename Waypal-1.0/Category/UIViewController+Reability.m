


//
//  UIViewController+Reability.m
//  Waypal-1.0
//
//  Created by waypal on 2018/5/26.
//  Copyright © 2018年 waypal. All rights reserved.
//

#import "UIViewController+Reability.h"
#import "NetworkingTool.h"
#import <objc/runtime.h>
#import "UIView+Extension.h"
@implementation UIViewController (Reability)
+(void)load
{
    Method fromMethod =class_getClassMethod([self class], @selector(viewDidLoad));
    Method toMethod =class_getClassMethod([self class], @selector(swizzlingViewDidLoad));
    if (!class_addMethod([self class], @selector(viewDidLoad), method_getImplementation(toMethod), method_getTypeEncoding(toMethod)))
    {
        
        method_exchangeImplementations(fromMethod, toMethod);
        
    }
    
}
- (void)swizzlingViewDidLoad {
    self.view.centerY=-20;
    [NetworkingTool netWorkReachability];
}
- (BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    return (UIInterfaceOrientationLandscapeRight | UIInterfaceOrientationLandscapeLeft);
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskLandscapeRight | UIInterfaceOrientationMaskLandscapeLeft;
}

//必须有
-(UIInterfaceOrientation)preferredInterfaceOrientationForPresentation{
    return UIInterfaceOrientationLandscapeRight;
}
@end
