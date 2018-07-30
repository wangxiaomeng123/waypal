//
//  WCRUIConfig.h
//  WeClassRoomSDK
//
//  Created by sdzhu on 16/11/18.
//  Copyright © 2016年 WeClassRoom. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WCRBackgroundContext : NSObject
@property(nonatomic,strong)UIImage *foregroundImage;//前景图
@property(nonatomic,strong)UIImage *backgroundImage;//背景图
@property(nonatomic,strong)UIColor *borderColor;//背景边框颜色
@property(nonatomic,assign)CGFloat borderWidth;//背景边框宽度
@property(nonatomic,assign)CGFloat cornerRadius;//背景圆角
@property(nonatomic,strong)UIImage *awardNumBackgroundImage;//奖励数背景图
@property(nonatomic,strong)UIImage *helpButtonImage;//我要求助按钮图片

- (instancetype)initWithBackgroundImage:(UIImage *)backgroundImage foregroundImage:(UIImage *)foregroundImage borderColor:(UIColor *)borderColor borderWidth:(CGFloat)borderWidth cornerRadius:(CGFloat)cornerRadius awardNumBackgroundImage:(UIImage *)awardNumBackgroundImage helpButtonImage:(UIImage *)helpButtonImage;
@end

@interface WCRBackButtonContext : NSObject
@property(nonatomic,strong)UIImage *imageNormal;//返回按钮默认图片
@property(nonatomic,strong)UIImage *imagePress;//返回按钮高亮图片

- (instancetype)initWithImageNormal:(UIImage *)imageNormal imagePress:(UIImage *)imagePress;

@end

@interface WCRPersonVideoContext : NSObject
@property(nonatomic,strong)UIImage *outClassImage;//人物视频视窗未上课默认图
@property(nonatomic,strong)UIImage *offCameraImage;//人物视频视窗关闭摄像头默认图
@property(nonatomic,strong)UIImage *voiceLoud; //人物视频视窗声音图片 声音大
@property(nonatomic,strong)UIImage *voiceMiddle;//人物视频视窗声音图片 声音中
@property(nonatomic,strong)UIImage *voiceLow;//人物视频视窗声音图片 声音小
@property(nonatomic,strong)UIImage *voiceMute;//人物视频视窗声音图片 静音或无声

@property(nonatomic,strong)UIImage *wifiStrong; //人物视频视窗信号强弱图片 强
@property(nonatomic,strong)UIImage *wifiMiddle;//人物视频视窗信号强弱图片 中
@property(nonatomic,strong)UIImage *wifiWeak;//人物视频视窗信号强弱图片 弱
@property(nonatomic,strong)UIImage *award;//奖励

@property(nonatomic,strong)UIImage *userNameBackgroundImage;//用户名背景图
@property(nonatomic,assign)BOOL isReplaySeparate;//回放展示的方式

- (instancetype)initWithOutClassImage:(UIImage *)outClassImage
                       offCameraImage:(UIImage *)offCameraImage
                            voiceLoud:(UIImage *)voiceLoud
                          voiceMiddle:(UIImage *)voiceMiddle
                             voiceLow:(UIImage *)voiceLow
                            voiceMute:(UIImage *)voiceMute
                           wifiStrong:(UIImage *)wifiStrong
                           wifiMiddle:(UIImage *)wifiMiddle
                             wifiWeak:(UIImage *)wifiWeak
                           awardImage:(UIImage *)awardImage
              userNameBackgroundImage:(UIImage *)userNameBackgroundImage;

@end

@interface WCRAwardAreaContext : NSObject
@property(nonatomic,strong)UIImage *awardImage;//奖励星星图
@property(nonatomic,strong)UIColor *awardCountTextColor; //显示奖励数的文字颜色
@property(nonatomic,assign)NSInteger awardMax;
- (instancetype)initWithAwardImage:(UIImage *)awardImage textColor:(UIColor*)textColor;
@end

@interface WCRSpeakAreaContext : NSObject
@property(nonatomic,strong)UIImage *speakImage;//奖励星星图
@property(nonatomic,strong)UIColor *speakTimeTextColor; // 显示说话时长的文字颜色
@property(nonatomic,assign)BOOL hidden;
- (instancetype)initWithSpeakImage:(UIImage *)speakImage textColor:(UIColor*)textColor;
@end

@interface WCRDrawToolContext : NSObject
@property (nonatomic,assign) BOOL hidden;
@property (nonatomic,assign) BOOL isSimple; //是否是简洁版(不可自定义颜色、粗细)
@property (nonatomic,assign) BOOL isShowDocPermissionBtn; //是否显示文档授权按钮
@property(nonatomic,strong)UIImage *authorizeImage;//涂鸦授权图片
- (instancetype)initWithAuthorizeImage:(UIImage *)authorizeImage;

@end


/**
 排行榜配置
 */
@interface WCRRankContext : NSObject
@property (nonatomic, assign, getter=isUserNameHidden) BOOL userNameHidden;//!<是否用户名隐藏，default to YES
@property (nonatomic, assign, getter=isSelfTagHidden) BOOL selfTagHidden;//!<是否隐藏自己身份标签，default to YES
@end

@interface WCRUIConfig : NSObject
@property(nonatomic,strong)WCRBackgroundContext *backgroundContext;
@property(nonatomic,strong)WCRBackButtonContext *backButtonContext;
@property(nonatomic,strong)WCRPersonVideoContext *personVideoContext;
@property(nonatomic,strong)WCRAwardAreaContext *awardAreaContext;//奖励区
@property(nonatomic,strong)WCRSpeakAreaContext *speakAreaContext;//发言时长区
@property(nonatomic,strong)WCRDrawToolContext *drawToolContext;//是否展示涂鸦工具条
@property(nonatomic,strong)WCRRankContext *rankContext;//!<排行榜

- (instancetype)initWithAwardArea:(WCRAwardAreaContext *)awardAreaContext speakArea:(WCRSpeakAreaContext *)speakAreaContext backgroundContext:(WCRBackgroundContext *)backgroundContext backButtonContext:(WCRBackButtonContext *)backButtonContext personVideoContext:(WCRPersonVideoContext *)personVideoContext drawToolContext:(WCRDrawToolContext *)drawToolContext rankContext:(WCRRankContext *)rankContext;
@end
