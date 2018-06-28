



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
#import "ImageModel.h"
#import "QuestionModel.h"
#import "MPFlipTransition.h"
#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVFoundation.h>
#import "audioModel.h"
#import "QuestionView.h"
#import "SubmitChooseOption.h"
#import "BooksViewModel.h"
@interface BookDetailViewController ()<AVAudioPlayerDelegate>
@property(nonatomic,strong)LessonViewModel *lessVModel;
@property(nonatomic,strong)bookDetailModel * detailModel;
@property (weak, nonatomic) IBOutlet UILabel *bookNameLabel;
@property (weak, nonatomic) IBOutlet UIView *pageView;
@property (weak, nonatomic) IBOutlet UIButton *prevButton;
@property (weak, nonatomic) IBOutlet UIButton *nextButton;
@property (nonatomic,strong)NSMutableArray *bookImagesArr;
@property (nonatomic,strong)NSMutableArray *questionArr;
@property (nonatomic,strong)NSMutableArray *audioArr;
//@property(nonatomic,strong)AVPlayer *audioPlay;
@property(nonatomic,strong)AVAudioPlayer *audioPlay;

@property(nonatomic,assign) NSInteger  currentPage;
@property (nonatomic,strong)UIButton *selectedBtn;//选中的btn
@property (nonatomic,strong) audioModel *audioModel;
@property(nonatomic,strong)NSTimer * audioTimer;
@property(nonatomic,strong)NSString * audioPlayPath;
@property(nonatomic,strong)NSMutableArray * questionResultArr;
@property(nonatomic,strong)NSDictionary * questionResultDict;

@end

@implementation BookDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.questionResultArr =[NSMutableArray array];
     self.lessVModel =[[LessonViewModel alloc] init];
    [self.bookNameLabel setAdjustsFontSizeToFitWidth:YES];
    self.bookNameLabel.text=self.bookModel.name;
    [self resquestBookDetailData];
    self.currentPage=0;
    [self addSwipeGesture];
    
}

-(void)audioPlayAction{
     self.audioPlayPath = self.detailModel.audio_path;
    NSData *audioData = [NSData dataWithContentsOfURL:[NSURL URLWithString:self.audioPlayPath]];
    NSString *docDirPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES) objectAtIndex:0];
    NSString *fileName=self.detailModel.audio_filname;
    NSString *filePath = [NSString stringWithFormat:@"%@/%@.mp3", docDirPath ,fileName];
    [audioData writeToFile:filePath atomically:YES];
    NSError *error;
    NSURL *fileURL = [NSURL fileURLWithPath:filePath];
    self.audioPlay = [[AVAudioPlayer alloc] initWithContentsOfURL:fileURL error:&error];
    self.audioPlay.currentTime=[self.audioModel.st  doubleValue];
    if (  self.audioPlay == nil)
    {
        NSLog(@"AudioPlayer did not load properly: %@", [error description]);
    }
    else
    {
        [self.audioPlay play];
    }
    
}


- (NSTimer *)audioTimer{
    if (!_audioTimer) {
        _audioTimer = [NSTimer scheduledTimerWithTimeInterval:1.0  target:self
                                                selector:@selector(timerAction) userInfo:nil repeats:YES];
    }
    return _audioTimer;
}

-(void)starTimer{
    
    [ self.audioTimer setFireDate:[NSDate distantPast]];
}
-(void)stopTimer{
    [self.audioTimer setFireDate:[NSDate distantFuture]];
}
-(void)timerAction{
    if ( ceil(self.audioPlay.currentTime)==ceil([self.audioModel.et intValue]))
    {
        [self stopTimer];
        [self.audioPlay pause];
    }
}


-(void)resquestBookDetailData{
    WeakSelf(self);
    BooksViewModel *booksVM=[[BooksViewModel alloc] init];
    [booksVM getGreatcoursesDetailWithbookID:self.bookModel.book_id];
    [booksVM setBlockWithReturnBlock:^(id returnValue) {
         weakself.detailModel =(bookDetailModel *)returnValue;
         weakself.bookImagesArr=weakself.detailModel.imagesArrary;
        weakself.questionArr=weakself.detailModel.booktestsArrary;
         weakself.audioArr=weakself.detailModel.audio_partArr;
        [weakself.pageView addSubview:[weakself getLabelForIndex:0]];
        [weakself playDuringWithPageIndex:self.currentPage+1];
        [weakself questionResultConfig];
        [weakself audioPlayAction];
    } WithErrorBlock:^(id errorCode) {
        [self dismissViewControllerAnimated:YES completion:nil];
         [LoadingView tipViewWithTipString:errorCode];
    } WithFailureBlock:^{
        [LoadingView tipViewWithTipString:@"网络请求失败"];
    }];
}


- (IBAction)backAction:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark 前一页
- (IBAction)prevAction:(id)sender {
    self.prevButton.userInteractionEnabled =NO;
    [self performSelector:@selector(changePreButtonStatus) withObject:self afterDelay:0.5];
      [self.audioPlay pause];
    if (self.currentPage ==0) {
        return;
    }
    self.currentPage--;
    [self changePageAnimation];
}
#pragma mark 后一页
- (IBAction)nextAction:(UIButton *)sender {
        self.nextButton.userInteractionEnabled =NO;
    [self performSelector:@selector(changeNextButtonStatus) withObject:self afterDelay:0.5];
    [self.audioPlay pause];
    if (self.currentPage==self.bookImagesArr.count
        +self.questionArr.count)
    {
        return;
    }
    self.currentPage++;
    [self changePageAnimation];
}
-(void)changePreButtonStatus{
    self.prevButton.userInteractionEnabled =YES;
}
-(void)changeNextButtonStatus{
     self.nextButton.userInteractionEnabled =YES;
}

-(void)changePageAnimation{
    
    UIView *previousView = [[self.pageView subviews] objectAtIndex:0];
    UIView *nextView = [self getLabelForIndex:self.currentPage];
    BOOL forwards = nextView.tag > previousView.tag;
    if (nextView.tag == self.bookImagesArr.count && previousView.tag ==0)
        forwards = NO;
    else if (nextView.tag == 0 && previousView.tag == self.bookImagesArr.count)
        forwards = YES;
    [MPFlipTransition transitionFromView:previousView
                                  toView:nextView
                                duration:[MPTransition defaultDuration]
                                   style:forwards? MPFlipStyleDefault : MPFlipStyleFlipDirectionBit(MPFlipStyleDefault)
                        transitionAction:MPTransitionActionAddRemove
                              completion:^(BOOL finished) {
                                  if (self.currentPage< self.bookImagesArr.count) {
                                     [self playDuringWithPageIndex:self.currentPage+1];
                                  }else if (self.currentPage==self.questionArr.count+self.bookImagesArr.count-1){
                                       [self submitQuestionOption];
                                  }
                           
           }
     ];
}

#pragma mark - Instance methods

- (UIView *)getLabelForIndex:(NSUInteger)index
{
    UIView *container = [[UIView alloc] initWithFrame:self.pageView.bounds];
    container.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    [container setBackgroundColor:[UIColor whiteColor]];
    if (index<self.bookImagesArr.count)
    {
            UIImageView *img=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, container.frame.size.width, container.frame.size.height)];
            ImageModel *model= self.bookImagesArr[index];
            [img sd_setImageWithURL:[NSURL URLWithString:model.path] placeholderImage:[UIImage imageNamed:@""] options:SDWebImageAllowInvalidSSLCertificates];
            [container addSubview:img];
    }
    else  {
        
     
           NSInteger imageIndex=index-self.bookImagesArr.count;
        if (imageIndex<self.questionArr.count)
        {
            QuestionModel *questionModel=self.questionArr[imageIndex];
            QuestionView * optionView=[[QuestionView alloc] initWithFrame:CGRectMake(0, 0, container.frame.size.width, container.frame.size.height)];
            optionView.tag =imageIndex;
            optionView.questionAudioDoingBlock = ^(NSString *playAudioPath) {
                self.audioPlayPath =playAudioPath;
                [self.audioPlay play];
            };
            optionView.chooseOptionDoingBlock = ^(NSDictionary *chooseOptionInfoDict,NSInteger index) {
                [self.questionResultArr replaceObjectAtIndex:index withObject:chooseOptionInfoDict];
            };
            [optionView setViewData:questionModel];
            [container addSubview:optionView];
        }else
        {
            WeakSelf(self);
            SubmitChooseOption *chooseOption=[[[NSBundle mainBundle] loadNibNamed:@"SubmitChooseOption" owner:self options:0] lastObject];
            chooseOption.frame=container.frame;
            chooseOption.readAgainDoingBlock = ^{
                   weakself.currentPage=0;
                [weakself.pageView removeAllSubviews];
                [weakself.pageView addSubview:[weakself getLabelForIndex: weakself.currentPage]];
            };
            [chooseOption setDataWithDict:self.questionResultDict];
            [container addSubview:chooseOption];
        }
       
    }

    
    container.tag = index;
    return container;
}
-(void)questionResultConfig{
    static   NSString *  right_option_id;
    for (int i=0; i<self.questionArr.count; i++) {
        QuestionModel *questionModel=self.questionArr[i];
        [questionModel.optionsArr enumerateObjectsUsingBlock:^(QuestionOptionModel * obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj.isanswer boolValue]==YES) {
                right_option_id =obj.options_id;
            }
        }];
        NSDictionary*     questionInfoDict=@{@"book_test_id":[NSNumber numberWithInt:[questionModel.booktest_id intValue]],
                                             @"right_option_id":[NSNumber numberWithInt:[right_option_id intValue]],
                                             @"answer_option_id":[NSNumber numberWithInt:0]};
        [self.questionResultArr insertObject:questionInfoDict atIndex:i];
    }
}



#pragma mark 匹配当前页面是否含有语音播放内容
-(void)playDuringWithPageIndex:(NSInteger)pageIndex{
    self.audioPlayPath = self.detailModel.audio_path;
    [self.audioPlay pause];
    [self stopTimer];
        for (int i=0; i <self.audioArr.count;i++)
    {
        NSDictionary * audioDict =self.audioArr[i];
        NSInteger index=[audioDict[@"index"] integerValue];
        if( index ==pageIndex)
        {
                    audioModel *model=[[audioModel alloc] init];
                    [model setValuesForKeysWithDictionary:audioDict];
                     model.duringTime =[model.et doubleValue] -[model.st doubleValue];
                     self.audioModel=model;
                if (self.audioModel) {
                     [self.audioPlay pause];
                        self.audioPlay.currentTime=[self.audioModel.st  doubleValue];
                        [self.audioPlay prepareToPlay];
                        [self.audioPlay play];
                        [self starTimer];
                        return;
                }
        }else{
            self.audioModel =nil;
            [self stopTimer];
            [self.audioPlay pause];

        }
    }
}
- (IBAction)replayAudioAction:(id)sender {
    [self playDuringWithPageIndex:self.currentPage
     +1];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super  viewWillDisappear:animated];
    [self.audioPlay pause];
    [self stopTimer];
}
-(void)dealloc{
    self.audioPlay=nil;
    self.audioTimer =nil;
}
#pragma mark 添加清扫手势
-(void)addSwipeGesture{
    UISwipeGestureRecognizer *swipeRightGesture=[[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeRightGesture:)];
    swipeRightGesture.direction=UISwipeGestureRecognizerDirectionLeft;
     [self.pageView addGestureRecognizer:swipeRightGesture];
    UISwipeGestureRecognizer *swipeLeftGesture=[[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeLeftGesture:)];
    swipeLeftGesture.direction=UISwipeGestureRecognizerDirectionRight;
    [self.pageView addGestureRecognizer:swipeLeftGesture];
}
-(void)swipeLeftGesture:(UISwipeGestureRecognizer *)swipeGesture{
    [self performSelector:@selector(swipeLeftChangesStautes) withObject:self afterDelay:0.5];
    self.pageView.userInteractionEnabled=NO;
    if (swipeGesture.state ==UIGestureRecognizerStateEnded){
        [self  prevAction:nil];
    }
}
-(void)swipeLeftChangesStautes
{
    self.pageView.userInteractionEnabled=YES;
}
-(void)swipeRightGesture:(UISwipeGestureRecognizer *)swipeGesture{
    [self performSelector:@selector(swipeRightChangesStautes) withObject:self afterDelay:0.5];
    self.pageView.userInteractionEnabled=NO;
   if (swipeGesture.state ==UIGestureRecognizerStateEnded){
        [self  nextAction:nil];
    }
}
-(void)swipeRightChangesStautes
{
    self.pageView.userInteractionEnabled=YES;
}


-(void)submitQuestionOption{
    WeakSelf(self);
    [self.lessVModel submitGreatCoursesQuestionWithBookId:self.detailModel.detail_id questionOptionArr:self.questionResultArr];
    [self.lessVModel setBlockWithReturnBlock:^(id returnValue) {
        weakself.questionResultDict=(NSDictionary*)returnValue;
    } WithErrorBlock:^(id errorCode) {
          
    } WithFailureBlock:^{
     
    }];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



@end
