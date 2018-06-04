

//
//  AppVersionViewModel.m
//  Waypal-1.0
//
//  Created by waypal on 2018/5/25.
//  Copyright © 2018年 waypal. All rights reserved.
//

#import "AppVersionViewModel.h"

#import "AppVersionModel.h"
@implementation AppVersionViewModel


//client_id //客户端 1-学生端 2-老师端
//terminal_id //平台标示 1- IOS 2-Android 3-Web
//version_code //版本代号 100第一版本
//version_name //版本名称
//uuid //设备唯一标识
//device_name //设备名称
//device_os //设备系统
//network //网络
//channel //渠道

-(void)initAppSetting
{
    
    
    NSString *  device_name =[[UIDevice currentDevice] name];
    NSString *  device_os =[[UIDevice currentDevice] systemVersion];
    NSString * device_UUID =[[[UIDevice currentDevice]identifierForVendor] UUIDString];
    NSDictionary *infoDic=[[NSBundle mainBundle] infoDictionary];
    __block NSString *currentVersion=infoDic[@"CFBundleShortVersionString"];
    
    NSDictionary * appsettingParamDict =@{@"client_id":@"1",
                                          @"terminal_id":@"1",
                                          @"version_code":@"100",
                                          @"version_name":currentVersion,
                                          @"uuid":device_UUID,
                                          @"device_name":device_name,
                                          @"device_os":device_os,
                                          @"network":[self NetworkString],
                                          @"channel":@"AppStore"
                                          };
    [NetworkingTool postWithUrl:CLIENTAPPSETTINGOPERATION params:appsettingParamDict isReadCache:NO success:^(NSURLSessionDataTask *task, id responseObject) {
        DDLog(@"init:%@",responseObject);
        if ([responseObject[@"code"] integerValue]==REQUESTSUCCESS)
        {
            [[AppVersionModel shareInstance]handlerInitRespData:responseObject];
        }
        
    } failed:^(NSURLSessionDataTask *task, NSError *error, id responseObject) {
        //        self.failureBlock();
        
    }];
    
}

-(void)handlerResponseData:(NSDictionary *)respData
{
    int code= [respData[@"code"] intValue];
    if (code ==REQUESTSUCCESS) {
        self.returnBlock(respData);
    }
    else
    {
        self.errorBlock(respData[@"tip"]);
    }
}
-(NSString *)NetworkString{
    NSString * netWorkString;
    switch ([[AFNetworkReachabilityManager sharedManager] networkReachabilityStatus]){
        case -1:
            netWorkString=@"未知网络";
            break;
        case 0:
            NSLog(@"网络不可达");
            netWorkString=@"网络不可达";
            break;
        case 1:
            NSLog(@"GPRS网络");
            netWorkString=@"GPRS网络";
            break;
        case 2:
            netWorkString=@"wifi网络";
            break;
        default:
            break;
    }
    return  netWorkString;
}
@end
