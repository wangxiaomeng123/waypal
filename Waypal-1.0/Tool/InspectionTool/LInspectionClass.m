//
//  LInspectionClass.m
//  xiaojingyu
//
//  Created by lintao li on 2017/10/13.
//  Copyright © 2017年 kekejl. All rights reserved.
//

#import "LInspectionClass.h"
#import <sys/utsname.h>
#import <AVFoundation/AVMediaFormat.h>
#import <AVFoundation/AVCaptureDevice.h>



#define lphoneRegex  @"^(0|86|17951)?(13[0-9]|15[012356789]|17[0-9]|18[0-9]|14[57]|16[0-9]|19[0-9])[0-9]{8}$"
#define lChineseRegex @"[\u4e00-\u9fa5]+"
#define lEmailRegex @"^[a-zA-Z0-9_-]+@[a-zA-Z0-9_-]+(\\.[a-zA-Z0-9_-]+)+$"
#define lCarIDRegex @"^(\\d{14}|\\d{17})(\\d|[xX])$"
#define lNickNameRegex @"[a-zA-Z\u4e00-\u9fa5][a-zA-Z0-9\u4e00-\u9fa5]+"

@implementation LInspectionClass

//
//+(BOOL) isValidateMobile:(NSString *)mobile
//{
////    手机号以13， 15，18, 17, 14开头，八个 \d 数字字符
//    if ([[Admin sharedInstance] closePhoneValidation])
//    {
//        return YES;
//    }
//    NSString *phoneRegex = lphoneRegex;
//    if ([APPSettingInfo sharedInstance].serverPhoneRegex)
//    {
//        phoneRegex = [APPSettingInfo sharedInstance].serverPhoneRegex;
//    }
//
//    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
//    return [phoneTest evaluateWithObject:mobile];
//}



+(BOOL) isValidateChinese:(NSString *)string
{
    NSString *chineseRegex = lChineseRegex;
    NSPredicate *chineseTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",chineseRegex];
    return [chineseTest evaluateWithObject:string];
}

+(BOOL)isValidateEmail:(NSString *)emailString
{
    NSString *emailRegex = lEmailRegex;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:emailString];
}

+(BOOL)validatePassNumber:(NSString*)number{
    BOOL res = YES;
    NSCharacterSet* tmpSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
    int i = 0;
    while (i < number.length) {
        NSString * string = [number substringWithRange:NSMakeRange(i, 1)];
        NSRange range = [string rangeOfCharacterFromSet:tmpSet];
        if (range.length == 0) {
            res = NO;
            
            break;
        }
        i++;
    }
    return res;
}

+ (BOOL) validateIdentityCard: (NSString *)identityCard
{
    BOOL flag;
    if (identityCard.length <= 0) {
        flag = NO;
        return flag;
    }
    NSString *regex2 = lCarIDRegex;
    NSPredicate *identityCardPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex2];
    return [identityCardPredicate evaluateWithObject:identityCard];
}


+ (BOOL)validateNickName:(NSString *)nickNameString
{
    return YES;
    NSString *chineseRegex = lNickNameRegex;
    NSPredicate *chineseTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",chineseRegex];
    return [chineseTest evaluateWithObject:nickNameString];
}

+ (int)getRandomNumber:(int)from to:(int)to{
    return (int)(from + (arc4random() % (to - from + 1)));
}


+ (UIViewController *)activityViewController
{
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    if(window.windowLevel != UIWindowLevelNormal)
    {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow *tmpWin in windows)
        {
            if(tmpWin.windowLevel == UIWindowLevelNormal)
            {
                window = tmpWin;
                break;
            }
        }
    }
    NSArray *viewsArray = [window subviews];
    UIView * frontView = [viewsArray objectAtIndex:0];
    id vc = [frontView nextResponder];
    if ([vc isKindOfClass:[UITabBarController class]]) {
        UITabBarController *tab = (UITabBarController *)vc;
        if ([tab.selectedViewController isKindOfClass:[UINavigationController class]]) {
            UINavigationController *nav = (UINavigationController *)tab.selectedViewController;
            return [nav.viewControllers lastObject];
        } else {
            return tab.selectedViewController;
        }
    } else if ([vc isKindOfClass:[UINavigationController class]]) {
        UINavigationController *nav = (UINavigationController *)vc;
        return [nav.viewControllers lastObject];
    } else {
        return vc;
    }
    return nil;
}


+ (NSAttributedString*) changeLabelWithText:(NSString *)text smallText:(NSString*)needText maxSizeFont:(int)maxSize minSizeFont:(int)minSize
{
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:text];
    UIFont *font = [UIFont systemFontOfSize:maxSize];
    NSRange range = [text rangeOfString:needText];
    [attrString addAttribute:NSFontAttributeName value:font range:NSMakeRange(0,text.length)];
    [attrString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:minSize] range:range];
    
    return attrString;
}


+ (NSAttributedString *)changeLabelWithColor:(NSString *)text colorText:(NSString *)needText color:(UIColor *)color
{
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:text];
    NSRange range = [text rangeOfString:needText];
    [attrString addAttribute:NSForegroundColorAttributeName value:color range:range];
    return (NSAttributedString *)attrString;
}

+ (NSMutableAttributedString *)clChangeLabelWithColor:(NSString *)text colorText:(NSString *)needText color:(UIColor *)color
{
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:text];
    NSRange range = [text rangeOfString:needText];
    [attrString addAttribute:NSForegroundColorAttributeName value:color range:range];
    return attrString;
}


+ (NSAttributedString *)changeStringColorAtFormatText:(NSString *)text color:(UIColor *)color
{
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] init];
    NSMutableString *string = [NSMutableString stringWithString:text];
    NSMutableArray *pieceArray = [NSMutableArray arrayWithCapacity:1];
    while ([string rangeOfString:@"${"].location != NSNotFound)
    {
        NSRange endRange = [string rangeOfString:@"}"];
        NSString *temp = [string substringToIndex:endRange.location + endRange.length];
        [string deleteCharactersInRange:NSMakeRange(0, endRange.location + endRange.length)];
        [pieceArray addObject:temp];
    }
    for (NSString *item in pieceArray)
    {
        NSRange
        startRange = [item rangeOfString:@"${"];
        
        NSRange
        endRange = [item rangeOfString:@"}"];
        
        NSRange
        range = NSMakeRange(startRange.location
                            + startRange.length,
                            endRange.location
                            - startRange.location
                            - startRange.length);
        
        NSString *result = [item substringWithRange:range];
        NSMutableString *s = [NSMutableString stringWithString:item];
        [s deleteCharactersInRange:endRange];
        [s deleteCharactersInRange:startRange];
        NSAttributedString *tempAttString  = [self changeLabelWithColor:s colorText:result color:color];
        [attrString appendAttributedString:tempAttString];
    }
    NSAttributedString *lastString = [[NSAttributedString alloc] initWithString:string];
    [attrString appendAttributedString:lastString];
    return (NSAttributedString*)attrString;
}





+(BOOL)isIncludeSpecialCharact: (NSString *)str {
    //***需要过滤的特殊字符：~￥#&*<>《》()[]{}【】^@/￡¤￥|§¨「」『』￠￢￣~@#￥&*（）——+|《》$_€。
    NSRange urgentRange = [str rangeOfCharacterFromSet: [NSCharacterSet characterSetWithCharactersInString: @"~￥#&*<>《》()[]{}【】^@/￡¤￥|§¨「」『』￠￢￣~@#￥&*（）——+|《》$_€"]];
    if (urgentRange.location == NSNotFound)
    {
        return NO;
    }
    return YES;
}

+ (UIImage *)createImageWithColor:(UIColor *)color
{
    CGRect rect = CGRectMake(0, 0, 1,1);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}


+ (NSString *)iphoneType
{
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *platform = [NSString stringWithCString:systemInfo.machine encoding:NSASCIIStringEncoding];
    if ([platform isEqualToString:@"iPhone1,1"]) return @"iPhone 2G";
    if ([platform isEqualToString:@"iPhone1,2"]) return @"iPhone 3G";
    if ([platform isEqualToString:@"iPhone2,1"]) return @"iPhone 3GS";
    if ([platform isEqualToString:@"iPhone3,1"]) return @"iPhone 4";
    if ([platform isEqualToString:@"iPhone3,2"]) return @"iPhone 4";
    if ([platform isEqualToString:@"iPhone3,3"]) return @"iPhone 4";
    if ([platform isEqualToString:@"iPhone4,1"]) return @"iPhone 4S";
    if ([platform isEqualToString:@"iPhone5,1"]) return @"iPhone 5";
    if ([platform isEqualToString:@"iPhone5,2"]) return @"iPhone 5";
    if ([platform isEqualToString:@"iPhone5,3"]) return @"iPhone 5c";
    if ([platform isEqualToString:@"iPhone5,4"]) return @"iPhone 5c";
    if ([platform isEqualToString:@"iPhone6,1"]) return @"iPhone 5s";
    if ([platform isEqualToString:@"iPhone6,2"]) return @"iPhone 5s";
    if ([platform isEqualToString:@"iPhone7,1"]) return @"iPhone 6 Plus";
    if ([platform isEqualToString:@"iPhone7,2"]) return @"iPhone 6";
    if ([platform isEqualToString:@"iPhone8,1"]) return @"iPhone 6s";
    if ([platform isEqualToString:@"iPhone8,2"]) return @"iPhone 6s Plus";
    if ([platform isEqualToString:@"iPhone8,4"]) return @"iPhone SE";
    if ([platform isEqualToString:@"iPhone9,1"]) return @"iPhone 7";
    if ([platform isEqualToString:@"iPhone9,2"]) return @"iPhone 7 Plus";
    if ([platform isEqualToString:@"iPhone10,1"]) return@"iPhone 8";
    if ([platform isEqualToString:@"iPhone10,4"]) return@"iPhone 8";
    if ([platform isEqualToString:@"iPhone10,2"]) return@"iPhone 8 Plus";
    if ([platform isEqualToString:@"iPhone10,5"]) return@"iPhone 8 Plus";
    if ([platform isEqualToString:@"iPhone10,3"]) return@"iPhone X";
    if ([platform isEqualToString:@"iPhone10,6"]) return@"iPhone X";
    if ([platform isEqualToString:@"i386"])      return @"iPhone Simulator";
    if ([platform isEqualToString:@"x86_64"])    return @"iPhone Simulator";
    return platform;
}



+ (CGFloat)stringHightWithUIWidth:(CGFloat)width fontSize:(CGFloat)size string:(NSString *)content
{
    NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:size]};
    CGSize textSize = [content boundingRectWithSize:CGSizeMake(width, 2000) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
    CGFloat height =textSize.height;
    return height;
}


+ (NSString *)encodingDataWithBase64:(id)data
{
    if ([data isKindOfClass:[NSString class]])
    {
        NSData * baseData = [data dataUsingEncoding:NSUTF8StringEncoding];
        return [baseData base64EncodedStringWithOptions:0];
    }
    if ([data isKindOfClass:[NSData class]])
    {
        return [data base64EncodedStringWithOptions:0];
    }
    return nil;
    
    
}

+(NSString *)decodingStringWithBase64:(NSString *)base64Encoded
{
    NSData *data = [[NSData alloc]initWithBase64EncodedString:base64Encoded options:0];
    return [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
}
+ (UIImage *)createQrcodeWithString:(NSString *)string Size:(CGFloat)size
{
    NSData *stringData = [string dataUsingEncoding:NSUTF8StringEncoding];
    CIFilter *qrFilter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    [qrFilter setValue:stringData forKey:@"inputMessage"];
    [qrFilter setValue:@"M" forKey:@"inputCorrectionLevel"];
    CIImage *image = qrFilter.outputImage;
    CGRect extent = CGRectIntegral(image.extent);
    CGFloat scale = MIN(size/CGRectGetWidth(extent), size/CGRectGetHeight(extent));
    
    size_t width = CGRectGetWidth(extent) * scale;
    size_t height = CGRectGetHeight(extent) * scale;
    CGColorSpaceRef cs = CGColorSpaceCreateDeviceGray();
    CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, cs, (CGBitmapInfo)kCGImageAlphaNone);
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef bitmapImage = [context createCGImage:image fromRect:extent];
    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
    CGContextScaleCTM(bitmapRef, scale, scale);
    CGContextDrawImage(bitmapRef, extent, bitmapImage);
    
    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
    CGContextRelease(bitmapRef);
    CGImageRelease(bitmapImage);
    return [UIImage imageWithCGImage:scaledImage];
}


//判断是否银行卡
+ (BOOL) checkCardNumber:(NSString*) cardNumber{
   
    int oddsum = 0;    //奇数求和
    int evensum = 0;    //偶数求和
    int allsum = 0;
    int cardNoLength = (int)[cardNumber length];
    int lastNum = [[cardNumber substringFromIndex:cardNoLength-1] intValue];
    
    cardNumber = [cardNumber substringToIndex:cardNoLength -1];
    for (int i = cardNoLength -1 ; i>=1;i--) {
        NSString *tmpString = [cardNumber substringWithRange:NSMakeRange(i-1,1)];
        int tmpVal = [tmpString intValue];
        if (cardNoLength % 2 ==1 ) {
            if((i % 2) == 0){
                tmpVal *= 2;
                if(tmpVal>=10)
                    tmpVal -= 9;
                evensum += tmpVal;
            }else{
                oddsum += tmpVal;
            }
        }else{
            if((i % 2) == 1){
                tmpVal *= 2;
                if(tmpVal>=10)
                    tmpVal -= 9;
                evensum += tmpVal;
            }else{
                oddsum += tmpVal;
            }
        }
    }
    
    allsum = oddsum + evensum;
    allsum += lastNum;
    if((allsum % 10) ==0)
        return YES;
    else
        return NO;
}

+(NSString *)changeString:(NSString *)nstring withStartLocation:(NSInteger)startLoaction startNumber:(NSInteger)startNumber{
    if (!nstring) {
        return nil;
    }else{
        NSString *startStr = [nstring substringToIndex:startLoaction];
        NSString * endStr = [nstring substringFromIndex:nstring.length - startNumber];
        NSString * endString = [NSString stringWithFormat:@"%@ **** %@", startStr, endStr];
        return endString;
    }
 
}

+ (BOOL) canUseCamera
{
    AVAuthorizationStatus authStatus =  [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (authStatus == AVAuthorizationStatusRestricted || authStatus ==AVAuthorizationStatusDenied)
    {
        //无权限
        return NO;
    }
    else
    {
        return YES;
    }
}

+ (UIBarButtonItem *)backButtonItem:(UIViewController *)delegate
{
    
    UIImage *image = [UIImage imageNamed:@"x_global_nav_backButtonBG"];
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 32, 19)];
    [backButton setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 10)];
    [backButton setImage:image forState:UIControlStateNormal];
    
    if([delegate respondsToSelector:@selector(backAction)])
        [backButton addTarget:delegate action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *temporaryBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    temporaryBarButtonItem.style = UIBarButtonItemStylePlain;
    return temporaryBarButtonItem;
}
-(void)backAction
{
    
}

+ (UIBarButtonItem *)barButtonItemTitle:(NSString *)itemTitle controller:(UIViewController *)delegate clickAction:(SEL)action
{
    UIButton *itemButton = [UIButton buttonWithType:UIButtonTypeCustom];
    itemButton.frame = CGRectMake(0, 0, 80, 50);
    if ([delegate respondsToSelector:action])
    {
        [itemButton addTarget:delegate action:action forControlEvents:UIControlEventTouchUpInside];
    }
    [itemButton setTitle:itemTitle forState:UIControlStateNormal];
    [itemButton.titleLabel sizeToFit];
//    [itemButton setTitleColor:lColorFromHEX(0x222222, 1) forState:UIControlStateNormal];
    itemButton.titleLabel.font = [UIFont systemFontOfSize:14];
    itemButton.contentEdgeInsets = UIEdgeInsetsMake(5, 10, 0, 0);
    UIBarButtonItem *barItem = [[UIBarButtonItem alloc] initWithCustomView:itemButton];
    return barItem;
    
}

+ (BOOL)isValueStringNull:(NSString *)valueString{
    if (valueString ==nil || valueString ==NULL) {
        return YES;
    }else if ([valueString isKindOfClass:[NSNull class]]) {
        return YES;
    }else if ([[valueString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]length]==0) {
        return YES;
    }else{
        return NO;
    }
}

+ (NSString *) encodingURLWithUTF8Extend:(NSString *)extendString
{
    NSString *tempString = [NSMutableString stringWithString:extendString];
    
    NSRange range = [extendString rangeOfString:@"html"];
    if (range.length == 0)
    {
        return extendString;
    }
    NSString *string = [extendString substringToIndex:range.location];
    tempString = [tempString stringByReplacingOccurrencesOfString:string withString:@""];
//    iOS9
    NSString *baseString = [string stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *baseString1 = (__bridge NSString *) CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                                                (CFStringRef)tempString,
                                                                                NULL,
                                                                                CFSTR("/#[]@!$’()*+,;{}"),
                                                                                kCFStringEncodingUTF8);
    return [NSString stringWithFormat:@"%@%@", baseString, baseString1];
}
+(NSAttributedString *)setButtonFont:(int ) font  textColor:(int  )colorHEX   lineColor:(int )lineColorHEX  text:(NSString *)textStr
{
    NSString*attrText = textStr;
    
    NSMutableDictionary*attr = [NSMutableDictionary dictionary];
    //设置富文本的字体
    
    attr[NSFontAttributeName] = [UIFont systemFontOfSize:font];
    
    //设置富文本字体颜色
    
//    attr[NSForegroundColorAttributeName] =lColorFromHEX(colorHEX, 1);
    
    //设置下划线
    
    attr[NSUnderlineStyleAttributeName] = [NSNumber numberWithInteger:NSUnderlineStyleSingle];
    
    //设置下划线颜色
    
//    attr[NSUnderlineColorAttributeName] =lColorFromHEX(colorHEX, 1);;
    NSAttributedString *attributedStr = [[NSAttributedString alloc] initWithString:attrText attributes:attr];
    return attributedStr;
}

+ (BOOL) isBlankString:(NSString *)string {
    
    if (string ==nil || string ==NULL) {
        
        return YES;
        
    }
    
    if ([string isKindOfClass:[NSNull class]]) {
        
        return YES;
        
    }
    
//    if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]length]==0) {//特殊字符判断
//        return YES;
//    }
    
    return NO;
    
}


@end
