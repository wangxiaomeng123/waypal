//
//  MInspectClass.m
//  Waypal-1.0
//
//  Created by waypal on 2018/6/7.
//  Copyright © 2018年 waypal. All rights reserved.
//

#import "MInspectClass.h"
#define lphoneRegex  @"^(0|86|17951)?(13[0-9]|15[012356789]|17[0-9]|18[0-9]|14[57]|16[0-9]|19[0-9])[0-9]{8}$"
@implementation MInspectClass
+(BOOL) isValidateMobile:(NSString *)mobile
{
    //手机号以13， 15，18, 17, 14开头，八个 \d 数字字符
    NSString *phoneRegex = lphoneRegex;
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    return [phoneTest evaluateWithObject:mobile];
}

+(NSString*)createUuid
{
//    char data[12];
//    for (int x=0;x<12;data[x++] = (char)('A' + (arc4random_uniform(26))));
//    return [[NSString alloc] initWithBytes:data length:32 encoding:NSUTF8StringEncoding];
    NSString *letters = @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ";
    NSMutableString *randomString = [NSMutableString stringWithCapacity: 12];
    for (NSInteger i = 0; i < 12; i++) {
        [randomString appendFormat: @"%C", [letters characterAtIndex: arc4random_uniform([letters length])]];
    }
    return randomString;
    
    
}
+(NSString *)timeStampWithTime:(NSDate*)date{
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[date timeIntervalSince1970]];
    return timeSp;
}
+(NSDictionary *)setTextLineSpaceWithString:(NSString *)string withLineBreakMode:(NSLineBreakMode)lineBreakMode withAlignment:(NSTextAlignment)alignment withFont:(UIFont *)font withLineSpace:(CGFloat)lineSpace withTextlengthSpace:(NSNumber *)textlengthSpace andParagraphSpaceing:(CGFloat)paragraphSpacing {
    // 1. 创建样式对象
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    // 2. 每行容纳字符的宽度
    style.lineBreakMode = lineBreakMode;
    // 3. 对齐方式
    style.alignment = alignment;
    // 4. 设置行间距
    style.lineSpacing = lineSpace;
    // 5. 连字符号链接
    style.hyphenationFactor = 1.0f;
    // 6. 首行缩进
    style.firstLineHeadIndent = 30.0f;
    // 7. 段间距
    style.paragraphSpacing = paragraphSpacing;
    // 8. 段前间距
    style.paragraphSpacingBefore = 0.0f;
    // 9. 除首行之外其他行缩进
    style.headIndent = 0.0f;
    // 10. 每行容纳字符的宽度
    style.tailIndent = 0.0f;
    NSDictionary *dict = @{NSFontAttributeName : font,
                           NSParagraphStyleAttributeName : style,
                           NSKernAttributeName : textlengthSpace,
                           };
    return dict;
}

@end
