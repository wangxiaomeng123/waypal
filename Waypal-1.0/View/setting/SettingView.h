//
//  SettingView.h
//  Waypal-1.0
//
//  Created by waypal on 2018/5/19.
//  Copyright © 2018年 waypal. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^upVersionBlock)(NSString * currentVersion);
typedef void(^loginOutBlock)(void);
@interface SettingView : UIView

@property (weak, nonatomic) IBOutlet UIButton *loginOutBtn;
@property (weak, nonatomic) IBOutlet UIButton *upVersionBtn;
@property (nonatomic,strong) upVersionBlock upVersionBlock;
@property (nonatomic,strong) loginOutBlock loginOutBlock;

@end
