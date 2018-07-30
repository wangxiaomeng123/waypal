//
//  AppVersionViewModel.h
//  Waypal-1.0
//
//  Created by waypal on 2018/5/25.
//  Copyright © 2018年 waypal. All rights reserved.
//

#import "ViewModelClass.h"
#import "Config.h"
#import <AdSupport/AdSupport.h>
@interface AppVersionViewModel : ViewModelClass
-(void)initAppSetting;

/**
 上传头像，获取相关OSS 配置信息
 */
-(void)initUploadSingureRequest;
-(void)updateToken;


@end
