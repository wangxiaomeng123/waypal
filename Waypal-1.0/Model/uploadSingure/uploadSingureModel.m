

//
//  uploadSingureModel.m
//  Waypal-1.0
//
//  Created by waypal on 2018/6/11.
//  Copyright © 2018年 waypal. All rights reserved.
//

#import "uploadSingureModel.h"

@implementation uploadSingureModel
+(uploadSingureModel *)shareInstance{
    static dispatch_once_t onceToken;
    static  uploadSingureModel * uploadModel=nil;
    dispatch_once(&onceToken, ^{
        uploadModel =[[uploadSingureModel alloc] init];
    });
    return uploadModel;
}

-(void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    
}
@end
