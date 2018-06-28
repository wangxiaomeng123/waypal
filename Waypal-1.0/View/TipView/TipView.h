//
//  TipView.h
//  Waypal-1.0
//
//  Created by waypal on 2018/6/28.
//  Copyright © 2018年 waypal. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^cancelBlock)(void);
typedef void(^okBlock)(void);
@interface TipView : UIView
@property (weak, nonatomic) IBOutlet UILabel *tipContentLabel;
@property(nonatomic,strong)okBlock okDoingBlock;
-(void)showTipWithCancelBlock:(cancelBlock)cancelBlock  okBlock:(okBlock)okBlock;
@end
