//
//  MUNCelestialAnimate.h
//  MyUni
//
//  Created by Administrator on 2017/10/13.
//  Copyright © 2017年 tion_Z. All rights reserved.
//

#import <UIKit/UIKit.h>
#define View_width self.frame.size.width
#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)
#define COLOR(R, G, B, A) [UIColor colorWithRed:R/255.0 green:G/255.0 blue:B/255.0 alpha:A]

@protocol StarrySkyAnimateDelegate <NSObject>

- (void)clickButtonAction:(NSInteger)index;

@end

@interface StarrySkyAnimate : UIView

@property (nonatomic, copy) void (^tapButtonBlock)(NSInteger buttonTag);
-(void)setCelestialName:(NSArray *)names;
@property (nonatomic, weak) id<StarrySkyAnimateDelegate> delegate;
@end
