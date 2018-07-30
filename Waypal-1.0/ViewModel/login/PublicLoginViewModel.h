//
//  PublicLoginViewModel.h
//  PC_Waypal
//
//  Created by waypal on 2018/5/16.
//  Copyright © 2018年 waypal. All rights reserved.
//

#import "ViewModelClass.h"

@interface PublicLoginViewModel : ViewModelClass

/**
 登录

 @param userName 用户名
 @param password 密码
 */
-(void)loginWithUserName:(NSString *)userName password:(NSString *)password;

/**
 注册

 @param PhoneNum 手机号
 @param verficode 验证码
 @param password 密码
 */
-(void)resigterWithPhoneNum:(NSString *)PhoneNum  verficode:(NSString *)verficode  password:(NSString *)password;


/**
 找回密码

 @param PhoneNum 手机号
 @param verficode 验证码
 @param newPassword 新密码
 */
-(void)getbackPasswordWithPhoneNum:(NSString *)PhoneNum verficode:(NSString *)verficode  newPassword:(NSString *)newPassword;

/**
 获取验证码

 @param phoneNum 用户名
 */
-(void)getVerficdoeWithPhoneNum:(NSString *)phoneNum;

@end
