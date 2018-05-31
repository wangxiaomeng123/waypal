//
//  LessonItem.m
//  iPad_wayPal
//
//  Created by waypal on 2018/5/17.
//  Copyright © 2018年 waypal. All rights reserved.
//

#import "LessonItemView.h"
#import "Config.h"




@implementation LessonItemView

- (IBAction)touchStatusButtonAction:(id)sender {
    if (self.joinLiveRoomBlock) {
        self.joinLiveRoomBlock(self.tag);
    }
}



-(void)setDataWithLessonInfoModel:(LessonInfoModel *)lessonInfoModel
{
    self.teacher_avatarImgView.layer.borderColor=[UIColor whiteColor].CGColor;

    self.teacher_nickLabel.text =lessonInfoModel.teacher_nick;
    NSString *teach_dateStr =[lessonInfoModel.from_time substringWithRange:NSMakeRange(0, 10)];
    NSString  *teach_date=[DateTool getWeekDay:teach_dateStr];
    self.teach_dateLabel.text =teach_dateStr;
    NSString * from_time =[lessonInfoModel.from_time substringWithRange:NSMakeRange(10,lessonInfoModel.from_time.length- 13)];
    NSString  *to_time=[lessonInfoModel.to_time substringWithRange:NSMakeRange(10,lessonInfoModel.to_time.length- 13)];
    self.teach_timeLabel.text =[NSString stringWithFormat:@"%@ %@-%@",teach_date,from_time,to_time];
    self.teacher_nameLabel.text =[NSString stringWithFormat:@"%@",lessonInfoModel.teacher_name];
    [self.teacher_avatarImgView sd_setImageWithURL:[NSURL URLWithString:lessonInfoModel.teacher_portrait] placeholderImage:[UIImage imageNamed:@"lesson_adavtar"]];
    self.course_name.text =[NSString stringWithFormat:@"%@",lessonInfoModel.lesson_name];
    DDLog(@"上课状态:%d",lessonInfoModel.status);
    if (lessonInfoModel.status ==6) {
          self.bgImageView.image=[UIImage imageNamed:@"lesson_playbackBgView@2x"];
        [self.teach_statusImgView setBackgroundImage:[UIImage imageNamed:@"lesson_playback@2x"] forState:UIControlStateNormal];
    }else
    {
        self.bgImageView.image=[UIImage imageNamed:@"lesson_planet"];
        [self.teach_statusImgView setBackgroundImage:[UIImage imageNamed:@"lesson_attclass@2x"] forState:UIControlStateNormal];
    }
    
        self.lessInfoModel =lessonInfoModel;
    
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
