//
//  NavCourseView.h
//  Waypal-1.0
//
//  Created by waypal on 2018/6/30.
//  Copyright © 2018年 waypal. All rights reserved.
//
typedef void(^chooseNavCourseBlock)(NSString * nav_courseID,NSString * shelf_ImageName);
#import <UIKit/UIKit.h>
@interface NavCourseView : UIView
@property(nonatomic,strong)NSArray * titleArr;
@property (nonatomic,strong)NSMutableArray * normalImagesArr;
@property (nonatomic,strong)NSMutableArray * selectedImagesArr;
@property (nonatomic,strong)NSMutableArray * shelfImagesArr;
@property (nonatomic,strong)chooseNavCourseBlock chooseNavCourseDoingBlock;
@property(nonatomic,strong)UIButton *selectedBtn;
@property(nonatomic,assign) NSInteger pageNum;
- (instancetype)initWithFrame:(CGRect)frame titileArr:(NSArray *)titleArr;

@end
