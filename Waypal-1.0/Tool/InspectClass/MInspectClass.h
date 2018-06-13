//
//  MInspectClass.h
//  Waypal-1.0
//
//  Created by waypal on 2018/6/7.
//  Copyright © 2018年 waypal. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface MInspectClass : NSObject
/**
 *  判断输入手机号是否有效
 *
 *  @param mobile 输入的手机号
 *
 *  @return 是否是有效
 */
+(BOOL) isValidateMobile:(NSString *)mobile;


/**
 随机生成12位字符

 @return 随机生成12位字符
 */
+(NSString*)createUuid;

/**
 时间转换时间戳

 @param date 时间
 @return 时间戳
 */
+(NSString *)timeStampWithTime:(NSDate *)date;

@end
