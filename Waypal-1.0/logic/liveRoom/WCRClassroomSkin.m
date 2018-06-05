//
//  HBCClassroomSkin.m
//  HBForeignTeacherClass
//
//  Created by sdzhu on 16/12/6.
//  Copyright © 2016年 Gang Chen. All rights reserved.
//

#import "WCRClassroomSkin.h"
@implementation WCRClassroomSkin
+ (instancetype)defaultConfig{
    UIImage *backgroundImage = [UIImage imageNamed:@"classroom_background"];
    UIImage *awardNumBackgroundImage = [UIImage imageNamed:@"classroom_awardNumBackground"];
    UIImage *helpButtonImage = [UIImage imageNamed:@"classroom_help"];
    UIColor *borderColor = [WCRClassroomSkin colorWithHex:0xffffff alpha:0.5];
    CGFloat borderWidth = 2.0;
    CGFloat cornerRadius = 10.0;
    WCRBackgroundContext *backgroundContext = [[WCRBackgroundContext alloc] initWithBackgroundImage:backgroundImage foregroundImage:nil borderColor:borderColor borderWidth:borderWidth cornerRadius:cornerRadius awardNumBackgroundImage:awardNumBackgroundImage helpButtonImage:helpButtonImage];
    
    UIImage *backBtnImageNormal = [UIImage imageNamed:@"classroom_back"];
    UIImage *backBtnImagePress = [UIImage imageNamed:@""];
    WCRBackButtonContext *backButtonContext = [[WCRBackButtonContext alloc] initWithImageNormal:backBtnImageNormal imagePress:backBtnImagePress];
    
    UIImage *personVideoOutClassImage = [UIImage imageNamed:@"playerView_video_placeholder"];
    UIImage *offCameraImage = [UIImage imageNamed:@"camera_off"];
    UIImage *voiceLoud = [UIImage imageNamed:@"btn_sound_high"];
    UIImage *voiceMiddle = [UIImage imageNamed:@"btn_sound_middle"];
    UIImage *voiceLow = [UIImage imageNamed:@"btn_sound_low"];
    UIImage *voiceMute = [UIImage imageNamed:@"btn_sound_none"];
    
    UIImage *wifiStrong = [UIImage imageNamed:@"btn_signal_high"];
    UIImage *wifiMiddle = [UIImage imageNamed:@"btn_signal_middle"];
    UIImage *wifiWeak = [UIImage imageNamed:@"btn_signal_low"];
    UIImage *userNameBackgroundImage = [UIImage imageNamed:@"classroom_nameBackground"];
    
    WCRPersonVideoContext *pvc = [[WCRPersonVideoContext alloc] initWithOutClassImage:personVideoOutClassImage offCameraImage:offCameraImage voiceLoud:voiceLoud voiceMiddle:voiceMiddle voiceLow:voiceLow voiceMute:voiceMute wifiStrong:wifiStrong wifiMiddle:wifiMiddle wifiWeak:wifiWeak awardImage:nil userNameBackgroundImage:userNameBackgroundImage];
    
    
    UIImage *authorizeImage = [UIImage imageNamed:@"classroom_authorize"];
    WCRDrawToolContext* drawToolContext = [[WCRDrawToolContext alloc] initWithAuthorizeImage:authorizeImage];
    drawToolContext.hidden = YES;
    drawToolContext.isSimple = NO;
    drawToolContext.isShowDocPermissionBtn = YES;
    
    WCRRankContext *rankContext = [[WCRRankContext alloc] init];
    rankContext.userNameHidden = NO;
    rankContext.selfTagHidden = NO;
    
    WCRClassroomSkin *config = [[WCRClassroomSkin alloc] initWithAwardArea:nil speakArea:nil backgroundContext:backgroundContext backButtonContext:backButtonContext personVideoContext:pvc drawToolContext:drawToolContext rankContext:rankContext];
    return config;
}
+ (UIColor *)colorWithHex:(long)hexColor alpha:(float)opacity
{
    float red = ((float)((hexColor & 0xFF0000) >> 16))/255.0;
    float green = ((float)((hexColor & 0xFF00) >> 8))/255.0;
    float blue = ((float)(hexColor & 0xFF))/255.0;
    return [UIColor colorWithRed:red green:green blue:blue alpha:opacity];
}
- (void)dealloc{
    NSLog(@"HBCClassroomSkin dealloc");
}

@end
