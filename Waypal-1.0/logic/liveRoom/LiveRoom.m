
//
//  LiveRoom.m
//  Waypal-1.0
//
//  Created by waypal on 2018/5/22.
//  Copyright © 2018年 waypal. All rights reserved.
//

#import "LiveRoom.h"



@implementation LiveRoom
-(WCRClassJoinInfo *)configLiveRoomInfo
{
    NSString * token =[lUSER_DEFAULT objectForKey:ACCESSTOKEN];
    NSDictionary *userInfoDict=[RapidStorageClass readDictionaryDataArchiverWithKey:@"userInfo"];
    NSDictionary *userInfo=userInfoDict[@"output"][@"user"];

    WCRClassJoinInfo *joinInfo = [[WCRClassJoinInfo alloc] init];
    joinInfo.productName = @"WayPal";
    joinInfo.userID =[NSString stringWithFormat:@"%@",self.selectInfoModel.student_id];
    joinInfo.userName =[NSString stringWithFormat:@"%@",self.selectInfoModel.student_name];
    joinInfo.mobileNumber = [NSString stringWithFormat:@"%@",self.selectInfoModel.student_mobile];
    joinInfo.userAvatar =[NSString stringWithFormat:@"%@",self.selectInfoModel.student_portrait];
    joinInfo.classID = [NSString stringWithFormat:@"%@",self.liveroomModel.room_id];
    joinInfo.teacherID =[NSString stringWithFormat:@"%@",self.selectInfoModel.teacher_id] ;
    joinInfo.teacherName = [NSString stringWithFormat:@"%@",self.selectInfoModel.teacher_name];
    joinInfo.teacherAvatar = [NSString stringWithFormat:@"%@",self.selectInfoModel.teacher_portrait];
    joinInfo.actionReplayMode =YES;
    joinInfo.classTitle = @"Waypal";
    joinInfo.userToken = [NSString stringWithFormat:@"%@",token];
    joinInfo.institutionID = [NSString  stringWithFormat:@"%@",self.liveroomModel.institutionId];
    NSString * defaultDocOnClassWaiting=  [NSString stringWithFormat:@"%@&total=%@",self.liveroomModel.lesson_slide_url,self.liveroomModel.slide_count];
    joinInfo.defaultDocOnClassWaiting =defaultDocOnClassWaiting;
    joinInfo.lessonType = WCRLessonTypeOneToOne;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat: @"yyyy-MM-dd HH:mm:ss"];
    joinInfo.schedualStartTime = [dateFormatter dateFromString:self.liveroomModel.startTime];
    joinInfo.schedualEndTime = [dateFormatter dateFromString:self.liveroomModel.endTime];
    //实际开始和结束时间
    joinInfo.actualStartTime=[dateFormatter dateFromString:self.liveroomModel.startTime];
    joinInfo.actualEndTime =  [dateFormatter dateFromString:self.liveroomModel.endTime];
    joinInfo.skinConfig = [WCRClassroomSkin defaultConfig];
    if (kFORPRODUCTION) {
        joinInfo.env =WCREnvironmentOnline;
    }else
    {
        joinInfo.env = WCREnvironmentTest;
    }
//    //状态: 0 已预约 1 即将开始 2 旷课 3 取消 4 正在上课 5 其它 6 已完成
    switch (self.selectInfoModel.status )
    {
        case 0://待上课
            joinInfo.classState =WCRClassStateBeforeClass;
            break;
        case 1://待上课
            joinInfo.classState =WCRClassStateBeforeClass;
            break;
        case 4://课中
            joinInfo.classState=WCRClassStateInClass;
            break;
        case 6://已经结束
            joinInfo.classState=WCRClassStateAfterClass;
            break;
        default:
            break;
    }

    WCRStudent * student = [[WCRStudent alloc]init];
    student.userName =[NSString stringWithFormat:@"%@",userInfo[@"nick"]];
    student.userID =[NSString stringWithFormat:@"%@",self.selectInfoModel.student_id];
    student.avatar =[NSString stringWithFormat:@"%@",self.selectInfoModel.student_portrait];
    joinInfo.students = @[student];
    
     return  joinInfo;
    
}




-(WCRClassJoinInfo *)configTempLiveRoomInfo{
    NSString * token =[lUSER_DEFAULT objectForKey:ACCESSTOKEN];
    NSDictionary *userInfoDict=[RapidStorageClass readDictionaryDataArchiverWithKey:@"userInfo"];
    NSDictionary *userInfo=userInfoDict[@"output"][@"user"];
    NSString *student_id =userInfo[@"id"];
    NSString *student_name =userInfo[@"name"];
    NSString *student_mobile=userInfo[@"mobile"];
    NSString * student_avatar=userInfo[@"avatar"];
    
    WCRClassJoinInfo *joinInfo = [[WCRClassJoinInfo alloc] init];
    joinInfo.productName = @"WayPal";
    
    joinInfo.userID =[NSString stringWithFormat:@"%@",student_id];
    joinInfo.userName =[NSString stringWithFormat:@"%@",student_name];
    joinInfo.mobileNumber = [NSString stringWithFormat:@"%@",student_mobile];
    joinInfo.userAvatar =[NSString stringWithFormat:@"%@",student_avatar];
    
    joinInfo.teacherID =[NSString stringWithFormat:@"%@",self.tempModel.teacher_id] ;
    joinInfo.teacherName = [NSString stringWithFormat:@"%@",self.tempModel.teacher_name];
    joinInfo.teacherAvatar = [NSString stringWithFormat:@"%@",self.tempModel.teacher_avatar];
    
    
    
    
    joinInfo.classID = [NSString stringWithFormat:@"%@",self.tempModel.schedule_id];
    joinInfo.actionReplayMode =YES;
    joinInfo.classTitle = @"Waypal";
    joinInfo.userToken = [NSString stringWithFormat:@"%@",token];
    joinInfo.institutionID = [NSString  stringWithFormat:@"%@",self.tempModel.institutionId];
    NSString * defaultDocOnClassWaiting=  [NSString stringWithFormat:@"%@&total=%@",self.tempModel.lesson_slide_url,self.liveroomModel.slide_count];
    
    joinInfo.defaultDocOnClassWaiting =defaultDocOnClassWaiting;
    joinInfo.lessonType = WCRLessonTypeOneToOne;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat: @"yyyy-MM-dd HH:mm:ss"];
    joinInfo.schedualStartTime = [dateFormatter dateFromString:self.tempModel.startTime];
    joinInfo.schedualEndTime = [dateFormatter dateFromString:self.tempModel.endTime];
    
    //实际开始和结束时间
    joinInfo.actualStartTime=[dateFormatter dateFromString:self.tempModel.startTime];
    joinInfo.actualEndTime =  [dateFormatter dateFromString:self.tempModel.endTime];
    joinInfo.skinConfig = [WCRClassroomSkin defaultConfig];
    if (kFORPRODUCTION) {
        joinInfo.env =WCREnvironmentOnline;
    }else
    {
        joinInfo.env = WCREnvironmentTest;
    }
    //    //状态: 0 已预约 1 即将开始 2 旷课 3 取消 4 正在上课 5 其它 6 已完成
    switch (self.selectInfoModel.status )
    {
        case 0://待上课
            joinInfo.classState =WCRClassStateBeforeClass;
            break;
        case 1://待上课
            joinInfo.classState =WCRClassStateBeforeClass;
            break;
        case 4://课中
            joinInfo.classState=WCRClassStateInClass;
            break;
        case 6://已经结束
            joinInfo.classState=WCRClassStateAfterClass;
            break;
        default:
            break;
    }
    
    WCRStudent * student = [[WCRStudent alloc]init];
    student.userName =[NSString stringWithFormat:@"%@",student_name];
    student.userID =[NSString stringWithFormat:@"%@",student_id];
    student.avatar =[NSString stringWithFormat:@"%@",student_avatar];
    joinInfo.students = @[student];
    
    return  joinInfo;
}



#pragma mark - WCRClassRoomDelegate
- (void)roomDidJoin:(BOOL)successed
{
    DDLog(@"进入成功");
    if (successed)
    {
    UIViewController* classRoomViewController = self.classRoom.roomViewController;
    [self.currentViewController presentViewController:classRoomViewController animated:YES completion: nil];
        if (self.enterCallbackBlock) {
            self.enterCallbackBlock();
        }
        
    }else
    {
        if (self.enterFailCallbackBlck) {
            self.enterFailCallbackBlck();
        }
        
    }
}
- (void)roomWillLeave:(WCRLeaveRoomReason)statusCode
{
    [self.currentViewController dismissViewControllerAnimated:YES completion:^{
        self.classRoom = nil;
    }];
    if (self.quitCallbackBlock) {
        self.quitCallbackBlock(statusCode);
    }
}






@end
