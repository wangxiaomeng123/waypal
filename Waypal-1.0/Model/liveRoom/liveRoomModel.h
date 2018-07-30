//
//  liveRoomModel.h
//  Waypal-1.0
//
//  Created by waypal on 2018/5/19.
//  Copyright © 2018年 waypal. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface liveRoomModel : UIView
@property(nonatomic,strong)NSString *endTime;
@property(nonatomic,strong)NSString *room_id;//roomid

@property(nonatomic,strong)NSString *institutionId;

@property(nonatomic,strong)NSString *lesson_slide_url;

@property(nonatomic,strong)NSString *recordmode;

@property(nonatomic,strong)NSString *scenario;
@property(nonatomic,strong)NSString *startTime;
@property(nonatomic,strong)NSString *status;
@property (nonatomic,strong)NSString * title;
@property(nonatomic,strong) NSString * slide_count;

@end
