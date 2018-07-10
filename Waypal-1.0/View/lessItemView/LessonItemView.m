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
    UIButton * btn =(UIButton *)sender;
    [[animationTool shareInstance] shakeToShow:btn];
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
    
    //    上课时间
    self.teach_timeLabel.text =[NSString stringWithFormat:@"%@ %@-%@",teach_date,from_time,to_time];
    //    老师名称
    self.teacher_nameLabel.text =[NSString stringWithFormat:@"%@",lessonInfoModel.teacher_name];
    //    课程名称
    self.course_name.text =[NSString stringWithFormat:@"%@",lessonInfoModel.lesson_name];
    //    老师头像
    [self.teacher_avatarImgView sd_setImageWithURL:[NSURL URLWithString:lessonInfoModel.teacher_portrait] placeholderImage:[UIImage imageNamed:@"lesson_adavtar"] options:SDWebImageAllowInvalidSSLCertificates];
   
    
    
    if (lessonInfoModel.status ==6) {
        self.bgImageView.image=[UIImage imageNamed:@"lesson_playbackBgView@2x"];
        [self.teach_statusImgView setBackgroundImage:[UIImage imageNamed:@"lesson_playback@2x"] forState:UIControlStateNormal];
        self.teacher_nameLabel.textColor=[UIColor colorWithHexString:@"#11748F"];
        self.teach_dateLabel.textColor =[UIColor colorWithHexString:@"#11748F"];
    }
    else
    {
        self.bgImageView.image=[UIImage imageNamed:@"lesson_planet"];
        [self.teach_statusImgView setBackgroundImage:[UIImage imageNamed:@"lesson_attclass@2x"] forState:UIControlStateNormal];
    }
    self.lessInfoModel =lessonInfoModel;
    
}



@end
