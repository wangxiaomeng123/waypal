//
//  LessonInfoModel.h
//  iPad_wayPal
//
//  Created by waypal on 2018/5/16.
//  Copyright © 2018年 waypal. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LessonInfoModel : NSObject
@property (nonatomic,strong)NSString * schedule_id;
@property(nonatomic,strong)NSString * from_time;
@property(nonatomic,strong)NSString * to_time;
@property (nonatomic,assign)int status;//状态: 0 已预约 1 即将开始 2 旷课 3 取消 4 正在上课 5 其它 6 已完成



@property(nonatomic,strong) NSString*lessonDict;
//lesson
@property (nonatomic,strong)NSString * lesson_id;//科目id
@property(nonatomic,strong) NSString*lesson_name;
@property(nonatomic,strong) NSString*lesson_seq;
@property(nonatomic,strong) NSString*lesson_category;
@property(nonatomic,strong) NSString*lesson_banner;
@property(nonatomic,strong) NSString*lesson_course_id;
@property(nonatomic,strong) NSString*lesson_logo;

//--lesson-course
@property (nonatomic,strong)NSString*course_id;
@property(nonatomic,strong) NSString*course_name_chinese;
@property(nonatomic,strong) NSString*course_name_english;
@property (nonatomic,strong)NSString*course_banner;
@property(nonatomic,strong) NSString*course_logo;


@property(nonatomic,strong) NSString*teacherDict;
@property(nonatomic,strong) NSString *teacher_id;//老师id
@property(nonatomic,strong) NSString*teacher_name;//老师名字
@property(nonatomic,strong) NSString*teacher_image_id;//老师昵称
@property(nonatomic,strong) NSString*teacher_mobile;
@property(nonatomic,strong) NSString*teacher_nick;
@property(nonatomic,strong) NSString*teacher_password_digest;
@property(nonatomic,strong) NSString*teacher_portrait;
@property(nonatomic,strong) NSString*teacher_role;
@property(nonatomic,strong) NSString*teacher_username;

//key student
@property (nonatomic,strong)NSString *student_id;//学生id
@property(nonatomic,strong) NSString * student_image_id;
@property(nonatomic,strong) NSString * student_mobile;
@property (nonatomic,strong) NSString * student_name;
@property (nonatomic,strong) NSString * student_nick;
@property (nonatomic,strong) NSString * student_password_digest;
@property (nonatomic,strong) NSString * student_portrait;
@property (nonatomic,strong) NSString * student_role;
@property (nonatomic,strong) NSString * student_username;





@end
