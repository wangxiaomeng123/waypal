
//
//  SettingView.m
//  Waypal-1.0
//
//  Created by waypal on 2018/5/19.
//  Copyright © 2018年 waypal. All rights reserved.
//

#import "SettingView.h"
#import "Config.h"
@implementation SettingView
- (IBAction)upVersionAction:(id)sender {
    if (self.upVersionBlock) {
        self.upVersionBlock(@"1.0");
    }
}
- (IBAction)loginOutAction:(id)sender {
    
    if (self.loginOutBlock) {
        self.loginOutBlock();
    }

}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
