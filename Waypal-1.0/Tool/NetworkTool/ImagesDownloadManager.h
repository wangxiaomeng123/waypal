//
//  ImagesDownloadManager.h
//  Waypal-1.0
//
//  Created by waypal on 2018/7/4.
//  Copyright © 2018年 waypal. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ImageModel.h"
@interface ImagesDownloadManager : NSObject
+ (void)downloadImages:(NSArray<ImageModel *> *)imgsArray completion:(void(^)(NSArray *resultArray))completionBlock;
@end
