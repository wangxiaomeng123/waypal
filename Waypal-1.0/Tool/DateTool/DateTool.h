//
//  DateTool.h
//  iPad_wayPal
//
//  Created by waypal on 2018/5/17.
//  Copyright © 2018年 waypal. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DateTool : NSObject
+(NSString*)getWeekDay:(NSString*)currentStr;

+(NSString*)weekdayStringFromDate:(NSDate*)inputDate;

+(NSString *)currentDateString;
//分钟计算
+ (int)dateTimeDifferenceWithStartTime:(NSString *)startTime endTime:(NSString *)endTime;
+ (void)countDownWithTime:(int)time
           countDownBlock:(void (^)(int timeLeft))countDownBlock
                 endBlock:(void (^)(void))endBlock;
@end
