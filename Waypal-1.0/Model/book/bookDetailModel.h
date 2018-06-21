//
//  bookDetailModel.h
//  Waypal-1.0
//
//  Created by waypal on 2018/6/19.
//  Copyright © 2018年 waypal. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface bookDetailModel : NSObject
//audio
@property(nonatomic,strong)  NSString * audio_ext;
@property(nonatomic,strong)  NSString * audio_filname;
@property(nonatomic,strong)  NSString * audio_part;
@property(nonatomic,strong) NSString * audio_id;




@property(nonatomic,strong)  NSMutableArray * booktestsArrary;
@property(nonatomic,strong) NSString * name;
@property(nonatomic,strong) NSString * is_readed;
@property(nonatomic,strong) NSString * course_id;
@property(nonatomic,strong) NSString * cover;
@property(nonatomic,strong) NSString * cover_path;
@property(nonatomic,strong) NSString * audio_path; 
@property(nonatomic,strong)NSMutableArray  *  imagesArrary;
@property(nonatomic,strong)NSString * detail_id;

@end
