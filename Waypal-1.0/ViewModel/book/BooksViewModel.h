//
//  BooksViewModel.h
//  Waypal-1.0
//
//  Created by waypal on 2018/6/28.
//  Copyright © 2018年 waypal. All rights reserved.
//

#import "ViewModelClass.h"

@interface BooksViewModel : ViewModelClass
/**
 获取泛读列表
 
 @param course_id 课程id
 @param page  页数
 */
-(void)getGetCourseWithCourseID:(NSString *)course_id page:(NSString *)page;

/**
 获取读本详情
 @param book_id 读本id
 */
-(void)getGreatcoursesDetailWithbookID:(NSString *)book_id;


@end
