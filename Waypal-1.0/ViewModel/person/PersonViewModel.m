

//
//  PersonViewModel.m
//  iPad_wayPal
//
//  Created by waypal on 2018/5/18.
//  Copyright © 2018年 waypal. All rights reserved.
//

#import "PersonViewModel.h"
#import "Config.h"
#import "NetworkingTool.h"
@implementation PersonViewModel
-(void)editUserInfoWithName:(NSString *)name nick:(NSString *)nick password:(NSString *)password avatarImagePath:(NSString *)imagePath{
    
    NSDictionary  *userParam =@{@"nick":nick,@"name":name ,@"password":password,@"avatar":imagePath};
    DDLog(@"参数：%@",userParam);
    [NetworkingTool postWithUrl:USERINFOOPERATION params:userParam isReadCache:NO success:^(NSURLSessionDataTask *task, id responseObject) {
        [self saveUserInfoWithRespondeData:responseObject];
    } failed:^(NSURLSessionDataTask *task, NSError *error, id responseObject) {
        self.failureBlock();
    }];
    
}
-(void)saveUserInfoWithRespondeData:(NSDictionary *)respData
{
    NSDictionary * respDict=respData[@"output"];
    if ([respData[@"code"] integerValue]== REQUESTSUCCESS) {
        [RapidStorageClass saveDictionaryDataArchiver:respData key:@"userInfo"];
        self.returnBlock(respDict);
    }else
    {
        
        self.errorBlock(respDict[@"tip"]);
    }
}


@end
