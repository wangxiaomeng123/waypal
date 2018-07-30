//
//  ImagesDownloadManager.m
//  Waypal-1.0
//
//  Created by waypal on 2018/7/4.
//  Copyright © 2018年 waypal. All rights reserved.
//

#import "ImagesDownloadManager.h"
#import "SDWebImageDownloader.h"

@implementation ImagesDownloadManager
/**
 批量下载图片
 保持顺序;
 全部下载完成后才进行回调;
 回调结果中,下载正确和失败的状态保持与原先一致的顺序;
 
 @return resultArray 中包含两类对象:UIImage , NSError
 */
+ (void)downloadImages:(NSArray<ImageModel *> *)imgsArray completion:(void(^)(NSArray *resultArray))completionBlock {
    SDWebImageDownloader *manager = [SDWebImageDownloader sharedDownloader];
    manager.downloadTimeout = 20;
    __block NSMutableDictionary *resultDict = [NSMutableDictionary new];
    for(int i=0;i<imgsArray.count;i++) {
        
        NSString *imgUrl = [[imgsArray objectAtIndex:i]path ];
        [manager downloadImageWithURL:[NSURL URLWithString:imgUrl]
                              options:SDWebImageDownloaderUseNSURLCache|SDWebImageDownloaderScaleDownLargeImages
                             progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
                                 
                             } completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, BOOL finished) {
                                 if(finished){
                                     if(error){
                                         [resultDict setObject:error forKey:@(i)];
                                     }else{
                                         [resultDict setObject:image forKey:@(i)];
                                     }
                                     if(resultDict.count == imgsArray.count) {
                                         //全部下载完成
                                         NSArray *resultArray = [ImagesDownloadManager createDownloadResultArray:resultDict count:imgsArray.count];
                                         if(completionBlock){
                                             completionBlock(resultArray);
                                         }
                                     }
                                 }
                                 
                             }];
    }
}

+ (NSArray *)createDownloadResultArray:(NSDictionary *)dict count:(NSInteger)count {
    NSMutableArray *resultArray = [NSMutableArray new];
    for(int i=0;i<count;i++) {
        NSObject *obj = [dict objectForKey:@(i)];
        [resultArray addObject:obj];
    }
    return resultArray;
}

@end
