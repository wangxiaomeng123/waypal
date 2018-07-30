//
//  JZLNetworkingTool.h
//  JZLNetworking
//
//  Created by allenjzl on 2016/12/13.
//  Copyright © 2016年 allenjzl. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking/AFHTTPSessionManager.h>
#import "Config.h"
#import "uploadSingureModel.h"

/**
 *  是否开启https SSL 验证
 *
 *  @return YES为开启，NO为关闭
 */
#define openHttpsSSL YES
/**
 *  SSL 证书名称，仅支持cer格式。“app.bishe.com.cer”,则填“app.bishe.com”
 */
#define certificate @"t.api.waypal.com"

//请求成功的回调block
typedef void(^responseSuccess)(NSURLSessionDataTask *task, id  responseObject);

//请求失败的回调block
typedef void(^responseFailed)(NSURLSessionDataTask *task, NSError *error,id responseObject);


typedef void(^uploadSuccess)(NSString* fileName);
typedef void(^uploadFail)(NSString * errorCode);

//文件下载的成功回调block
typedef void(^downloadSuccess)(NSURLResponse *response, NSURL *filePath);

//文件下载的失败回调block
typedef void(^downloadFailed)( NSError *error);

//文件上传下载的进度block
typedef void (^progress)(NSProgress *progress);






@interface NetworkingTool : AFHTTPSessionManager<NSURLSessionDownloadDelegate>
@property(nonatomic,strong)NSString * NetStatuString;

/**
 管理者单例

 */
+ (instancetype)sharedManager;

+ (void) netWorkReachability;



/**
 get请求
 
 @param url 请求url
 @param params 参数
 @param isReadCache 是否读取缓存
 @param success 成功回调
 @param failed 失败回调
 */


+ (void)getWithUrl: (NSString *)url params: (NSDictionary *)params isReadCache: (BOOL)isReadCache success: (responseSuccess)success failed: (responseFailed)failed;

/**
 post请求

 @param url 请求url
 @param params 参数
  @param isReadCache 是否读取缓存
 @param success 成功回调
 @param failed 失败回调
 */
+ (void)postWithUrl:(NSString *)url params:(NSDictionary *)params isReadCache: (BOOL)isReadCache success:(responseSuccess)success failed:(responseFailed)failed ;


/**
 图片上传
 @param fileData 图片的二进制data
 @param name 名称
 @param fileName 文件名
 @param mimeType 文件类型
 @param progress 上传进度
 @param success 成功回调
 @param failed 失败回调
 */
+ (void)uploadWithfileData: (NSData *)fileData name: (NSString *)name fileName: (NSString *)fileName mimeType: (NSString *)mimeType progress: (progress)progress success: (uploadSuccess)success failed: (uploadFail)failed;
@end
