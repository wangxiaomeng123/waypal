//
//  LessonViewModel.h
//  iPad_wayPal
//
//  Created by waypal on 2018/5/16.
//  Copyright © 2018年 waypal. All rights reserved.
//

#import "ViewModelClass.h"

@interface LessonViewModel : ViewModelClass

/**
 获取课程列表
 */
-(void)getLessonSchedulesListWithFromTime:(NSString *)from_time;

/**
 
 获取进入直播间的信息

 @param schedule_id 课件id
 */
-(void)checkJoinLiveRoomWithSchedule_id:(NSString *)schedule_id;

/**
 进入直播间的成功后的回调
 */
-(void)enterLivewroomSuccessCallBackWithSchedule_id:(NSString *)schedule_id;

/**
 退出直播间的回调
 */   
-(void)quitLivewroomSuccessCallBackWithSchedule_id:(NSString *)schedule_id;

/**
 进入临时课堂
 */
-(void)enterTempClassRoomWithRoomPassword:(NSString *)password;

/**
 课堂问题求助

 @param schedule_id 课件id
 @param error_code 错误码
 @param error_msg 错误信息
 */
-(void)scheduleHelpsWithSchedule_id:(NSString *)schedule_id errorCode:(NSString *)error_code errorMsg:(NSString *)error_msg;

/**
 获取导航分栏 courseid
 */
-(void)getGreatcourses;



/**
 提交泛读的答题信息

 @param bookId 课本id
 @param optionArr 答题内容
 */
-(void)submitGreatCoursesQuestionWithBookId:(NSString *)bookId  questionOptionArr:(NSArray *)optionArr;
//lesson_id=18&session_id=1


/**
 预习课件列表

 @param schedule_id <#schedule_id description#>
 */
-(void)classwaresWithScheduleID:(NSString *)schedule_id;



@end
