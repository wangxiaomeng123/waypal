//
//  uploadSingureModel.h
//  Waypal-1.0
//
//  Created by waypal on 2018/6/11.
//  Copyright © 2018年 waypal. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface uploadSingureModel : NSObject
+(uploadSingureModel *)shareInstance;
@property (nonatomic,strong) NSString *accessId;
@property (nonatomic,strong) NSString *host;
@property (nonatomic,strong) NSString *host_cdn;
@property (nonatomic,strong) NSString * expire;
@property (nonatomic,strong) NSString *signature;
@property (nonatomic,strong) NSString *policy;
@property (nonatomic,strong)NSString *dir;//OSS上传文件路径




@end
