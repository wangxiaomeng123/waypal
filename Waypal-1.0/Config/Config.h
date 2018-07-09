//
//  Config.h
//  PC_Waypal
//
//   Created by waypal on 2018/5/15.
//  Copyright © 2018年 waypal. All rights reserved.
//



#ifndef MVVMTest_Config_h
#define MVVMTest_Config_h
//#import "SVProgressHUD.h"
#import "DateTool.h"
#import "RapidStorageClass.h"
#import <SDWebImage/SDWebImageDownloader.h>
#import "UIImageView+WebCache.h"
#import "LAlertViewCustom.h"
#import "UIView+Extension.h"
#import "LInspectionClass.h"
#import <MBProgressHUD/MBProgressHUD.h>
#import "NetworkingTool.h"
#import "IQKeyboardManager.h"
#import "UIColor+Extension.h"
#import "UIViewController+Reability.h"
#import "LoadingView.h"
#import "animationTool.h"
#import <WeClassRoomSDK/WeClassRoomSDK.h>
#import "MInspectClass.h"
#import "UIButton+countDown.h"
#import <AliyunOSSiOS/AliyunOSSiOS.h>
#import <JKViewAnimation/UIView+CustomAlertView.h>


//获取屏幕 宽度、高度、
#define lSCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define lSCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)

#define D_GrayColor3 [NSColor colorWithSRGBRed:237/255.0 green:237/255.0 blue:237/255.0 alpha:1]
#define WeakSelf(type)  __weak typeof(type) weak##type = type;
#define lUSER_DEFAULT [NSUserDefaults standardUserDefaults]

//设置 view 圆角和边框
#define lViewBorderRadius(View, Radius, Width, Color)\
\
[View.layer setCornerRadius:(Radius)];\
[View.layer setMasksToBounds:YES];\
[View.layer setBorderWidth:(Width)];\
[View.layer setBorderColor:[Color CGColor]]

#warning 上线记得修改
//产品状态
#if DEBUG
static const BOOL kFORPRODUCTION = NO;
#else
static const BOOL kFORPRODUCTION = YES;
#endif


#define DDLog( s, ... ) printf("class: <%p %s:(%d) > method: %s \n%s\n", self, [[[NSString stringWithUTF8String:__FILE__] lastPathComponent] UTF8String], __LINE__, __PRETTY_FUNCTION__, [[NSString stringWithFormat:(s), ##__VA_ARGS__] UTF8String] )
//GCD - 在Main线程上运行,mainQueueBlock传代码块，可用匿名block形式:^{}
#define lDISPATCH_MAIN_THREAD(mainQueueBlock) dispatch_async(dispatch_get_main_queue(), mainQueueBlock);

//获取storyboard
#define lStoryboard(sname,vcname) [[UIStoryboard storyboardWithName:(sname) bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:(vcname)]

//定义返回请求数据的block类型
typedef void (^ReturnValueBlock) (id returnValue);
typedef void (^ErrorCodeBlock) (id errorCode);
typedef void (^FailureBlock)(void);
typedef void (^NetWorkBlock)(BOOL netConnetState);



//配置

//提示框自动消失时间
static const double kAlertViewAutoDismissSecond = 3.0;
//时区差
#define TIMEZONEOFFSET  -([[NSTimeZone systemTimeZone]secondsFromGMT]/60)



//请求网络接口
#warning 测试的环境
//#define REQUESTPUBLICURL @"https://t.api.waypal.com/api/"
//#define    OSS_BUCKETNAME @"waypal-test"

#warning 正式的环境
#define REQUESTPUBLICURL @"https://api.waypal.com/api/"
#define  OSS_BUCKETNAME @"waypal"

//客户端初始化信息
#define CLIENTAPPSETTINGOPERATION @"client/init"

//登录
#define LOGINOPERATION @"login"
//课程列表
#define SCHEDULESOPERATION @"schedules"
//编辑用户资料
#define USERINFOOPERATION @"user"
//进入直播间
#define JOINLIVEROOMOPERATION @"liveroom/join"
//退出直播间
#define QUITLIVEROOMOPERATION @"quit/liveroom"
//云直播校验
#define CHECKOPERATION @"livecloud/check"
///成功进入直播间回调
#define EnterCALLBACKOPERATION @"liveroom/enter/callback"
//离开直播间的回调
#define QuitCALLBACKOPERATION  @"liveroom/quit/callback"
//进入临时课堂
#define EnterTempClassOPERATION @"temp/liveroom/join"
//课程帮助
#define SCHUDULEHELP @"schedulehelps"
//上传文件的
#define UPLOADSIGN  @"uploadsign/image"
//注册
#define REGISTEROPERATION @"register"
//发送验证码
#define VERIFICODEOPERATION @"smscode"
//泛读导航课程列表
#define GREATCOURSESOPERATION @"greatcourses"
//泛读列表
#define  GREATCOURSESLISTOPERATION @"greatcourses/index/"
//泛读详情
#define GREATCOURSESDETAILOPERATION @"greatcourses/show/"
 //泛读测验提交
#define GREATCOURSEQUESTIONRESULT @"booktest/result"



#warning 记得修改
#define GETBACKPSDOPERATION @"getbackPassword"




//请求的状态吗
#define REQUESTSUCCESS 200
//机构id
#define INSTITUTIONID @"293"


#define Key_LOGININFORMATION @"loginInfo"
#define key_FirsrtEnter @"FirsrtEnter"
#define Key_RemberUserAccount @"remberUserAccount"





//oss
#define OSS_ENDPOITN @"http://oss-cn-beijing.aliyuncs.com/"

//#define OSS_BUCKETNAME @"waypal-test"

#define OSS_ACCESS_ID @"LTAIVEC3rPRRES79"
#define OSS_ACCESS_KEY @"vm2gBV70XfY9To5GDGJ4zzfahrDafh"


#pragma mark 头像路径前缀
#define  imagePathPrefix  @""





#endif
