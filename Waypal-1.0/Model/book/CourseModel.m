//
//  CourseModel.m
//  Waypal-1.0
//
//  Created by waypal on 2018/6/13.
//  Copyright © 2018年 waypal. All rights reserved.
//

#import "CourseModel.h"

@implementation CourseModel
-(void)setValue:(id)value forUndefinedKey:(NSString *)key{
    if ([key isEqualToString:@"id"]) {
        self.NavCourseId =value;
    }
}
@end
