//
//  ScaleImageView.m
//  Waypal-1.0
//
//  Created by waypal on 2018/7/6.
//  Copyright © 2018年 waypal. All rights reserved.
//

#import "ScaleImageView.h"

@implementation ScaleImageView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(void)layoutSubviews
{
    self.imageView.layer.cornerRadius=5.0;
    self.imageView.layer.masksToBounds =YES;
    self.imageView.contentMode=UIViewContentModeScaleAspectFit;
    self.imageView.image=_orginImage;
    self.imageView.userInteractionEnabled =YES;

}

@end
