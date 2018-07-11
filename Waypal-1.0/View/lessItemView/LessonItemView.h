//
//  LessonItemView.h
//  iPad_wayPal
//
//  Created by waypal on 2018/5/17.
//  Copyright © 2018年 waypal. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LessonInfoModel.h"
typedef void(^joinLiveRoom)(NSInteger itemTag);

typedef void(^reviewClassWaresBlock)(NSInteger itemTag);

@interface LessonItemView : UIView
@property (weak, nonatomic) IBOutlet UIImageView *bgImageView;
@property(nonatomic,strong) joinLiveRoom joinLiveRoomBlock;
@property(nonatomic,strong)reviewClassWaresBlock reviewClassWaresBlock;
@property (weak, nonatomic) IBOutlet UIImageView *teacher_avatarImgView;
@property (weak, nonatomic) IBOutlet UILabel *teach_dateLabel;

@property (weak, nonatomic) IBOutlet UILabel *teacher_nickLabel;
@property (weak, nonatomic) IBOutlet UILabel *teach_timeLabel;
@property (weak, nonatomic) IBOutlet UIButton *teach_statusImgView;
@property (weak, nonatomic) IBOutlet UIButton *teach_classWareStatuImageView;//复习还是预习

@property (nonatomic,strong) LessonInfoModel *lessInfoModel;
@property (weak, nonatomic) IBOutlet UILabel *teacher_nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *course_name;
@property (weak, nonatomic) IBOutlet UIImageView *teacher_advatarImageView;

-(void)setDataWithLessonInfoModel:(LessonInfoModel *)lessonInfoModel;
@end
