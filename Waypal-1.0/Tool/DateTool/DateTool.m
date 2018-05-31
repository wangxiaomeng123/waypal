

//
//  DateTool.m
//  iPad_wayPal
//
//  Created by waypal on 2018/5/17.
//  Copyright © 2018年 waypal. All rights reserved.
//

#import "DateTool.h"

@implementation DateTool

+ (NSString*)getWeekDay:(NSString*)currentStr
{
    NSDateFormatter* dateFormat = [[NSDateFormatter alloc]init];//实例化一个NSDateFormatter对象
    
    [dateFormat setDateFormat:@"yyyy-MM-dd"];//设定时间格式,要注意跟下面的dateString匹配，否则日起将无效
    
    NSDate*date =[dateFormat dateFromString:currentStr];
    
    NSArray*weekdays = [NSArray arrayWithObjects: [NSNull null],@"周日",@"周一",@"周二",@"周三",@"周四",@"周五",@"周六",nil];
    
    NSCalendar*calendar = [[NSCalendar alloc]initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    
    NSTimeZone*timeZone = [[NSTimeZone alloc]initWithName:@"Asia/Shanghai"];
    
    [calendar setTimeZone: timeZone];
    
    NSCalendarUnit calendarUnit =NSCalendarUnitWeekday;
    
    NSDateComponents*theComponents = [calendar components:calendarUnit fromDate:date];
    
    return[weekdays objectAtIndex:theComponents.weekday];
    
}



+(NSString*)weekdayStringFromDate:(NSDate*)inputDate {
    
    NSArray *weekdays = [NSArray arrayWithObjects: [NSNull null], @"星期天", @"星期一", @"星期二", @"星期三", @"星期四", @"星期五", @"星期六", nil];
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    
    NSTimeZone *timeZone = [[NSTimeZone alloc] initWithName:@"Asia/SuZhou"];
    
    [calendar setTimeZone: timeZone];
    
    NSCalendarUnit calendarUnit = NSCalendarUnitWeekday;
    
    NSDateComponents *theComponents = [calendar components:calendarUnit fromDate:inputDate];
    
    return [weekdays objectAtIndex:theComponents.weekday];
    
}
+(NSString *)currentDateString{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    NSDate *datenow = [NSDate date];
    NSString *nowtimeStr = [formatter stringFromDate:datenow];
    return nowtimeStr;

}

@end
