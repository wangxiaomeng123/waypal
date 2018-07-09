//
//  BooksViewModel.m
//  Waypal-1.0
//
//  Created by waypal on 2018/6/28.
//  Copyright © 2018年 waypal. All rights reserved.
//

#import "BooksViewModel.h"
#import "Config.h"
#import "BookModel.h"
#import "bookDetailModel.h"
#define pagesize @"16"

@implementation BooksViewModel
-(void)getGetCourseWithCourseID:(NSString *)course_id  page:(NSString *)page {
    
    //    [RapidStorageClass saveUserID:@"535"];
    NSMutableArray *booksArr=[NSMutableArray array];
    NSString *resquestURL =[NSString stringWithFormat:@"%@%@",GREATCOURSESLISTOPERATION,course_id];
    NSDictionary *param=@{@"student_id":[RapidStorageClass readUserID],@"page":page,@"pagesize":pagesize};
    [NetworkingTool getWithUrl:resquestURL params:param isReadCache:NO success:^(NSURLSessionDataTask *task, id responseObject) {
        if ([responseObject[@"code"] intValue]==REQUESTSUCCESS) {
            
            NSArray * bookArr=    responseObject[@"output"];
            for(NSDictionary *bookDict in bookArr)
            {
                BookModel *book=[[BookModel alloc] init];
                [book setValuesForKeysWithDictionary:bookDict];
                [booksArr addObject:book];
            }
            self.returnBlock(booksArr);
        }else
        {
            self.errorBlock(responseObject[@"tip"]);
            
        }
        
    } failed:^(NSURLSessionDataTask *task, NSError *error, id responseObject) {
        self.failureBlock();
    }];
    
}
-(void)getGreatcoursesDetailWithbookID:(NSString *)book_id  {
    NSString *resquestURL =[NSString stringWithFormat:@"%@%@",GREATCOURSESDETAILOPERATION,book_id];
    [NetworkingTool getWithUrl:resquestURL params:@{@"student_id":[RapidStorageClass readUserID]} isReadCache:NO success:^(NSURLSessionDataTask *task, id responseObject) {
        if ([responseObject[@"code"] intValue]==REQUESTSUCCESS)
        {
            NSDictionary *outputDict=(NSDictionary *)responseObject[@"output"];
            bookDetailModel *detailModel=[[bookDetailModel alloc] init];
            [detailModel setValuesForKeysWithDictionary:outputDict];
            self.returnBlock(detailModel);
            
        }else
        {
            self.errorBlock(responseObject[@"tip"]);
            
        }
    } failed:^(NSURLSessionDataTask *task, NSError *error, id responseObject)
     {
         self.failureBlock();
     }];
    
    
}
@end
