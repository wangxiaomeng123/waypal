//
//  NewCutViewController.h
//  CharlieDemo
//
//  Created by Charlie.W on 2017/12/22.
//  Copyright © 2017年 com.charlieW. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CutImageViewController : UIViewController

- (void)cutImageWithImage:(UIImage *)image Handler:(void(^)(UIImage *image))handler;

@end
