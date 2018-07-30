//
//  UpLoadHeadManager.h
//  xiaojingyu
//
//  Created by Charlie.W on 2017/10/21.
//  Copyright © 2017年 kekejl. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

//处理事件成功--返回数据
typedef void(^CSuccessBlock)(UIImage * obj,NSString * imagePath);

@interface UpLoadHeadManager : NSObject

+ (UpLoadHeadManager *)sharedInstance;

- (void)clUploadHeadImageWithMethed:(NSUInteger)method withBlock:(void(^)(UIImage * obj,NSString * imagePath))successBlock;

@property (nonatomic,copy)CSuccessBlock successBlock;



@end
