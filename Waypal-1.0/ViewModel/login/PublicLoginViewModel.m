


//
//  PublicLoginViewModel.m
//  PC_Waypal
//
//  Created by waypal on 2018/5/16.
//  Copyright © 2018年 waypal. All rights reserved.
//

#import "PublicLoginViewModel.h"
#import "Config.h"
#import "NetworkingTool.h"
#import "UserInfoModel.h"
@implementation PublicLoginViewModel
-(void)loginWithUserName:(NSString *)userName password:(NSString *)password
{
    NSDictionary * loginParam=@{@"username":userName ,@"password":password};
    [NetworkingTool postWithUrl:LOGINOPERATION params:loginParam isReadCache:NO success:^(NSURLSessionDataTask *task, id responseObject) {
        [self requestDataWithRespObject:responseObject];
        
    } failed:^(NSURLSessionDataTask *task, NSError *error, id responseObject){
        self.failureBlock();
    } ];
}

-(void)requestDataWithRespObject:(NSDictionary *)respData
{
    NSInteger requestCode =[respData[@"code"] integerValue];
    if (requestCode  ==REQUESTSUCCESS) {
        NSDictionary *login_userInfo=respData[@"output"];
        [lUSER_DEFAULT setObject:login_userInfo[@"user"][@"name"] forKey:@"remberUserName"];
        [RapidStorageClass saveDictionaryDataArchiver:respData key:@"userInfo"];
        NSString *token =respData[@"output"][ACCESSTOKEN];
        [lUSER_DEFAULT setObject:token forKey:ACCESSTOKEN];
        
        
        self.returnBlock(respData);
     }
    else
    {
        NSString * errorTip = respData[@"tip"];
        self.errorBlock(errorTip);
    }
    
}



@end
