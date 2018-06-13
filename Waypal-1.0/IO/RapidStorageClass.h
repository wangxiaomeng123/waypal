//
//  RapidStorageClass.h
//  xiaojingyu
//
//  Created by lintao li on 2017/10/13.
//  Copyright © 2017年 kekejl. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RapidStorageClass : NSObject

/**
 保存、读取、删除 用户登录手机号

 */
+ (void) saveUserPhone:(NSString *)phoneNumberString;
+ (NSString *) readUserPhone;
+ (void) deleteUserPhone;


/**
 保存、读取、删除 用户登录密码

 */
+ (void) saveUserPassword:(NSString *)passwordString;
+ (NSString *) readUserPassword;
+ (void) deleteUserPassword;


/**
 保存、读取、删除 用户唯一标识字符

 */
+ (void) saveUserID:(NSString *)uidString;
+ (NSString *) readUserID;
+ (void) deleteUserID;


/**
 保存token
 */
+(void)saveLoginToken:(NSString *)token;
+(NSString*)readToken;
+(void)deleteToken;



/**
 保存、读取、删除 已经实现归档协议的对象

 @param obj 对象，必须实现copy协议
 @param key 文件名或者关键字
 */
+ (void) saveObjectDataArchiver:(id<NSCopying>)obj key:(NSString *)key;
+ (id) readObjectDataArchiverWithKey:(NSString *)key;
+ (void) deleteObjectDataArchiverWithKey:(NSString *)key;



/**
 保存、读取、删除 字典对象

 @param dictData 字典对象
 @param key 文件名或者关键字
 */
+ (void) saveDictionaryDataArchiver:(NSDictionary *)dictData key:(NSString *)key;
+ (NSDictionary *) readDictionaryDataArchiverWithKey:(NSString *)key;
+ (void) deleteDictionaryDataArchiverWithKey:(NSString *)key;





@end
