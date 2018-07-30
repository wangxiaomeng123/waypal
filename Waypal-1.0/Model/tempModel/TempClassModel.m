
//
//  TempClassModel.m
//  Waypal-1.0
//
//  Created by waypal on 2018/5/29.
//  Copyright © 2018年 waypal. All rights reserved.
//

#import "TempClassModel.h"

@implementation TempClassModel
-(void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    if ([key isEqualToString:@"schedule"])
    {
        NSDictionary * scheduleDict=(NSDictionary*)value;
        self.schedule_id =scheduleDict[@"id"];
        self.title=scheduleDict[@"title"];
        self.slide_count=scheduleDict[@"slide_count"];
        self.endTime =scheduleDict[@"endTime"];
        self.startTime =scheduleDict[@"startTime"];
        self.status=scheduleDict[@"status"];
        self.institutionId=scheduleDict[@"institutionId"];
        self.lesson_slide_url=scheduleDict[@"lesson_slide_url"];
        self.scenario=scheduleDict[@"scenario"];
        self.recordmode=scheduleDict[@"recordmode"];
        
    }
    if ([key isEqualToString:@"teacher"])
    {
        NSDictionary * teacherInfo=(NSDictionary *)value;
        self.teacher_id=teacherInfo[@"id"];
        self.teacher_avatar=teacherInfo[@"avatar"];
        self.teacher_name=teacherInfo[@"name"];
        
        
    }
    
}
@end
