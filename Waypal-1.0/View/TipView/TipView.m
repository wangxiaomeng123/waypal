//
//  TipView.m
//  Waypal-1.0
//
//  Created by waypal on 2018/6/28.
//  Copyright © 2018年 waypal. All rights reserved.
//

#import "TipView.h"
#import "Config.h"
@implementation TipView

- (IBAction)cancelAction:(id)sender {
    [self jk_hideView];
}
- (IBAction)okAction:(id)sender {
       [self jk_hideView];
    if (self.okDoingBlock) {
        self.okDoingBlock();
    }
}

@end
