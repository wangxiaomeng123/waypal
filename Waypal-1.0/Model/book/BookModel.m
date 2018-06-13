
//
//  BookModel.m
//  Waypal-1.0
//
//  Created by waypal on 2018/6/13.
//  Copyright © 2018年 waypal. All rights reserved.
//

#import "BookModel.h"

@implementation BookModel
-(void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    if ([key isEqualToString:@"audio"]) {
        NSDictionary* audioDict=(NSDictionary*)value;
        self.ext =audioDict[@"ext"];
        self.filname=audioDict[@"filname"];
        self.part=audioDict[@"part"];
    }
    if ([key isEqualToString:@"id"]) {
        self.book_id =value;
    }
    
}
@end
