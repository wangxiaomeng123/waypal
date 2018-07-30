//
//  LoadingView.h
//  Waypal-1.0
//
//  Created by waypal on 2018/5/22.
//  Copyright © 2018年 waypal. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoadingView : UIView
@property(nonatomic,strong)UIImageView * imageView;
-(void)showLoadingView;
-(void)hiddenLoadingView;
+(void)tipViewWithTipString:(NSString *)tipMsg;
@end
