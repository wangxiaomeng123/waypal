//
//  TempClassViewController.h
//  iPad_wayPal
//
//  Created by waypal on 2018/5/18.
//  Copyright © 2018年 waypal. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TempClassModel.h"
typedef void(^enterTempClassBlock)(TempClassModel* tempModel);

@interface TempClassViewController : UIViewController
@property (nonatomic,strong)enterTempClassBlock enterTempClassBlockDoing;
@end
