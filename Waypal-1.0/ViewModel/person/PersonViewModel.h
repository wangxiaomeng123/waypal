//
//  PersonViewModel.h
//  iPad_wayPal
//
//  Created by waypal on 2018/5/18.
//  Copyright © 2018年 waypal. All rights reserved.
//

#import "ViewModelClass.h"

@interface PersonViewModel : ViewModelClass

/**
 编辑用户信息

 @param name 用户名称
 @param nick 昵称
 @param password 密码
 @param imagePath 头像地址
 */
-(void)editUserInfoWithName:(NSString *)name nick:(NSString *)nick password:(NSString *)password  avatarImagePath:(NSString *)imagePath ;
@end
