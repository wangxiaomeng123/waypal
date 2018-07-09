
//
//  LoadingView.m
//  Waypal-1.0
//
//  Created by waypal on 2018/5/22.
//  Copyright © 2018年 waypal. All rights reserved.
//

#import "LoadingView.h"
#import "Config.h"
#import "UIImage+GIF.h"
@implementation LoadingView

-(instancetype)initWithFrame:(CGRect)frame
{
    self=[super initWithFrame:frame];
    if (self) {
        self.backgroundColor= [[UIColor blackColor] colorWithAlphaComponent:0.1];
        self.frame =CGRectMake(0, 0, lSCREEN_WIDTH, lSCREEN_HEIGHT);
        self.imageView=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 377*0.7, 131*0.7)];
        self.imageView.center=self.center;
        NSString  *filePath = [[NSBundle bundleWithPath:[[NSBundle mainBundle] bundlePath]] pathForResource:@"loading.gif" ofType:nil];
        NSData  *imageData = [NSData dataWithContentsOfFile:filePath];
        self.imageView.image=[UIImage sd_animatedGIFWithData:imageData];
        
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
