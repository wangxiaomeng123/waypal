



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
#import "bookDetailModel.h"
@interface BookDetailViewController ()
@property(nonatomic,strong)LessonViewModel *lessVModel;
@property(nonatomic,strong)bookDetailModel * detailModel;
@property (weak, nonatomic) IBOutlet UILabel *bookNameLabel;
@property (weak, nonatomic) IBOutlet UIView *pageView;
@property (weak, nonatomic) IBOutlet UIButton *prevButton;
@property (weak, nonatomic) IBOutlet UIButton *nextButton;

@property (nonatomic,strong)NSMutableArray *bookImagesArr;
@property (nonatomic,strong)NSMutableArray *questionArr;



@end

@implementation BookDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.lessVModel =[[LessonViewModel alloc] init];
    [self.bookNameLabel setAdjustsFontSizeToFitWidth:YES];
    self.bookNameLabel.text=self.bookModel.name;
    [self resquestBookDetailData];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)resquestBookDetailData{
    WeakSelf(self);
    [self.lessVModel getGreatcoursesDetailWithbookID:self.bookModel.book_id];
    [self.lessVModel setBlockWithReturnBlock:^(id returnValue) {
        weakself.detailModel =(bookDetailModel *)returnValue;
    } WithErrorBlock:^(id errorCode) {

    } WithFailureBlock:^{

    }];
    
    
}
- (IBAction)backAction:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)prevAction:(id)sender {
}


- (IBAction)nextAction:(id)sender {
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
