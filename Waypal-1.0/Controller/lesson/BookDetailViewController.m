



//
//  BookDetailViewController.m
//  Waypal-1.0
//
//  Created by waypal on 2018/6/13.
//  Copyright © 2018年 waypal. All rights reserved.
//

#import "BookDetailViewController.h"
#import "Config.h"
#import "LessonViewModel.h"
@interface BookDetailViewController ()
@property(nonatomic,strong)LessonViewModel *lessVModel;
@end

@implementation BookDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.lessVModel =[[LessonViewModel alloc] init];
    [self resquestBookDetailData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)resquestBookDetailData{
    [self.lessVModel getGreatcoursesDetailWithbookID:self.bookModel.book_id];
    [self.lessVModel setBlockWithReturnBlock:^(id returnValue) {
        
    } WithErrorBlock:^(id errorCode) {
        
    } WithFailureBlock:^{
        
    }];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
