//
//  ScaleImageView.h
//  Waypal-1.0
//
//  Created by waypal on 2018/7/6.
//  Copyright © 2018年 waypal. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ScaleImageView : UIView
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property(nonatomic,strong)UIImage *orginImage;
@end
