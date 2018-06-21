


//
//  ImageModel.m
//  Waypal-1.0
//
//  Created by waypal on 2018/6/19.
//  Copyright © 2018年 waypal. All rights reserved.
//

#import "ImageModel.h"

@implementation ImageModel
-(void)setValue:(id)value forUndefinedKey:(NSString *)key{
    if ([key isEqualToString:@"id"]) {
        self.image_id =value;
    }
}
@end
