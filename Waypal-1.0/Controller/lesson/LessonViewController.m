
//
//  LessonViewController.m
//  iPad_wayPal
//
//  Created by waypal on 2018/5/16.
//  Copyright © 2018年 waypal. All rights reserved.
//

#import "LessonViewController.h"
#import "Config.h"
#import "LessonViewModel.h"
#import "LessonItemView.h"
#import "TempClassViewController.h"
#import "PersonViewController.h"
#import "WCRClassroomSkin.h"
#import "liveRoomModel.h"
#import "LiveRoom.h"
#import "UserInfoModel.h"
#import "StarrySkyAnimate.h"
#import "navCourseImageView.h"
#define SAFEAREABOTTOM_HEIGHT (SCREEN_HEIGHT == 812.f ? 34.f : 0.f)

@interface LessonViewController ()<UIScrollViewDelegate,WCRClassRoomDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *lesson_scrollView;
@property (nonatomic,strong)LessonInfoModel *selectInfoModel;//课表显示的model
@property (nonatomic,strong)liveRoomModel * liveroomModel;//进入房间的model
@property (nonatomic,strong)LessonViewModel *lessonVM ;
@property (nonatomic, strong) WCRClassRoom* classRoom;
@property (weak, nonatomic) IBOutlet UILabel *studentNameLabel;
@property (nonatomic,assign) NSInteger currentPage;
@property (weak, nonatomic) IBOutlet UIButton *nextButton;
@property (weak, nonatomic) IBOutlet UIButton *prevButton;
@property (weak, nonatomic) IBOutlet UIImageView *lesson_nothingImgView;
@property (weak, nonatomic) IBOutlet UIImageView *student_advatarImageView;
@property (nonatomic,assign) BOOL isJoining; //防重进机制
@property (nonatomic,assign) NSInteger totalNum;//总页数
@property (nonatomic,assign)  NSInteger totalPages;
@property (nonatomic,strong)UIButton * guide_playbackButton;//回访
@property (nonatomic,strong)UIButton * guide_inClassButton;//上课
@property (weak, nonatomic) IBOutlet UIImageView *lesson_bgImageView;
@property (nonatomic,assign)BOOL isNotHistory;//是否还有历史课堂
@property (nonatomic,strong) NSMutableArray * lessonListArrary;//课程列表
@property (nonatomic,strong) NSArray * currentLesson;//当前可以上课的
@property(nonatomic,strong)  NSArray * historyLessson;//历史的数据
@property(nonatomic,assign)BOOL isReshHistory;//是否刷新历史记录
@property (nonatomic,assign)int guideNum;//引导页的的总个数
@property(nonatomic,assign) CGFloat lastContentOffset;//用判断左滑还是右
@property (nonatomic,strong)  NSMutableArray * navCourseArr;

@property(nonatomic,assign)BOOL isTempClass;
@property (nonatomic,strong)TempClassModel *tempModel;
@end

@implementation LessonViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.currentPage =0;//默认是1
    self.guideNum=1;
    self.lessonListArrary=[NSMutableArray array];
    self.navCourseArr=[NSMutableArray array];
    self.lessonVM =[[LessonViewModel alloc] init];
    [self ConfigUserInfo];
    [self loadGuideView];
    lViewBorderRadius(self.student_advatarImageView, 28, 2,[UIColor whiteColor]);
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (self.lessonListArrary.count==0)
    {
        self.lesson_nothingImgView.hidden=NO;
    }
    else
    {
        self.lesson_nothingImgView.hidden=YES;
    }
    [self requestAction];
}

-(UIButton *)guide_playbackButton
{
    if (_guide_playbackButton==nil)
    {
    self.guide_playbackButton=[UIButton buttonWithType:UIButtonTypeCustom];
    self.guide_playbackButton.frame=CGRectMake(0, 0, lSCREEN_WIDTH, lSCREEN_HEIGHT);
    }
    return _guide_playbackButton;
}
-(void)loadGuideView
{
    if (![lUSER_DEFAULT objectForKey:key_FirsrtEnter])
    {
        [self.guide_playbackButton setImage:[UIImage imageNamed:@"guide_guide1"]forState:UIControlStateNormal];
        [self.guide_playbackButton addTarget:self action:@selector(nextActionWithButton:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:self.guide_playbackButton];
    }
}
-(void)nextActionWithButton:(UIButton *)button
{
    self.guideNum++;
    if ( self.guideNum==4)
    {
        [self.guide_playbackButton removeFromSuperview];
        [lUSER_DEFAULT setObject:@"firstEnterApp" forKey:key_FirsrtEnter];
    }
     [self.guide_playbackButton setImage:[UIImage imageNamed:[NSString stringWithFormat:@"guide_guide%d",  self.guideNum]]forState:UIControlStateNormal];

}

-(void)requestAction
{
    [self lessonListRequestWithType:1];
}

#pragma mark 临时课堂
- (IBAction)tempClassAction:(id)sender {
    UIStoryboard * s =[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    TempClassViewController *vc=   [s instantiateViewControllerWithIdentifier:@"tempClass"];
    vc.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    [vc.view setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.5f]];
    vc.enterTempClassBlockDoing = ^(TempClassModel *tempModel) {
                    self.isTempClass =YES;
                    self.tempModel=tempModel;
//                    self.selectInfoModel.schedule_id =self.tempModel.schedule_id;
                 [self enterTempClassWithTempClass:tempModel];
    };
    [self presentViewController:vc animated:YES completion:nil];

}


-(void)enterTempClassWithTempClass:(TempClassModel *)tempModel{
    if (self.isJoining) {
        return;
    }
    LiveRoom *tempRoom =[[LiveRoom alloc] init];
    tempRoom.selectInfoModel=self.selectInfoModel;
    self.selectInfoModel.schedule_id=tempModel.schedule_id;
    tempRoom.liveroomModel=self.liveroomModel;
    tempRoom.tempModel =tempModel;
    WCRClassJoinInfo *joinInfo= [tempRoom configTempLiveRoomInfo];
    self.classRoom = [[WCRClassRoom alloc] init];
    self.classRoom.delegate = self;
    [self.classRoom joinRoom: joinInfo];
    self.isJoining=YES;
    
}


#pragma mark  编辑用户信息
- (IBAction)editUserInfoAction:(id)sender {
    WeakSelf(self);
    PersonViewController* personVC =lStoryboard(@"Main", @"person");
    personVC.comebackAction = ^{
        [weakself dismissViewControllerAnimated:NO completion:nil];
    };
    personVC.editNickNameBlock = ^(NSString *nickName, UIImage *avarImage) {
          weakself.studentNameLabel.text=nickName;
        weakself.student_advatarImageView.image =avarImage;
    };
    [self presentViewController:personVC animated:YES completion:nil];
}
#pragma mark 获取用户信息
-(void)ConfigUserInfo{
    NSDictionary *userInfoDict=[RapidStorageClass readDictionaryDataArchiverWithKey:@"userInfo"];
    NSDictionary *userInfo=userInfoDict[@"output"][@"user"];
    NSString * advatar_url=userInfo[@"avatar"];
    self.studentNameLabel.text=userInfo[@"nick"];
    [self.studentNameLabel setAdjustsFontSizeToFitWidth:YES];
    [self.student_advatarImageView sd_setImageWithURL:[NSURL URLWithString:advatar_url] placeholderImage:[UIImage imageNamed:@"lesson_adavtar"]options:SDWebImageAllowInvalidSSLCertificates];
}


-(void)configScrollView
{
    WeakSelf(self);
    if (self.lessonListArrary.count ==0)
    {
        self.lesson_bgImageView.image=[UIImage imageNamed:@"lesson_nothing_background"];
        self.lesson_nothingImgView.hidden =NO;
    }else
    {
   
        self.lesson_bgImageView.image=[UIImage imageNamed:@"lesson_background"];
        self.lesson_nothingImgView.hidden =YES;
    }
    
    CGFloat itemWith =self.lesson_scrollView.frame.size.width/2;
    CGFloat itemHeight=386;
    NSInteger pagesNum= ceil(self.lessonListArrary.count/2.0);
    NSInteger count =self.lessonListArrary.count;
    CGFloat contentSize= self.lesson_scrollView.frame.size.width*pagesNum;
    self.totalNum=pagesNum;
   self.lesson_scrollView.contentSize=CGSizeMake(contentSize,itemHeight);
    [self.lesson_scrollView removeAllSubviews];
    for (int i=0; i<count; i++) {
        LessonItemView *itemView =[[[NSBundle mainBundle] loadNibNamed:@"LessonItemView" owner:self options:0] lastObject];
       CGFloat y= i%2==0?0:self.lesson_scrollView.frame.size.height -itemHeight;
        itemView.frame=CGRectMake(itemWith*i ,y, itemWith, itemHeight);
        itemView.tag =i;
      LessonInfoModel * lessModel =self.lessonListArrary[i];
      [itemView setDataWithLessonInfoModel:lessModel];
      itemView.joinLiveRoomBlock = ^(NSInteger itemTag){
       weakself.selectInfoModel=weakself.lessonListArrary[itemTag];
      [weakself joinLiveRoomWithSelectLessonInfoModel];
    };

        [self.lesson_scrollView addSubview:itemView];
    }
     [self.lesson_scrollView setContentOffset:CGPointMake(self.lesson_scrollView.frame.size.width*self.currentPage,0) animated:YES];
    
}
#pragma mark 选择的select 调用的接口
-(void)joinLiveRoomWithSelectLessonInfoModel
{
    WeakSelf(self);
    [self.lessonVM checkJoinLiveRoomWithSchedule_id:self.selectInfoModel.schedule_id];
    [self.lessonVM setBlockWithReturnBlock:^(id returnValue) {
        weakself.liveroomModel =(liveRoomModel *)returnValue;
        [weakself joinLiveRoom];
    } WithErrorBlock:^(id errorCode)
     {
    [[LAlertViewCustom sharedInstance] alertViewTitle:nil content:[NSString stringWithFormat:@"%@",errorCode] leftButtonTitle:nil rightButtonTitle:nil autoDismiss:YES rightButtonTapDoing:nil leftButtonTapORDismissDoing:nil];
         
    } WithFailureBlock:^{
        [LoadingView tipViewWithTipString:@"网络请求失败"];
    }];
}

#pragma mark 预约的课时进入直播间
-(void)joinLiveRoom
{
    if (self.isJoining)
    {
        return;
    }
    LiveRoom * room =[[LiveRoom alloc] init];
    room.selectInfoModel=self.selectInfoModel;
    room.liveroomModel=self.liveroomModel;
    WCRClassJoinInfo *joinInfo= [room configLiveRoomInfo];
    self.classRoom = [[WCRClassRoom alloc] init];
    self.classRoom.delegate = self;
    [self.classRoom joinRoom: joinInfo];
    self.isJoining=YES;
}


#pragma mark - WCRClassRoomDelegate
- (void)roomDidJoin:(BOOL)successed
{
    self.isJoining = NO;
    if(successed) {
        NSString *scheduce_id =self.isTempClass?self.tempModel.schedule_id:self.selectInfoModel.schedule_id;
        [self.lessonVM enterLivewroomSuccessCallBackWithSchedule_id:scheduce_id];
        UIViewController* classRoomViewController = self.classRoom.roomViewController;
        [self presentViewController:classRoomViewController animated:YES completion: nil];
    }else{
        [LoadingView tipViewWithTipString:@"进入教室失败"];
    }
}
#pragma mark 离开教室
- (void)roomWillLeave:(WCRLeaveRoomReason)statusCode
{
        [self hanlerLeaveLiveRoomWithStatusCode:statusCode];
}

-(void)hanlerLeaveLiveRoomWithStatusCode:(WCRLeaveRoomReason)statusCode
{
    self.prevButton.hidden =YES;
    WeakSelf(self);
    NSString *scheduce_id=self.isTempClass?self.tempModel.schedule_id:self.selectInfoModel.schedule_id;
    [self.lessonVM quitLivewroomSuccessCallBackWithSchedule_id:scheduce_id];
    
    if (statusCode==WCRLeaveRoomReasonAfterClass)
    {
    //         如果课程已经结束 则需要刷新历史记录
         self.isReshHistory=YES;
        self.prevButton.hidden =NO;
        [[LAlertViewCustom sharedInstance] alertViewTitle:@"提示" content:@"课程已经结束，请离开教室？" leftButtonTitle:@"取消" rightButtonTitle:@"确定" autoDismiss:NO rightButtonTapDoing:^{
            [weakself dismissViewControllerAnimated:YES completion:^{
                weakself.classRoom = nil;
            }];
        } leftButtonTapORDismissDoing:nil];
    }
    else{
        self.isReshHistory=NO;
        [weakself dismissViewControllerAnimated:YES completion:^{
            weakself.classRoom = nil;
        }];
    }

}

#pragma mark 帮助的回调
- (void)classroomHelpInfo:(NSDictionary *)helpInfo{
    [self helpRequestWithHelpInfo:helpInfo];
}
#pragma mark 提交帮助请求
-(void)helpRequestWithHelpInfo:(NSDictionary *)helpInfo{
    NSArray *helpInfoArr= helpInfo[@"contentinfo"];
    if (helpInfoArr.count==0){
        return;
    }
    NSDictionary *helpDict1= helpInfoArr[0];
    NSString *helpID= helpDict1[@"id"];
     NSString *text1=  helpDict1[@"text1"];
    NSDictionary *helpDict2= helpInfoArr[1];
    NSString * helpText=helpDict2[@"text1"];
    if (helpText.length==0) {
        helpText=text1;
    }
    if (self.isTempClass) {
        self.selectInfoModel.schedule_id=self.tempModel.schedule_id;
    }
    [self.lessonVM scheduleHelpsWithSchedule_id:self.selectInfoModel.schedule_id errorCode:helpID errorMsg:helpText];
    
    [self.lessonVM setBlockWithReturnBlock:^(id returnValue) {
        
    } WithErrorBlock:^(id errorCode) {
        [LoadingView tipViewWithTipString:errorCode];
    } WithFailureBlock:^{
        [LoadingView tipViewWithTipString:@"网络请求失败"];
    }];
}

#pragma mark 获取历史数据
-(void)requestHistoryLesson{
    [self lessonListRequestWithType:2];
}

#pragma mark  前一页
- (IBAction)prevPage:(id)sender {
    if (self.currentPage==0) {
        self.prevButton.hidden=YES;
        [self requestHistoryLesson];
    }
    if (self.currentPage>0) {
        self.currentPage--;
    }
    [self.lesson_scrollView setContentOffset:CGPointMake(self.lesson_scrollView.frame.size.width*self.currentPage,0) animated:YES];
    self.prevButton.hidden =[self hiddenPrevButton];
    self.nextButton .hidden =[self hiddenNextButton];
}

#pragma mark 后一页
- (IBAction)nextPage:(id)sender {
    
    self.prevButton.hidden =[self hiddenPrevButton];
    self.nextButton .hidden =[self hiddenNextButton];
    if (self.currentPage<self.totalNum-1) {
        self.currentPage++;
    }
        [self.lesson_scrollView setContentOffset:CGPointMake(self.lesson_scrollView.frame.size.width*self.currentPage,0) animated:YES];
}

#pragma mark 执行滚动的时候
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    NSInteger index = fabs(scrollView.contentOffset.x) / scrollView.frame.size.width;
    self.currentPage=index;
    self.prevButton.hidden =[self hiddenPrevButton];
    self.nextButton .hidden =[self hiddenNextButton];
}
-(void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView
{
   self. lastContentOffset = scrollView.contentOffset.x;//判断上下滑动时

}


#pragma mark 拖动的时候
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    CGFloat pageWidth=scrollView.frame.size.width;
    NSInteger index = fabs(scrollView.contentOffset.x) /pageWidth;
    self.currentPage=index;
    //判断左右滑动时
    if (scrollView.contentOffset.x < self.lastContentOffset ){

    } else if (scrollView. contentOffset.x >self. lastContentOffset ){
        //向左
        if (self.currentPage==0)
        {
            if (!self.isNotHistory)
            {
                [self requestHistoryLesson];
            }
        }
        DDLog(@"右滑");
    }

        self.prevButton.hidden =[self hiddenPrevButton];
        self.nextButton .hidden =[self hiddenNextButton];
    
}

#pragma mark 加载更多的历史记录
- (IBAction)loadMoreHistoryLesson:(id)sender {
    if (self.lessonListArrary.count==0) {
        [self lessonListRequestWithType:3];
    }

    
}

-(void)lessonListRequestWithType:(int)resq_type {
    WeakSelf(self);
    NSString * fromTime=[self recentTimeWithResqType:resq_type];
    [self.lessonVM getLessonSchedulesListWithFromTime:fromTime];
    [self.lessonVM setBlockWithReturnBlock:^(id returnValue){
        NSArray * returnArr=(NSArray *)returnValue;
        [weakself handlerLessonDataWithType:resq_type dataArr:returnArr];
    } WithErrorBlock:^(id errorCode) {
        [LoadingView tipViewWithTipString:errorCode];
    } WithFailureBlock:^{
         [LoadingView tipViewWithTipString:@"网络请求失败"];
    }];
}

-(void)handlerLessonDataWithType:(int)req_type dataArr:(NSArray*)dataArr {
    switch (req_type) {
        case 1:
            [self handlerCurrentLessonListWithListArr:dataArr];
            break;
            case 2:
            [self handlerHistoryLessonListWithListArr:dataArr];
            break;
            case 3:
            [self handlerNotCurrentLessonAndLoadMoreHistoryLesson:dataArr];
            break;
        default:
            break;
    }
}

-(NSString *)recentTimeWithResqType:(int)resq_type{
    
    NSString * fromTime;
    switch (resq_type) {
        case 1://请求待上课的列表
            fromTime=@"";
            break;
        case 2:// 请求历史列表
            fromTime =[[self.lessonListArrary firstObject] from_time];
        break;
        case 3://请求当前日期的历史列表
            fromTime =[DateTool currentDateString];
        break;
        default:
            break;
    }
    return fromTime;
}

#pragma mark 获取当前可以上课的课程
-(void)handlerCurrentLessonListWithListArr:(NSArray *)currentlessonArr{
    
    [self.lesson_scrollView removeAllSubviews];
    if (self.isReshHistory)
    {
        [self.lessonListArrary removeAllObjects];
        
    }
    else
    {
        [self.lessonListArrary removeObjectsInArray:self.currentLesson];
    }
    self.currentLesson =currentlessonArr;
    NSUInteger  location=  self.lessonListArrary.count;
    NSRange range=NSMakeRange(location, self.currentLesson.count);
    [self.lessonListArrary insertObjects: self.currentLesson atIndexes:[NSIndexSet indexSetWithIndexesInRange:range]];
        
        if (self.lessonListArrary.count==0)
        {
            [self lessonListRequestWithType:3];
            
        }else{
            self.prevButton.hidden =NO;
        }
  
    
    
    [self configScrollView];
    self.prevButton.hidden=[self hiddenPrevButton];
    self.nextButton.hidden =[self hiddenNextButton];
    
}
#pragma mark 获取历史数据
-(void)handlerHistoryLessonListWithListArr:(NSArray *)historyArr{
    if (historyArr.count!=0) {
        self.prevButton.hidden=NO;
        NSRange range=NSMakeRange(0, historyArr.count);
        [self.lessonListArrary insertObjects:historyArr atIndexes:[NSIndexSet indexSetWithIndexesInRange:range]];
        self.isNotHistory=NO;
    }
    else
    {
        self.prevButton.hidden=YES;
        self.isNotHistory=YES;
        [LoadingView tipViewWithTipString:@"没有其它的历史课堂了哦☺"];
    }
    [self configScrollView];
    self.prevButton.hidden=[self hiddenPrevButton];
    self.nextButton .hidden =[self hiddenNextButton];
}
#pragma mark  加载更多
-(void)handlerNotCurrentLessonAndLoadMoreHistoryLesson:(NSArray *)historyArr
{
    if ( self.lessonListArrary.count==0)
    {
        if (historyArr.count==0) {
            [LoadingView tipViewWithTipString:@"暂无历史课程" ];
            self.isNotHistory =YES;
            self.prevButton.hidden =YES;
        }
        else{
            [self.lessonListArrary addObjectsFromArray:historyArr];
            [self configScrollView];
            self.prevButton.hidden =NO;
        }
        self.prevButton.hidden =[self hiddenPrevButton];
        self.nextButton .hidden =[self hiddenNextButton];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(BOOL)hiddenPrevButton{
    
    if (self.lessonListArrary.count==0)
    {
         return  YES;
    }
    else
    {
            if (self.currentPage ==0)
            {
                        if (self.isNotHistory==YES)
                        {
                             return YES;
                        }else{
                            return  NO;
                        }
                
            }
            else{
                return NO;
            }

    }
    return YES;
    
}
-(BOOL)hiddenNextButton{
    if (self.lessonListArrary.count ==0)
    {
        return YES;
    }
    else
    {
            if (self.currentPage !=self.totalNum-1)
            {
                return NO;
            }
            else
            {
                return YES;
            }
    }
        return  YES;
}






@end
