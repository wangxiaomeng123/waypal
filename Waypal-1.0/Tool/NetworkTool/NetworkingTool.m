//
//  JZLNetworkingTool.m
//  JZLNetworking
//
//  Created by allenjzl on 2016/12/13.
//  Copyright © 2016年 allenjzl. All rights reserved.
//

#import "NetworkingTool.h"
#import <AFNetworking/AFNetworkReachabilityManager.h>
#import "LoadingView.h"
#import "LLTClearCustomViewController.h"
#import "AppVersionViewModel.h"
@interface NetworkingTool()
@property (strong, nonatomic) OSSClient *client;
@end




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
    
    LoadingView *loadView= [[LoadingView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    [[[UIApplication sharedApplication] keyWindow] addSubview:loadView];
    
    NSString * head_token =[RapidStorageClass readToken];
    
    NSString * token=[NSString stringWithFormat:@"Bearer %@",head_token];
    if (head_token.length>0) {
        [[NetworkingTool sharedManager].requestSerializer setValue:token forHTTPHeaderField:@"Authorization"];
    }
    
    NSString * requestURL =[NSString stringWithFormat:@"%@%@?offset=%ld",REQUESTPUBLICURL,url,TIMEZONEOFFSET];
    
    
    [[NetworkingTool sharedManager] GET:requestURL parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        DDLog(@"接口名称:[%@]-[%@]-[%@]",url,params,responseObject);
        [loadView hiddenLoadingView];
        if (success) {
            success(task,responseObject);
        }
        [RapidStorageClass saveDictionaryDataArchiver:responseObject key:requestURL];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [loadView hiddenLoadingView];
        NSHTTPURLResponse * responses = (NSHTTPURLResponse *)task.response;
        if ( responses.statusCode==401|| responses.statusCode==400||responses.statusCode==403)
        {
            [[NetworkingTool sharedManager]hanlderUpdateToken];

        }else{
            id cacheData= nil;
            if (isReadCache) {
                cacheData = [RapidStorageClass readDictionaryDataArchiverWithKey:url];
            }else {
                cacheData = nil;
            }
            
            if (failed) {
                failed(task,error,cacheData);
            }
        }
        
        
        
        
    }];
}
//post请求
+ (void)postWithUrl:(NSString *)url params:(NSDictionary *)params isReadCache: (BOOL)isReadCache success:(responseSuccess)success failed:(responseFailed)failed {
    
    LoadingView *loadView= [[LoadingView alloc] init];
    [[[UIApplication sharedApplication] keyWindow] addSubview:loadView];
    NSString * head_token =[RapidStorageClass readToken];
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
        DDLog(@"接口名称:[%@]-[%@]]",url,responseObject);
        [RapidStorageClass saveDictionaryDataArchiver:responseObject key:requestURL];
        //请求成功,保存数据
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [loadView hiddenLoadingView];
        DDLog(@"error:%ld-%@-%@",[error code],[error domain],[error userInfo]);
        NSHTTPURLResponse * responses = (NSHTTPURLResponse *)task.response;
        if ( responses.statusCode==401|| responses.statusCode==400||responses.statusCode==403)
        {
            [[NetworkingTool sharedManager]hanlderUpdateToken];
        }else{
            id cacheData= nil;
            if (isReadCache) {
                cacheData = [RapidStorageClass readDictionaryDataArchiverWithKey:url];
            }else {
                cacheData = nil;
            }
            
            if (failed) {
                failed(task,error,cacheData);
            }
            
        }
        
    }];
    
}


+ (void)uploadWithfileData: (NSData *)fileData name: (NSString *)name fileName: (NSString *)fileName mimeType: (NSString *)mimeType progress: (progress)progress success: (uploadSuccess)success failed: (uploadFail)failed {
    [OSSLog enableLog];//执行该方法，开启日志记录
    id<OSSCredentialProvider> credential = [[OSSPlainTextAKSKPairCredentialProvider alloc] initWithPlainTextAccessKey:OSS_ACCESS_ID
                                                                                                            secretKey:OSS_ACCESS_KEY];
    OSSClient * client = [[OSSClient alloc] initWithEndpoint:OSS_ENDPOITN credentialProvider:credential];
    OSSPutObjectRequest * put = [OSSPutObjectRequest new];
    // 必填字段
    put.bucketName = OSS_BUCKETNAME;
    put.objectKey = fileName;
    put.uploadingData =fileData; // 直接上传NSData
    // 可选字段，可不设置
    put.uploadProgress = ^(int64_t bytesSent, int64_t totalByteSent, int64_t totalBytesExpectedToSend) {
        DDLog(@"%lld, %lld, %lld", bytesSent, totalByteSent, totalBytesExpectedToSend);
    };
    OSSTask * putTask = [client  putObject:put];
    [putTask continueWithBlock:^id(OSSTask *task) {
        
        task = [client presignPublicURLWithBucketName:OSS_BUCKETNAME
                                        withObjectKey:fileName];
        if (!task.error) {
            NSLog(@"upload object success!");
            if (success) {
                success( fileName);
            }
            
        } else {
            DDLog(@"upload object failed, error: %@" , task.error);
            
        }
        return nil;
    }];
    
}


#pragma mark 更新token
-(void)hanlderUpdateToken{
    AppVersionViewModel *model=[[AppVersionViewModel alloc] init];
    [model updateToken];
}


@end
