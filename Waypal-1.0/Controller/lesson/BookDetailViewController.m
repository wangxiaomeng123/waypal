



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
#import "ImageModel.h"
#import "QuestionModel.h"
#import "MPFlipTransition.h"
#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVFoundation.h>
#import "audioModel.h"
#import "QuestionView.h"
#import "SubmitChooseOption.h"
#import "BooksViewModel.h"
#import "ImagesDownloadManager.h"

typedef enum : NSUInteger {
    bookPageType,
    questionPageType,
} playAudioType;
@interface BookDetailViewController ()<AVAudioPlayerDelegate>
@property(nonatomic,strong)LessonViewModel *lessVModel;
@property (weak, nonatomic) IBOutlet UILabel *bookNameLabel;
@property (weak, nonatomic) IBOutlet UIView *pageView;
@property (weak, nonatomic) IBOutlet UIButton *prevButton;
@property (weak, nonatomic) IBOutlet UIButton *nextButton;
@property (nonatomic,strong)NSMutableArray *bookImagesArr;
@property (nonatomic,strong)NSMutableArray *questionArr;
@property (nonatomic,strong)NSMutableArray *audioArr;
@property(nonatomic,strong)AVAudioPlayer *audioPlay;
@property (weak, nonatomic) IBOutlet UIButton *play_voiceButton;

@property(nonatomic,assign) NSInteger  currentPage;
@property (nonatomic,strong)UIButton *selectedBtn;//选中的btn
@property (nonatomic,strong) audioModel *audioModel;
@property(nonatomic,strong)NSTimer * audioTimer;
@property(nonatomic,strong)NSString * audioPlayPath;
@property(nonatomic,strong)NSMutableArray * questionResultArr;
@property(nonatomic,strong)NSDictionary * questionResultDict;
@property(nonatomic,strong)NSMutableArray * pageViewArr;


@end

@implementation BookDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.questionResultArr =[NSMutableArray array];
    self.lessVModel =[[LessonViewModel alloc] init];
    self.pageViewArr=[NSMutableArray array];
    [self.bookNameLabel setAdjustsFontSizeToFitWidth:YES];
    self.bookNameLabel.text=self.bookModel.name;
    [self resquestBookDetailData];
    self.currentPage=0;
    [self addSwipeGesture];
    
}

-(void)audioPlayActionWithPlayAudioPath:(NSString *)audioPath fileName:(NSString *)fileName  type:(playAudioType)type {
    
    if (audioPath.length!=0) {
        NSData *audioData = [NSData dataWithContentsOfURL:[NSURL URLWithString:audioPath]];
        NSString *docDirPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES) objectAtIndex:0];
        NSString *filePath = [NSString stringWithFormat:@"%@/%@.mp3", docDirPath ,fileName];
        [audioData writeToFile:filePath atomically:YES];
        NSError *error;
        NSURL *fileURL = [NSURL fileURLWithPath:filePath];
        
        
        self.audioPlay = [[AVAudioPlayer alloc] initWithContentsOfURL:fileURL error:&error];
        if (type==bookPageType) {
            self.audioPlay.currentTime=[self.audioModel.st doubleValue];
        }else{
            self.audioPlay.currentTime=0.0;
        }
        if (  self.audioPlay == nil)
        {
            DDLog(@"AudioPlayer did not load properly: %@", [error description]);
        }
        else
        {
            if (type==bookPageType) {
                [self play];
            }
            else
            {
                if ([self.audioPlay isPlaying]) {
                    [self.audioPlay pause];
                }
                [self.audioPlay play];
                [self.play_voiceButton setImage:[UIImage imageNamed:@"bookDetail__voice_play"] forState:UIControlStateNormal];
            }
            
        }
    }
    
}
#pragma mark 创建定时器
- (NSTimer *)audioTimer{
    if (!_audioTimer) {
        self.audioTimer = [NSTimer scheduledTimerWithTimeInterval:0.01 target:self
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
    NSString *  audio_currentTime=[NSString stringWithFormat:@"%.2f",self.audioPlay.currentTime];
    NSString * endTime=[NSString stringWithFormat:@"%.2f",[self.audioModel.et doubleValue]];
    if ([audio_currentTime isEqualToString:endTime] )
    {
        [self stopTimer];
        [self pause];
        
    }
}

-(void)pause{
    [self stopTimer];
    [self.audioPlay pause];
    [self.play_voiceButton setImage:[UIImage imageNamed:@"bookDetail__voice_pause"] forState:UIControlStateNormal];
}
-(void)play{
    if ([self.audioPlay isPlaying]) {
        [self pause];
    }
    [self starTimer];
    [self.audioPlay play];
    [self.play_voiceButton setImage:[UIImage imageNamed:@"bookDetail__voice_play"] forState:UIControlStateNormal];
}


-(void)resquestBookDetailData{
    self.bookImagesArr =self.detailModel.imagesArrary;
    self.questionArr=self.detailModel.booktestsArrary;
    self.audioArr=self.detailModel.audio_partArr;
    [self starReadBookAction];
    [self loadImageView];
    [self removeSelectOption];
}
-(void)starReadBookAction
{
    [self.pageView addSubview:[self getLabelForIndex:0]];
    self.audioModel=  [self playDuringWithPageIndex:self.currentPage+1];
    [self audioPlayActionWithPlayAudioPath:self.detailModel.audio_path fileName:self.detailModel.audio_id type:bookPageType];
    [self questionResultConfig];
    
}

- (IBAction)backAction:(id)sender {
    [self removeSelectOption];
    [self dismissAnimation];
}

#pragma mark 前一页
- (IBAction)prevAction:(id)sender {
    self.prevButton.enabled =NO;
//    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(changePreButtonStatus) object:self];
    [self performSelector:@selector(changePreButtonStatus) withObject:self afterDelay:1.0];
    if (self.currentPage ==0) {
        return;
    }
    self.currentPage--;
    [self changePageAnimation];
    
}

#pragma mark 后一页
- (IBAction)nextAction:(UIButton *)sender {
    self.nextButton.enabled =NO;
//    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(changeNextButtonStatus) object:self];
    [self performSelector:@selector(changeNextButtonStatus) withObject:self afterDelay:1.0];
    if (self.currentPage==self.bookImagesArr.count
        +self.questionArr.count)
    {
        return;
    }
    self.currentPage++;
    if(self.currentPage==self.questionArr.count+self.bookImagesArr.count)
    {
        if (self.questionArr.count!=0)
        {
            [self submitQuestionOption];
        }
    }else{
        [self changePageAnimation];
    }
}
-(void)changePreButtonStatus{
    self.prevButton.enabled =YES;
    
}
-(void)changeNextButtonStatus{
    self.nextButton.enabled =YES;
}
-(void)loadImageView{
    for (int i=0; i<self.detailModel.imagesArrary.count; i++)
    {
        UIView *nextView = [self getLabelForIndex:i];
        [self.pageViewArr  addObject:nextView];
    }
}


-(void)changePageAnimation{
    
    UIView *previousView = [[self.pageView subviews] objectAtIndex:0];
    UIView *nextView;
    if (self.currentPage<self.detailModel.imagesArrary.count)
    {
        nextView =self.pageViewArr[self.currentPage];
    }
    else{
        nextView = [self getLabelForIndex:self.currentPage];
    }
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
                                  
                              }
     ];
    [self pause];
    if (self.currentPage< self.bookImagesArr.count)
    {
        self.audioModel= [self playDuringWithPageIndex:self.currentPage+1];
        if (self.audioModel)
        {
            self.audioPlay.currentTime=[self.audioModel.st doubleValue];
            [self play];
        }
        if (self.currentPage==self.bookImagesArr.count-1) {
            [self audioPlayActionWithPlayAudioPath:self.detailModel.audio_path fileName:self.detailModel.audio_id type:bookPageType];
            
        }
        
    }
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
            
            optionView.questionAudioDoingBlock = ^(NSString *playAudioPath,NSString *fileName) {
                self.audioPlayPath =playAudioPath;
                [self audioPlayActionWithPlayAudioPath:playAudioPath fileName:fileName  type:questionPageType];
            };
            optionView.chooseOptionDoingBlock = ^(NSDictionary *chooseOptionInfoDict,NSInteger index)
            {
                
                [self.questionResultArr replaceObjectAtIndex:index withObject:chooseOptionInfoDict];
                
            };
            [optionView setViewData:questionModel];
            [container addSubview:optionView];
        }else
        {
            if (self.questionArr.count!=0) {
                WeakSelf(self);
                SubmitChooseOption *chooseOption=[[SubmitChooseOption alloc] initWithFrame:container.frame];
                chooseOption.readAgainDoingBlock = ^{
                    weakself.currentPage=0;
                    [weakself.pageView removeAllSubviews];
                    [weakself.questionResultArr removeAllObjects];
                    [weakself starReadBookAction];
                    [weakself removeSelectOption];
                    //                    [lUSER_DEFAULT setObject:[NSNumber numberWithBool:YES] forKey:@"isReadAgain"];
                };
                [chooseOption setDataWithDict:self.questionResultDict];
                [container addSubview:chooseOption];
            }
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
-(void)removeSelectOption {
    for (int i=0; i<self.questionArr.count; i++) {
        QuestionModel *model=self.questionArr[i];
        NSString *key=[NSString stringWithFormat:@"%@",model.booktest_id];
        [lUSER_DEFAULT removeObjectForKey:key];
    }
}


#pragma mark 匹配当前页面是否含有语音播放内容
-(audioModel *)playDuringWithPageIndex:(NSInteger)pageIndex{
    
    for (int i=0; i <self.audioArr.count;i++)
    {
        NSDictionary * audioDict =self.audioArr[i];
        NSInteger index=[audioDict[@"index"] integerValue];
        if( index ==pageIndex)
        {
            audioModel *model=[[audioModel alloc] init];
            [model setValuesForKeysWithDictionary:audioDict];
            model.duringTime =[model.et doubleValue] -[model.st doubleValue];
            if (model)
            {
                return  model;
            }
        }
        
    }
    return nil;
}
- (IBAction)replayAudioAction:(id)sender {
    if ([self.audioPlay isPlaying]) {
        [self pause];
    }else
    {
        self.audioModel= [self playDuringWithPageIndex:self.currentPage+1];
        [self audioPlayActionWithPlayAudioPath:self.detailModel.audio_path fileName:self.detailModel.audio_id type:bookPageType];
    }
    
}

-(void)viewWillDisappear:(BOOL)animated
{
    [self removeSelectOption];
    [super  viewWillDisappear:animated];
    [self.audioTimer invalidate];
    self.audioPlay=nil;
    self.audioTimer =nil;
}
-(void)dealloc{
    [self.audioTimer invalidate];
    self.audioPlay=nil;
    self.audioTimer =nil;
}
#pragma mark ================================= 添加清扫手势
-(void)addSwipeGesture{
    UISwipeGestureRecognizer *swipeRightGesture=[[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeRightGesture:)];
    swipeRightGesture.direction=UISwipeGestureRecognizerDirectionLeft;
    [self.pageView addGestureRecognizer:swipeRightGesture];
    UISwipeGestureRecognizer *swipeLeftGesture=[[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeLeftGesture:)];
    swipeLeftGesture.direction=UISwipeGestureRecognizerDirectionRight;
    [self.pageView addGestureRecognizer:swipeLeftGesture];
}
-(void)swipeLeftGesture:(UISwipeGestureRecognizer *)swipeGesture{
    //    [self performSelector:@selector(swipeLeftChangesStautes) withObject:self afterDelay:0.5];
    self.pageView.userInteractionEnabled=NO;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.pageView.userInteractionEnabled=YES;
    });
    if (swipeGesture.state ==UIGestureRecognizerStateEnded){
        [self  prevAction:nil];
    }
}
-(void)swipeLeftChangesStautes
{
    self.pageView.userInteractionEnabled=YES;
}
-(void)swipeRightGesture:(UISwipeGestureRecognizer *)swipeGesture{
    self.pageView.userInteractionEnabled=NO;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.pageView.userInteractionEnabled=YES;
    });
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
    DDLog(@"问题：%@",self.questionResultArr);
    [self.lessVModel submitGreatCoursesQuestionWithBookId:self.detailModel.detail_id questionOptionArr:self.questionResultArr];
    [self.lessVModel setBlockWithReturnBlock:^(id returnValue) {
        weakself.questionResultDict=(NSDictionary*)returnValue;
        [weakself changePageAnimation];
    } WithErrorBlock:^(id errorCode) {
        
    } WithFailureBlock:^{
        
    }];
    
}

-(void)dismissAnimation{
    CATransition *animation = [CATransition animation];
    animation.duration = 0.4;
    animation.type = @"pageCurl";
    animation.type = kCATransitionFromRight;
    [self.view.window.layer addAnimation:animation forKey:nil];
    [self dismissViewControllerAnimated:NO completion:nil];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



@end
