


//
//  AppVersionModel.m
//  Waypal-1.0
//
//  Created by waypal on 2018/5/25.
//  Copyright © 2018年 waypal. All rights reserved.
//

#import "AppVersionModel.h"

@implementation AppVersionModel
+(AppVersionModel *)shareInstance{
    static AppVersionModel * appSettingManager =nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        appSettingManager =[[AppVersionModel alloc] init];
    });
    return appSettingManager;
    
    
}
-(void)handlerInitRespData:(NSDictionary *)respData{
    
    if (respData==nil) {
        return;
    }
    self.VersionInfoDict=respData[@"output"];
    
}

@end
