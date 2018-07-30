//
//  IWCRClassRoom.h
//  WeClassRoomSDK
//
//  Created by 熊泽法 on 16/7/19.
//  Copyright © 2016年 WeClassRoom. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "WCRUIConfig.h"

/*****************课件语音评测功能*****************/
//语音评测目前仅限WCRLessonTypeInteractiveBroadcastLesson课程使用，需要特定课件支持
//语音评测的参数
@interface WCRSpeakEvaluateParams : NSObject
@property(nonatomic, copy) NSString* docID;         //文档ID
@property(nonatomic, copy) NSString* language;      //评测语言：cn、en
@property(nonatomic, copy) NSString* type;          //类型：read_word、read_sentence
@property(nonatomic, copy) NSDictionary* data;      //内容：I have a dream
@property(nonatomic, assign) NSUInteger timeout;    //超时时间（s）
@property(nonatomic, copy) NSString* testID;        //测评对应的题目ID
@end

//语音评测的结果回调
@protocol WCRSpeakEvaluateCallback <NSObject>
@required
- (void)onVolumeChanged:(int)volume;                //音量变化
- (void)onBeginOfSpeak;                             //用户开始跟读
- (void)onEndOfSpeak;                               //用户结束跟读
- (void)onCancelled;                                //用户取消跟读
- (void)onErrorWithCode:(int)errorCode Description:(NSString*)desc; //出错错误码及错误描述
- (void)onResults:(NSDictionary *)results;          //语音评测结果
@end
/***********************************************/

/*****************退出教室的状态码*****************/
typedef NS_ENUM(NSInteger,WCRLeaveRoomReason){
    WCRLeaveRoomReasonNomarl = 0, //点击退出课堂按钮
    WCRLeaveRoomReasonAfterClass, //老师下课自动退出课堂
    WCRLeaveRoomReasonForceLeave, //异地登录被强制踢出课堂
    WCRLeaveRoomReasonForceReset, //强制重启
    WCRLeaveRoomReasonExternal //SDK外调用退出教室的接口
};
/***********************************************/

/*****************学生说话时长的回调状态************/
//说话时长目前仅限WCRLessonTypeOneToOne&WCRLessonTypeGroupLesson课程使用
typedef NS_ENUM(NSInteger,WCRReportSpeechTimeStatus){
    WCRReportSpeechTimeStatusStart = 0,             //开始上报
    WCRReportSpeechTimeStatusReporting,             //正常上报中
    WCRReportSpeechTimeStatusEnd                    //结束上报
};
/***********************************************/

/*****************教室对象回调Delegate************/
@protocol WCRClassRoomDelegate <NSObject>
@required
- (void)roomDidJoin:(BOOL)successed;                //成功进入教室
- (void)roomWillLeave:(WCRLeaveRoomReason)statusCode;//即将退出教室
@optional
//课件语音评测功能,未使用可以不实现
- (BOOL)startEvaluate:(WCRSpeakEvaluateParams*)params
         withCallback:(id<WCRSpeakEvaluateCallback>)callback;   //开始评测
- (void)stopEvaluate;                               //结束评测

//课件答题功能,通知在课件中答题的详情，未使用可不实现
- (void)reportCoursewareAnswer:(NSString*)details;

//发言时长统计，未使用可不实现
- (void)reportSpeechTimeWithClassId:(NSString *)classId
                 speechTimeInterval:(NSUInteger)speechTimeInterval
                             status:(WCRReportSpeechTimeStatus)status
                          compelete:(void(^)(BOOL success))complete; //通知本堂课累计总时长
- (void)fetchSpeechTimeIntervalWithClassId:(NSString *)classId
                                  complete:(void(^)(BOOL success, NSUInteger timeInterval))complete; //获取本堂课已经累计的发言时长
- (void)classroomHelpInfo:(NSDictionary *)helpInfo;
@end
/***********************************************/

//使用的SDK类型，不清楚的话可以忽略，由内部决定
typedef NS_ENUM(NSUInteger, WCRVideoSDKType) {
    WCRVideoSDKTypeNone = 0,
    WCRVideoSDKTypeZego,
    WCRVideoSDKTypeAgora,
    WCRVideoSDKTypeTm,
    WCRVideoSDKTypeTMRTC,
    WCRVideoSDKTypeMax,
};

//当前课的课程状态
typedef NS_ENUM(NSUInteger, WCRClassState) {
    WCRClassStateNone = 0,
    WCRClassStateAfterClass,    //课后
    WCRClassStateBeforeClass,   //课前
    WCRClassStateInClass,       //课中
    WCRClassStateMax,
};

//课程类型
typedef NS_ENUM(NSUInteger, WCRLessonType) {
    WCRLessonTypeNone = 0,
    WCRLessonTypeInteractiveBroadcastLesson, //千课外教直播课IBL
    WCRLessonTypeGroupLesson,                //小组课
    WCRLessonTypeOneToOne,                   //一对一
    WCRLessonTypeSmallClass,                  //小班课
    WCRLessonTypeLargeClass,                 //普通大班课
    WCRLessonTypeInteractiveLargeClass,      //互动大班课，密码(登录之后通过token认证）
    WCRLessonTypeInteractiveLargeClassByCode, //互动大班课，口令（不登录只有口令）
    WCRLessonTypeMax,
    WCRLessonTypeDefault = WCRLessonTypeInteractiveBroadcastLesson
};

/**运行环境*/
typedef NS_ENUM(NSInteger, WCREnvironment) {
    WCREnvironmentDevelop = 0,
    WCREnvironmentTest = 1,
    WCREnvironmentPreOnline = 2,
    WCREnvironmentOnline = 3
};

/** 
   一种新的类型，学生的基本信息
 */
@interface WCRStudent : NSObject

// 姓名
@property(nonatomic, copy) NSString *userName;

//奖励数
@property(nonatomic,assign) NSInteger awardCount;

// 用户ID
@property(nonatomic, copy) NSString *userID;

// 头像
@property(nonatomic, copy) NSString *avatar;

// 排名
@property(nonatomic, assign) NSInteger ranking;

@end


@interface WCRClassJoinInfo : NSObject
/// \brief 产品名称
@property(nonatomic, copy) NSString* productName;
/// \brief 教室里所上的课的课程类型
@property(nonatomic, assign) WCRLessonType lessonType;

/// \brief 进入教室的用户昵称
@property(nonatomic, copy) NSString* userName;

/// \brief 进入教室的用户唯一ID
@property(nonatomic, copy) NSString* userID;
/// \brief 进入教室的用户手机号
@property(nonatomic, copy) NSString* mobileNumber;

/// \brief 进入教室的用户的登录认证Token
@property(nonatomic, copy) NSString* userToken;

/// \brief 进入教室的用户的登录头像(url)
@property(nonatomic, copy) NSString* userAvatar;

/// \brief 教室所在的老师ID
@property(nonatomic, copy) NSString* teacherID;

/// \brief 教室所在的老师Name
@property(nonatomic, copy) NSString* teacherName;

/// \brief 教室所在的老师头像
@property(nonatomic, copy) NSString* teacherAvatar;

/// \brief 要进入的教室唯一ID
@property(nonatomic, copy) NSString* classID;

/// \brief 进入教室的课程名称
@property(nonatomic, copy) NSString* classTitle;

/// \brief 课程状态
@property(nonatomic, assign) WCRClassState classState;

/// \brief 教室所属的机构ID(直播云机构后台提供)
@property(nonatomic, copy) NSString* institutionID;

/// \brief 课程的时长，单位是秒
@property(nonatomic, assign) NSTimeInterval classLastTime;

/// \brief 教室在课堂开始前文档区域默认展现的文档地址
@property(nonatomic, copy) NSString* defaultDocOnClassWaiting;

/// \brief 教室在课堂结束后文档区域默认展现的文档地址
@property(nonatomic, copy) NSString* defaultDocOnClassEnded;

/// \brief 直播视频是否开启硬件加速,此选项最好可以通过配置下发进行控制，避免因视频格式不匹配导致无法播放（极端情况）
@property(nonatomic, assign) BOOL enableGPUAccelerated;

/// \brief 课程的预计开始时间
@property(nonatomic, copy) NSDate* schedualStartTime;

/// \brief 课程的预计结束时间
@property(nonatomic, copy) NSDate* schedualEndTime;

/// \brief 课程的实际开始时间
@property(nonatomic, copy) NSDate* actualStartTime;

/// \brief 课程的实际结束时间
@property(nonatomic, copy) NSDate* actualEndTime;

/// \brief 使用的视频SDK类型
@property(nonatomic, assign) WCRVideoSDKType videoSDKType;

/// \brief 口令大班课的用户口令
@property(nonatomic, copy) NSString * userCode;

/// \brief 仅直播云客户端使用的配置文件：用户配置
@property(nonatomic, strong) NSDictionary* userUrlInfo;

/// \brief 仅直播云客户端使用的配置文件：课程配置
@property(nonatomic, strong) NSDictionary* classUrlInfo;

/// \brief 1v1&1v6教室页皮肤配置:
@property(nonatomic,strong) WCRUIConfig *skinConfig;

/// \brief 1v1&1v6教室班级的学生id列表，元素为 WCRStudents
@property(nonatomic,copy)   NSArray *students;

/// \brief 是否采用动作回放模式
@property(nonatomic, assign, getter=isActionReplayMode) BOOL actionReplayMode;

/// \brief 设置环境
@property(nonatomic, assign) WCREnvironment env;

@end

@interface WCRClassRoom : NSObject
@property(nonatomic, weak) id<WCRClassRoomDelegate> delegate;   //教室delegate
- (void)joinRoom:(WCRClassJoinInfo*) info;                      //进入教室的基本信息
/**
 *  如需外部代码控制离开教室，需先调用这个接口，界面消失和正常退出一样在roomWillLeave:的回调里进行
 */
- (void)leaveRoom;
- (UIViewController*)roomViewController;                        //教室页的viewController，在roomDidJoin成功之后Present
+ (void)setSkinConfig:(WCRUIConfig *)config;                    //1v1&1v6教室皮肤配置
+ (NSString *)version;

@end
