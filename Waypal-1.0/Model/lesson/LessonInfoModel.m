
//
//  LessonInfoModel.m
//  iPad_wayPal
//
//  Created by waypal on 2018/5/16.
//  Copyright © 2018年 waypal. All rights reserved.
//

#import "LessonInfoModel.h"

@implementation LessonInfoModel
-(void)setValue:(id)value forUndefinedKey:(NSString *)key
{
     
    if ([key isEqualToString:@"id"]) {
        self.schedule_id =[NSString stringWithFormat:@"%@",value];
    }
    if ([key isEqualToString:@"lesson"]) {
        NSDictionary *lesssonDict=(NSDictionary *)value;
        
        self.lesson_category =lesssonDict[@"category"];
        self.lesson_id=lesssonDict[@"id"] ;
        self.lesson_name=lesssonDict[@"name"];
        self.lesson_seq =lesssonDict[@"seq"];
        self.lesson_banner =lesssonDict[@"banner"];
        self.lesson_course_id=lesssonDict[@"course_id"] ;
        self.lesson_logo=lesssonDict[@"logo"];
        
        
        
        NSDictionary *courseDict=lesssonDict[@"course"];
        self.course_id=courseDict[@"id"] ;
        self.course_name_chinese=courseDict[@"name_chinese"];
        self.course_name_english=courseDict[@"name_english"];
        self.course_logo=courseDict[@"logo"] ;
        self.course_banner=courseDict[@"banner"];
     
        
        
    }
    if ([key isEqualToString:@"teacher"]) {
        NSDictionary *teacherDict = (NSDictionary *)value;
        self.teacher_id=teacherDict[@"id"] ;
        self.teacher_name=teacherDict[@"name"];
        self.teacher_nick =teacherDict[@"nick"];
        self.teacher_image_id=teacherDict[@"image_id"] ;
        self.teacher_password_digest=teacherDict[@"password_digest"];
        self.teacher_mobile =teacherDict[@"mobile"];
        self.teacher_portrait=teacherDict[@"avatar"] ;
        self.teacher_role=teacherDict[@"role"];
        self.teacher_username =teacherDict[@"username"];

        
        
    }
    if ([key isEqualToString:@"student"]) {
        NSDictionary *studentDict = (NSDictionary *)value;
        self.student_id=studentDict[@"id"];
        self.student_image_id=studentDict[@"image_id"];
        self.student_mobile=studentDict[@"mobile"];
        self.student_name=studentDict[@"name"];
        self.student_nick=studentDict[@"nick"];
        self.student_password_digest=studentDict[@"password_digest"];
        self.student_portrait=studentDict[@"avatar"];
        self.student_role=studentDict[@"role"];
        self.student_username=studentDict[@"username"];
    }
    
    
    
}
@end
