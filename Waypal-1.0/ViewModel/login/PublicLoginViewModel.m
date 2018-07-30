


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
        [self saveUserInformationWithResponseData:respData];
        self.returnBlock(respData);
     }
    else
    {
        NSString * errorTip = respData[@"tip"];
        self.errorBlock(errorTip);
    }
    
}

-(void)resigterWithPhoneNum:(NSString *)PhoneNum  verficode:(NSString *)verficode  password:(NSString *)password{
    NSDictionary *param =@{@"username":PhoneNum,@"mobile":PhoneNum,@"captcha":verficode,@"password":password,@"confirm_password":password};
    [ NetworkingTool postWithUrl:REGISTEROPERATION params:param isReadCache:YES success:^(NSURLSessionDataTask *task, id responseObject)
    {
//        if ([responseObject[@"code"] intValue]==REQUESTSUCCESS) {
//            self.returnBlock(responseObject);
//        }
//        else{
//            self.errorBlock(responseObject[@"tip"]);
//        }
        [self requestDataWithRespObject:responseObject];
        
    } failed:^(NSURLSessionDataTask *task, NSError *error, id responseObject) {
        self.failureBlock();
    }];
    
}


-(void)getbackPasswordWithUserName:(NSString *)userName verficode:(NSString *)verficode newPassword:(NSString *)newPassword
{
    [NetworkingTool postWithUrl:GETBACKPSDOPERATION params:@{} isReadCache:NO success:^(NSURLSessionDataTask *task, id responseObject) {
        
    } failed:^(NSURLSessionDataTask *task, NSError *error, id responseObject) {
        
    }];
    
    
}

-(void)getVerficdoeWithPhoneNum:(NSString *)phoneNum
{
    [NetworkingTool postWithUrl:VERIFICODEOPERATION params:@{@"mobile":phoneNum} isReadCache:YES success:^(NSURLSessionDataTask *task, id responseObject) {
        if ([responseObject[@"code"] intValue]==REQUESTSUCCESS) {
             self.returnBlock(responseObject);
        }
        else{
            self.errorBlock(responseObject[@"tip"]);
        }
       
    } failed:^(NSURLSessionDataTask *task, NSError *error, id responseObject) {
        self.failureBlock();
    }];
    
}
-(void)saveUserInformationWithResponseData:(NSDictionary*)responseData{
    NSDictionary *login_userInfo=responseData[@"output"];
    NSDictionary * userInfoDict=login_userInfo[@"user"];
    [RapidStorageClass saveDictionaryDataArchiver:responseData key:@"userInfo"];
    [lUSER_DEFAULT setObject:userInfoDict[@"username"] forKey:Key_RemberUserAccount];
    NSString *token =responseData[@"output"][@"token"];
    [RapidStorageClass saveLoginToken:token];
    [RapidStorageClass saveUserID:userInfoDict[@"id"] ];
}



@end
