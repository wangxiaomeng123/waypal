//
//  QuestionModel.h
//  Waypal-1.0
//
//  Created by waypal on 2018/6/19.
//  Copyright © 2018年 waypal. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QuestionModel : NSObject
@property(nonatomic,strong)  NSString * audio_id;
@property(nonatomic,strong) NSString * book_id;
@property(nonatomic,strong)  NSString * category;
@property(nonatomic,strong) NSString * content;
@property(nonatomic,strong) NSString * image_id;
@property(nonatomic,strong) NSString * published;
@property(nonatomic,strong) NSString * video_id;
@property (nonatomic,strong)NSString *booktest_id;
//options
@property(nonatomic,strong) NSMutableArray *optionsArr;


@end

