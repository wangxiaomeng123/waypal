



//
//  LessonViewModel.m
//  iPad_wayPal
//
//  Created by waypal on 2018/5/16.
//  Copyright © 2018年 waypal. All rights reserved.
//

#import "LessonViewModel.h"
#import "NetworkingTool.h"
#import "Config.h"
#import "LessonInfoModel.h"
#import "liveRoomModel.h"
@implementation LessonViewModel
-(void)getLessonSchedulesListWithFromTime:(NSString *)from_time
{
    NSDictionary *requestParam =@{@"from_time":from_time};
    [NetworkingTool getWithUrl:SCHEDULESOPERATION params:requestParam isReadCache:YES success:^(NSURLSessionDataTask *task, id responseObject) {
        [self getSchedulesListWithRespData:responseObject];
    } failed:^(NSURLSessionDataTask *task, NSError *error, id responseObject) {
        self.failureBlock();
    } ];
}
-(void)getSchedulesListWithRespData:(NSDictionary *)respData
{
    NSInteger successCode = [respData[@"code"] integerValue];
    NSMutableArray * lessonInfoArr=[NSMutableArray array];
    if (successCode == REQUESTSUCCESS) {
        if ([respData[@"output"] isKindOfClass:[NSArray class]])
        {
            NSArray * lessonListArr=respData[@"output"];
            for(NSDictionary * lesssonInfoDict in lessonListArr)
            {
                LessonInfoModel * lessonInfo=[[LessonInfoModel alloc] init];
                [lessonInfo setValuesForKeysWithDictionary:lesssonInfoDict];
                [lessonInfoArr addObject:lessonInfo];
            }
        }
        self.returnBlock(lessonInfoArr);
    }
    else
    {
        self.errorBlock(@"暂无其它数据");
    }
   
}

-(void)checkJoinLiveRoomWithSchedule_id:(NSString *)schedule_id
{
    NSDictionary * joinLiveRoomParam=@{@"schedule_id":schedule_id};
    [NetworkingTool postWithUrl:JOINLIVEROOMOPERATION params:joinLiveRoomParam isReadCache:YES success:^(NSURLSessionDataTask *task, id responseObject) {
        DDLog(@"joinliveRoom：%@",responseObject);
        [self checkJoinLiveRoomWithDataDict:responseObject];
       
        
    } failed:^(NSURLSessionDataTask *task, NSError *error, id responseObject) {
        self.failureBlock();
        
    }];
}

-(void)checkJoinLiveRoomWithDataDict:(NSDictionary *)respData
{
    if ([respData[@"code"] intValue]==REQUESTSUCCESS){
       NSDictionary * returnDict=respData[@"output"];
        liveRoomModel *liveroomModel=[[liveRoomModel alloc] init];
        [liveroomModel setValuesForKeysWithDictionary:returnDict];
        self.returnBlock(liveroomModel);
    }
    else
    {
        self.errorBlock(respData[@"tip"]);
    }
    
}

/**
 进入直播间的成功后的回调
 */
-(void)enterLivewroomSuccessCallBackWithSchedule_id:(NSString *)schedule_id{
    [NetworkingTool postWithUrl:EnterCALLBACKOPERATION params:@{@"schedule_id":schedule_id} isReadCache:NO success:^(NSURLSessionDataTask *task, id responseObject) {
        
    } failed:^(NSURLSessionDataTask *task, NSError *error, id responseObject) {
        self.failureBlock();
    }];
}

/**
 退出直播间的回调
 */
-(void)quitLivewroomSuccessCallBackWithSchedule_id:(NSString *)schedule_id{
    [NetworkingTool postWithUrl:QuitCALLBACKOPERATION params:@{@"schedule_id":schedule_id}  isReadCache:NO success:^(NSURLSessionDataTask *task, id responseObject) {
        
        
        
        
    } failed:^(NSURLSessionDataTask *task, NSError *error, id responseObject) {
        self.failureBlock();
        
    }];
    
}

-(void)enterTempClassRoomWithRoomPassword:(NSString *)password
{
    [NetworkingTool postWithUrl:EnterTempClassOPERATION params:nil isReadCache:NO success:^(NSURLSessionDataTask *task, id responseObject) {
        if ([responseObject[@"code"] integerValue]==REQUESTSUCCESS)
        {
            NSDictionary * outPut=responseObject[@"output"];
           self.returnBlock(outPut);
            
        }else{
            self.errorBlock(responseObject[@"tip"]);
            
        }
        
    } failed:^(NSURLSessionDataTask *task, NSError *error, id responseObject) {
        self.failureBlock();
        
    }];
}

-(void)scheduleHelpsWithSchedule_id:(NSString *)schedule_id errorCode:(NSString *)error_code errorMsg:(NSString *)error_msg{
    
    NSDictionary * paramDict=@{@"schedule_id":schedule_id,
                               @"error_code":error_code,
                               @"type":@"1",
                               @"error_msg":error_msg
                               };
    [NetworkingTool postWithUrl:SCHUDULEHELP params:paramDict isReadCache:NO success:^(NSURLSessionDataTask *task, id responseObject) {
        if ([responseObject[@"code"] intValue]==REQUESTSUCCESS)
        {
            self.returnBlock(responseObject);
        }
        else
        {
            NSString *errorTip= responseObject[@"tip"];
            self.errorBlock(errorTip);
        }
    } failed:^(NSURLSessionDataTask *task, NSError *error, id responseObject) {
          self.failureBlock();
    }];
    
}





@end
