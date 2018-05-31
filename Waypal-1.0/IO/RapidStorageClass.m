//
//  RapidStorageClass.m
//  xiaojingyu
//
//  Created by lintao li on 2017/10/13.
//  Copyright © 2017年 kekejl. All rights reserved.
//

#import "RapidStorageClass.h"
#import "Config.h"


#define lUserPhoneKEY @"userPhone"
#define lUserPasswordKEY @"password"
#define lUserIDKEY @"userID"
#define lDocument [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]

@implementation RapidStorageClass


+ (void)saveUserPhone:(NSString *)phoneNumberString
{
    [lUSER_DEFAULT setObject:phoneNumberString forKey:lUserPhoneKEY];
}
+ (NSString *)readUserPhone
{
    return [lUSER_DEFAULT objectForKey:lUserPhoneKEY];
}
+ (void)deleteUserPhone
{
    [lUSER_DEFAULT removeObjectForKey:lUserPhoneKEY];
}


+ (void)saveUserPassword:(NSString *)passwordString
{
    [lUSER_DEFAULT setObject:passwordString forKey:lUserPasswordKEY];
}
+ (NSString *)readUserPassword
{
    return [lUSER_DEFAULT objectForKey:lUserPasswordKEY];
}
+ (void)deleteUserPassword
{
    [lUSER_DEFAULT removeObjectForKey:lUserPasswordKEY];
}


+ (void)saveUserID:(NSString *)uidString
{
    [lUSER_DEFAULT setObject:uidString forKey:lUserIDKEY];
}
+ (NSString *)readUserID
{
    return [lUSER_DEFAULT objectForKey:lUserIDKEY];
}
+ (void)deleteUserID
{
    [lUSER_DEFAULT removeObjectForKey:lUserIDKEY];
}


+ (void)saveObjectDataArchiver:(id<NSCopying>)obj key:(NSString *)key
{
    if (!obj)
    {
        return;
    }
    NSMutableData *data = [[NSMutableData alloc] init];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
    [archiver encodeObject:obj forKey:key];
    [archiver finishEncoding];

    NSString *filePath = [lDocument stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.archiver", key]];
    [data writeToFile:filePath atomically:YES];
}

+ (id)readObjectDataArchiverWithKey:(NSString *)key
{
    NSString *filePath = [lDocument stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.archiver", key]];
    NSMutableData *data = [[NSMutableData alloc] initWithContentsOfFile:filePath];
    if (!data)
    {
        return nil;
    }
    NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
    id content = [unarchiver decodeObjectForKey:key];
    [unarchiver finishDecoding];
    
    return content;
}

+ (void)deleteObjectDataArchiverWithKey:(NSString *)key
{
    NSString *filePath = [lDocument stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.archiver", key]];
    NSFileManager *manager=[[NSFileManager alloc] init];
    if ([manager fileExistsAtPath:filePath])
    {
        NSError *error;
        [manager removeItemAtPath:filePath error:&error];
        if (error)
        {
        }
    }
}


+ (void)saveDictionaryDataArchiver:(NSDictionary *)dictData key:(NSString *)key
{
    if (!dictData)
    {
        return;
    }
    NSString *filePath = [lDocument stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.json", key]];
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dictData options:NSJSONWritingPrettyPrinted error:&error];
    if (!error)
    {
        [jsonData writeToFile:filePath atomically:YES];
    }
}

+(NSDictionary *)readDictionaryDataArchiverWithKey:(NSString *)key
{
    NSString *filePath = [lDocument stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.json", key]];
    NSData *data = [[NSMutableData alloc] initWithContentsOfFile:filePath];
    if (!data)
    {
        return nil;
    }
    NSDictionary *dictData = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
    return dictData;
}

+ (void)deleteDictionaryDataArchiverWithKey:(NSString *)key
{
    NSString *filePath = [lDocument stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.json", key]];
    NSFileManager *manager=[[NSFileManager alloc] init];
    if ([manager fileExistsAtPath:filePath])
    {
        NSError *error;
        [manager removeItemAtPath:filePath error:&error];
        if (error)
        {
        }
    }
}




@end
