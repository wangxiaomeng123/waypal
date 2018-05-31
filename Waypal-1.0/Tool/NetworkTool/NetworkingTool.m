//
//  JZLNetworkingTool.m
//  JZLNetworking
//
//  Created by allenjzl on 2016/12/13.
//  Copyright © 2016年 allenjzl. All rights reserved.
//

#import "NetworkingTool.h"
#import "Config.h"
#import <AFNetworking/AFNetworkReachabilityManager.h>
#import "LoadingView.h"
@implementation NetworkingTool

#pragma 监测网络的可链接性
+ (void) netWorkReachability
{
    [[AFNetworkReachabilityManager sharedManager ] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch (status){
            case -1:
                NSLog(@"未知网络");
                break;
            case 0:
                NSLog(@"网络不可达");
                break;
            case 1:
                NSLog(@"GPRS网络");
                break;
            case 2:
                NSLog(@"wifi网络");
                break;
            default:
                break;
        }
        if(status ==AFNetworkReachabilityStatusReachableViaWWAN || status == AFNetworkReachabilityStatusReachableViaWiFi)
        {
            DDLog(@"有网");
        }else
        {
            DDLog(@"无网络");
        [[LAlertViewCustom sharedInstance] alertViewTitle:nil content:@"请检测网络连接" leftButtonTitle:nil rightButtonTitle:nil autoDismiss:YES rightButtonTapDoing:nil leftButtonTapORDismissDoing:nil];
        }
    }];
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    
}





//单例
+ (instancetype)sharedManager {
    static dispatch_once_t onceToken;
    static NetworkingTool *instance;
    dispatch_once(&onceToken, ^{
        NSURL *baseUrl = [NSURL URLWithString:@""];
        instance = [[NetworkingTool alloc] initWithBaseURL:baseUrl];
        instance.responseSerializer.acceptableContentTypes = [NSSet setWithArray:@[@"application/json",
                                                                                   @"text/html",
                                                                                   @"text/json",
                                                                                   @"text/plain",
                                                                                   @"text/javascript",
                                                                                   @"text/xml",
                                                                                   @"image/*"]];
    });
    return instance;
}


//get请求
+ (void)getWithUrl: (NSString *)url params: (NSDictionary *)params isReadCache: (BOOL)isReadCache success: (responseSuccess)success failed: (responseFailed)failed  {
    
    LoadingView *loadView= [[LoadingView alloc] init];
    [[[UIApplication sharedApplication] keyWindow] addSubview:loadView];
    DDLog(@"TIMEZONEOFFSET:%ld",TIMEZONEOFFSET);

    NSString * head_token =[lUSER_DEFAULT objectForKey:ACCESSTOKEN];
    NSString * token=[NSString stringWithFormat:@"Bearer %@",head_token];
    if (head_token.length>0) {
        [[NetworkingTool sharedManager].requestSerializer setValue:token forHTTPHeaderField:@"Authorization"];
    }
      NSString * requestURL =[NSString stringWithFormat:@"%@%@?offset=%ld",REQUESTPUBLICURL,url,TIMEZONEOFFSET];
    DDLog(@"requestURL:%@",requestURL);
    [[NetworkingTool sharedManager] GET:requestURL parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        DDLog(@"responseObject:%@",responseObject );
        [loadView hiddenLoadingView];
        if (success) {
            success(task,responseObject);
        }
       [RapidStorageClass saveDictionaryDataArchiver:responseObject key:requestURL];

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
         [loadView hiddenLoadingView];
        id cacheData= nil;
        if (isReadCache) {
            cacheData = [RapidStorageClass readDictionaryDataArchiverWithKey:requestURL];
        }else {
            cacheData = nil;
        }

        if (failed) {
            failed(task,error,cacheData);
        }
       
    }];
}
//post请求
+ (void)postWithUrl:(NSString *)url params:(NSDictionary *)params isReadCache: (BOOL)isReadCache success:(responseSuccess)success failed:(responseFailed)failed {
    LoadingView *loadView= [[LoadingView alloc] init];
    [[[UIApplication sharedApplication] keyWindow] addSubview:loadView];
    NSString * head_token =[lUSER_DEFAULT objectForKey:ACCESSTOKEN];
    NSString * token=[NSString stringWithFormat:@"Bearer %@",head_token];
    if (head_token.length>0) {
        [[NetworkingTool sharedManager].requestSerializer setValue:token forHTTPHeaderField:@"Authorization"];
    }
    NSMutableDictionary *mutableDict =[[NSMutableDictionary alloc] initWithDictionary:params];
    [mutableDict setObject:[NSNumber numberWithInteger:TIMEZONEOFFSET] forKey:@"offset"];
    NSString * requestURL =[NSString stringWithFormat:@"%@%@",REQUESTPUBLICURL,url];
    [[NetworkingTool sharedManager] POST:requestURL parameters:mutableDict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [loadView hiddenLoadingView];
        if (success) {
            success(task,responseObject);
        }
        DDLog(@"请求数据:[%@]-[%@",url,responseObject);
        
       [RapidStorageClass saveDictionaryDataArchiver:responseObject key:requestURL];
        //请求成功,保存数据
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
         [loadView hiddenLoadingView];
      
        id cacheData= nil;
        //是否读取缓存
        if (isReadCache) {
            [RapidStorageClass readDictionaryDataArchiverWithKey:requestURL];
        }else {
            cacheData = nil;
        }

        if (failed) {
            failed(task,error,cacheData);
        }
    }];
    
}








    

@end
