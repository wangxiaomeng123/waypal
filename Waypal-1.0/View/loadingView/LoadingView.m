
//
//  LoadingView.m
//  Waypal-1.0
//
//  Created by waypal on 2018/5/22.
//  Copyright © 2018年 waypal. All rights reserved.
//

#import "LoadingView.h"
#import "Config.h"
@implementation LoadingView

-(instancetype)init
{
    if (self=[super init]) {
        self.backgroundColor= [[UIColor blackColor] colorWithAlphaComponent:0.5];
        self.frame =CGRectMake(0, 0, lSCREEN_WIDTH, lSCREEN_HEIGHT);
        self.imageView=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 460, 163)];
        self.imageView.center=self.center;
        self.imageView.image =[UIImage imageNamed:@"gloal_loading@2x"];
        [self addSubview:_imageView];
    }
    return self;
}
-(void)showLoadingView{
  
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self removeFromSuperview];
    });
}
-(void)hiddenLoadingView{
    [self removeFromSuperview];
}
+(void)tipViewWithTipString:(NSString *)tipMsg
{
    [[LAlertViewCustom sharedInstance]alertViewTitle:nil content:tipMsg leftButtonTitle:tipMsg rightButtonTitle:nil autoDismiss:YES rightButtonTapDoing:nil leftButtonTapORDismissDoing:nil];
}
@end
