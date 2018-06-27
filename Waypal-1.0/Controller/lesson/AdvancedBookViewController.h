//
//  AdvancedBookViewController.h
//  Waypal-1.0
//
//  Created by waypal on 2018/6/26.
//  Copyright © 2018年 waypal. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^dissMissBlock)(void);

@interface AdvancedBookViewController : UIViewController
@property (weak, nonatomic) IBOutlet UICollectionView *bookCollectionView;
@property(nonatomic,strong)dissMissBlock dismissDoingBlock;
@property(nonatomic,strong)NSArray * navCourseArr;

@end
