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

@interface LessonItemView : UIView
@property(nonatomic,strong) joinLiveRoom joinLiveRoomBlock;
@property (weak, nonatomic) IBOutlet UIImageView *teacher_avatarImgView;
@property (weak, nonatomic) IBOutlet UILabel *teach_dateLabel;

@property (weak, nonatomic) IBOutlet UILabel *teacher_nickLabel;
@property (weak, nonatomic) IBOutlet UILabel *teach_timeLabel;
@property (weak, nonatomic) IBOutlet UIButton *teach_statusImgView;
@property (nonatomic,strong) LessonInfoModel *lessInfoModel;

-(void)setDataWithLessonInfoModel:(LessonInfoModel *)lessonInfoModel;
@end
