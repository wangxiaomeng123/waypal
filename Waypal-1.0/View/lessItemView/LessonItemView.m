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
#pragma mark 预习或者复习
- (IBAction)reviewClassWaresAction:(id)sender {
    if (self.isCanPreView) {
        if (self.reviewClassWaresBlock)
        {
         self.reviewClassWaresBlock(self.tag,self.isReview);
        }
    }else{
        [LoadingView tipViewWithTipString:@"课前1小时可以开始预习哦！"];
    }
   
}

#pragma mark 进入教室
- (IBAction)touchStatusButtonAction:(id)sender {
    UIButton * btn =(UIButton *)sender;
//    [[animationTool shareInstance] shakeToShow:btn];
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
    
     int mintue= [DateTool dateTimeDifferenceWithStartTime:[DateTool currentDateString] endTime:lessonInfoModel.from_time];
    
    //    上课时间
    self.teach_timeLabel.text =[NSString stringWithFormat:@"%@ %@-%@",teach_date,from_time,to_time];
    //    老师名称
    self.teacher_nameLabel.text =[NSString stringWithFormat:@"%@",lessonInfoModel.teacher_name];
    //    课程名称
    self.course_name.text =[NSString stringWithFormat:@"%@",lessonInfoModel.lesson_name];
    //    老师头像
    [self.teacher_avatarImgView sd_setImageWithURL:[NSURL URLWithString:lessonInfoModel.teacher_portrait] placeholderImage:[UIImage imageNamed:@"lesson_adavtar"] options:SDWebImageAllowInvalidSSLCertificates];
   
    
//
    if (lessonInfoModel.status ==6) {
        self.isReview=YES;
        self.isCanPreView=YES;
        self.bgImageView.image=[UIImage imageNamed:@"lesson_playbackBgView@2x"];
        [self.teach_statusImgView setBackgroundImage:[UIImage imageNamed:@"lesson_playback"] forState:UIControlStateNormal];
        self.teacher_nameLabel.textColor=[UIColor colorWithHexString:@"#11748F"];
        self.teach_dateLabel.textColor =[UIColor colorWithHexString:@"#11748F"];
        [self.teach_classWareStatuImageView setImage:[UIImage imageNamed:@"review"] forState:UIControlStateNormal];
    }
    else
    {
        self.isReview =NO;
      // 预习
        self.bgImageView.image=[UIImage imageNamed:@"lesson_planet"];
        [self.teach_statusImgView setBackgroundImage:[UIImage imageNamed:@"lesson_attclass"] forState:UIControlStateNormal];
      [self.teach_classWareStatuImageView setImage:[UIImage imageNamed:@"preview"] forState:UIControlStateNormal];
        CGFloat orgin_previewX=self.teach_classWareStatuImageView.origin.x;
         CGFloat orgin_clasX=self.teach_statusImgView.origin.x;
        
        // 60分外无上课 预习置灰 点击可提示
        if (mintue>60)
        {
            self.isCanPreView=NO; self.teach_classWareStatuImageView.transform=CGAffineTransformMakeTranslation(orgin_previewX+20,0);
            [self.teach_classWareStatuImageView setImage:[UIImage imageNamed:@"preview_gray"] forState:UIControlStateNormal];
           self.teach_statusImgView.hidden=YES;
            
        }
//        可以预习 无上课
        else if (mintue>30&&mintue<60)
        {
            self.teach_classWareStatuImageView.enabled=YES;
            self.teach_statusImgView.hidden=YES;
     self.teach_classWareStatuImageView.transform=CGAffineTransformMakeTranslation(orgin_previewX+20,0);
            self.isCanPreView=YES;
        }
//        预习上课均有
        else if (mintue<=30&&mintue>0)
        {
            self.isCanPreView=YES;
            self.teach_classWareStatuImageView.enabled=YES;
            self.teach_statusImgView.hidden=NO;
        }
//        无预习 只有上课
        else if (mintue<=0)
        {
        self.isCanPreView=NO;
        self.teach_classWareStatuImageView.hidden=YES;
        self.teach_statusImgView.enabled=YES;
        self.teach_statusImgView.transform= CGAffineTransformMakeTranslation(-65,0);
        }
    }
    self.lessInfoModel =lessonInfoModel;
}


@end
