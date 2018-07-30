

//
//  liveRoomModel.m
//  Waypal-1.0
//
//  Created by waypal on 2018/5/19.
//  Copyright © 2018年 waypal. All rights reserved.
//

#import "liveRoomModel.h"

@implementation liveRoomModel
-(void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    if ([key isEqualToString:@"id"]) {
        self.room_id = (NSString *)value;
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
