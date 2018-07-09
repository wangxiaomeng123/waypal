//
//  LInspectionClass.h
//  xiaojingyu
//
//  Created by lintao li on 2017/10/13.
//  Copyright © 2017年 kekejl. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface LInspectionClass : NSObject

///**
// *  判断输入手机号是否有效
// *
// *  @param mobile 输入的手机号
// *
// *  @return 是否是有效
// */
//+(BOOL) isValidateMobile:(NSString *)mobile;

/**
 *  判断输入内容是否为汉字
 *
 *  @param string 输入的内容
 *
 *  @return 是否成立
 */
+(BOOL) isValidateChinese:(NSString *)string;


/**
 *  判断输入邮箱是否正确
 *
 *  @param emailString 输入的邮箱
 *
 *  @return 是否有效
 */
+(BOOL) isValidateEmail:(NSString *)emailString;



//判断是不是有效的数字 0-9
+(BOOL) validatePassNumber:(NSString*)number;


/**
 *  判断是否是有效的身份证号
 *
 *  @param identityCard 输入的身份号码
 *
 *  @return 是否有效
 */
+ (BOOL) validateIdentityCard: (NSString *)identityCard;



/**
 判断昵称是否有效

 @param nickNameString 昵称
 @return 是否有效
 */
+ (BOOL) validateNickName:(NSString *)nickNameString;


/**
 *  获取一个随机整数，范围在[from,to）包括from，包括to
 *
 *  @param from 起始数字
 *  @param to   截止数字
 *
 *  @return 随机数
 */
+ (int)getRandomNumber:(int)from to:(int)to;




/**
 *  查找当前显示的控制器
 *
 *  @return 控制器
 */
+ (UIViewController *)activityViewController;



/**
 *  修改不同大小字体
 *
 *  @param text     全部字符
 *  @param needText 需要变小的字符
 *  @param maxSize  最大字体
 *  @param minSize  最小字体
 *
 *  @return 字符串
 */
+ (NSAttributedString *) changeLabelWithText:(NSString *)text smallText:(NSString*)needText maxSizeFont:(int)maxSize minSizeFont:(int)minSize;



/**
 *  修改不同颜色字体
 *
 *  @param text     全部字符
 *  @param needText 需要变颜色的字符
 *  @param color    颜色
 *
 *  @return 字符串
 */
+ (NSAttributedString *) changeLabelWithColor:(NSString *)text colorText:(NSString *)needText color:(UIColor *)color;



/**
 按照${}规则替换不同字体颜色

 @param text 全部字符
 @return 字符串
 */
+ (NSAttributedString *)changeStringColorAtFormatText:(NSString *)text color:(UIColor *)color;


/**
 *  判断是否含有特殊字符
 *
 *  @param str 将要处理的字符串
 *
 *  @return 处理后的结果
 */
+(BOOL)isIncludeSpecialCharact: (NSString *)str;



/**
 *根据颜色生成图片
 *
 *  @param color 颜色
 *
 *  @return 图片
 */
+ (UIImage *) createImageWithColor:(UIColor *)color;





/**
 获取设备型号

 @return 当前设备型号字符串
 */
+ (NSString *)iphoneType;




/**
 计算字符串高度

 @param width UI控件的宽度
 @param size 字体大小
 @param content 要计算的文字
 @return 当前字体大小在当前宽度的控件内文字的高度
 */
+ (CGFloat) stringHightWithUIWidth:(CGFloat)width fontSize:(CGFloat)size string:(NSString *)content;


/**
 生成二维码

 @param string 字符串
 @param size 图片大小
 @return 返回图片
 */
+ (UIImage *)createQrcodeWithString:(NSString *)string Size:(CGFloat)size;


/**
 对数据进行base64编码

 @param data 需要加密的数据，一般为NSString或者NSData
 @return 加密后
 */
+ (NSString *)encodingDataWithBase64:(id)data;



/**
 解码 base64加密串

 @param base64Encoded 加密串
 @return 解密后的串
 */
+ (NSString *) decodingStringWithBase64:(NSString *)base64Encoded;



/**
 判断银行卡号是否有效

 @param cardNumber 银行卡号
 @return 是否正确
 */
+ (BOOL) checkCardNumber:(NSString*) cardNumber;

/**
 修改string的✨✨数

 @param nstring 原始字符串
 @param startLoaction 开始位置
 @param startNumber 星星个数
 @return 修改完成的字符串
 */
+ (NSString *)changeString:(NSString *)nstring withStartLocation:(NSInteger )startLoaction startNumber:(NSInteger)startNumber;



/**
 是否可以使用相机

 @return 是否
 */
+ (BOOL) canUseCamera;


/**
 设置当前控制器的返回按钮，需要在控制器内实现 -(void)backAction 方法。

 @param delegate 控制器
 @return 返回按钮
 */
+ (UIBarButtonItem *)backButtonItem:(UIViewController *)delegate;




/**
 返回当前控制器的导航栏按钮，需要在控制器内实现方法


 @param itemTitle 按钮名字
 @param delegate 按钮所在的控制器
 @param action 按钮要执行的方法
 @return bar按钮
 */
+ (UIBarButtonItem *)barButtonItemTitle:(NSString *)itemTitle controller:(UIViewController *)delegate clickAction:(SEL)action;

/**
 判断字符串是否为空

 @param valueString 目标字符串
 @return return value description
 */
+ (BOOL) isValueStringNull:(NSString *)valueString;


/**
 对URL特殊字符处理

 @param extendString 网址后半段
 @return 处理结果
 */
+ (NSString *) encodingURLWithUTF8Extend:(NSString *)extendString;


+ (NSMutableAttributedString *)clChangeLabelWithColor:(NSString *)text colorText:(NSString *)needText color:(UIColor *)color;



/**
 设置带有下划线的button

 @param font 字体大小
 @param colorHEX 字体颜色
 @param lineColorHEX 下划线的颜色
 @param textStr button的title
 @return 富文本
 */
+(NSAttributedString *)setButtonFont:(int ) font  textColor:(int  )colorHEX   lineColor:(int )lineColorHEX  text:(NSString *)textStr;


@end
