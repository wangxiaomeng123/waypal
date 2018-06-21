
//
//  bookDetailModel.m
//  Waypal-1.0
//
//  Created by waypal on 2018/6/19.
//  Copyright © 2018年 waypal. All rights reserved.
//

#import "bookDetailModel.h"
#import "QuestionModel.h"
#import "ImageModel.h"
@implementation bookDetailModel
-(void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    if ([key isEqualToString:@"id"]) {
        self.detail_id =value;
    }
    if ([key isEqualToString:@"audio"]) {
        NSDictionary * audioDict =(NSDictionary *)value;
        self.audio_id=audioDict[@"id"];
        self.audio_ext=audioDict[@"ext"];
        self.audio_filname=audioDict[@"filname"];
        self.audio_part=audioDict[@"part"];
    }
    if ([key isEqualToString:@"booktests"]) {
        NSArray * booktestArr=(NSArray *)value;
        NSMutableArray * booksArr=[NSMutableArray array];
        for(NSDictionary * bookDict in booktestArr){
            QuestionModel * model=[[QuestionModel alloc] init];
            [model setValuesForKeysWithDictionary:bookDict];
            [booksArr addObject:model];
        }
        self.booktestsArrary =booksArr;
    }
    
    if ([key isEqualToString:@"images"]) {
        NSMutableArray * images=[NSMutableArray array];
        NSArray * imagesArr=(NSArray *)value;
        for(NSDictionary * imageDict in imagesArr)
        {
            ImageModel *model =[[ImageModel alloc] init];
            [model setValuesForKeysWithDictionary:imageDict];
            [images addObject: model];
        }
        self.imagesArrary =images;
    }
  
}
@end
