//
//  LiveRoom.h
//  Waypal-1.0
//
//  Created by waypal on 2018/5/22.
//  Copyright © 2018年 waypal. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LessonInfoModel.h"
#import "liveRoomModel.h"
#import "Config.h"
#import "WCRClassroomSkin.h"
#import "TempClassModel.h"

typedef void(^enterLiveRoomSuccessCallbackBlock)(void);
typedef void(^enterLiveRoomFailCallbackBlock)(void);

typedef void(^QuitLiveRoomCallbackBlock)(WCRLeaveRoomReason statusCode );

@interface LiveRoom : NSObject<WCRClassRoomDelegate>
@property(nonatomic,strong)UIViewController * currentViewController;
@property(nonatomic,strong) LessonInfoModel *selectInfoModel;
@property(nonatomic,strong) liveRoomModel *liveroomModel;
@property (nonatomic, strong) WCRClassRoom* classRoom;
//@property (nonatomic,strong) TempClassModel *tempModel;


@property (nonatomic,strong) enterLiveRoomSuccessCallbackBlock  enterCallbackBlock;
@property(nonatomic,strong)enterLiveRoomFailCallbackBlock enterFailCallbackBlck;
@property (nonatomic,strong)QuitLiveRoomCallbackBlock quitCallbackBlock;
//-(WCRClassJoinInfo *)configInfoWithSelectInfo:(LessonInfoModel *)
;
-(WCRClassJoinInfo *)configLiveRoomInfo;

-(WCRClassJoinInfo *)configTempLiveRoomInfoWithTempModel: (TempClassModel *)tempModel;

@end
