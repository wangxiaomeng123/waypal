
//
//  TempClassModel.m
//  Waypal-1.0
//
//  Created by waypal on 2018/5/29.
//  Copyright © 2018年 waypal. All rights reserved.
//

#import "TempClassModel.h"

@implementation TempClassModel
-(void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    if ([key isEqualToString:@"id"]) {
        self.schedule_id=key;
    }
}
@end
