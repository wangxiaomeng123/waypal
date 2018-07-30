//
//  BookModel.h
//  Waypal-1.0
//
//  Created by waypal on 2018/6/13.
//  Copyright © 2018年 waypal. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BookModel : NSObject
@property(nonatomic,strong)NSString * audio_part;
@property(nonatomic,strong)NSString *audio_path;
@property(nonatomic,strong)NSString * audio_id;
@property(nonatomic,strong)NSString * course_id;
@property(nonatomic,strong)NSString * cover;
@property(nonatomic,strong)NSString * cover_path;
@property(nonatomic,strong)NSString * book_id;
@property(nonatomic,strong)NSString * is_readed;
@property(nonatomic,strong)NSString * name;
@end

