//
//  AppVersionModel.h
//  Waypal-1.0
//
//  Created by waypal on 2018/5/25.
//  Copyright © 2018年 waypal. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AppVersionModel : NSObject
+(AppVersionModel *)shareInstance;
-(void)handlerInitRespData:(NSDictionary *)respData;
@property (nonatomic,strong) NSDictionary *VersionInfoDict;
@end
