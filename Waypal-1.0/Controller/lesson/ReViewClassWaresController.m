//
//  ReViewClassWaresController.m
//  Waypal-1.0
//
//  Created by waypal on 2018/7/11.
//  Copyright © 2018年 waypal. All rights reserved.
//

#import "ReViewClassWaresController.h"
#import "LessonViewModel.h"
@interface ReViewClassWaresController ()<UIScrollViewDelegate>
@property (nonatomic,strong)NSMutableArray * imagesArrary;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property(nonatomic,assign) NSInteger currentPage;
@property (weak, nonatomic) IBOutlet UILabel *countDownTimeLabel;
@property (weak, nonatomic) IBOutlet UIView *timerTipBgView;
@property (weak, nonatomic) IBOutlet UILabel *pageNumLabel;

@end

@implementation ReViewClassWaresController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.imagesArrary =[NSMutableArray array];
    self.currentPage =0;

    LessonViewModel * model=[[LessonViewModel alloc] init];
    NSString * schedule_id=[NSString stringWithFormat:@"%@",self.lessonInfoModel.schedule_id];
    [model classwaresWithScheduleID:schedule_id];
    [model setBlockWithReturnBlock:^(id returnValue) {
        [self scrollViewWithImages:returnValue];
        
    } WithErrorBlock:^(id errorCode) {
        [LoadingView tipViewWithTipString:errorCode];
    } WithFailureBlock:^{
        [LoadingView tipViewWithTipString:@"数据请求失败"];
    }];
    
    if (self.isReview==YES) {
        self.timerTipBgView.hidden=YES;
    }
    else{
        self.timerTipBgView.hidden=YES;
        [self countDownTimeAction];
    }
  
}

- (IBAction)backAction:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)scrollViewWithImages:(NSMutableArray *)imagesArr{
    
    if (imagesArr.count==0) {
        return;
    }
    self.imagesArrary =imagesArr;
    self.pageNumLabel.text =[NSString stringWithFormat:@"%ld/%ld",self.currentPage+1,self.imagesArrary.count];
    CGFloat width=self.scrollView.frame.size.width;
    CGFloat height=self.scrollView.frame.size.height;
    self.scrollView.contentSize=CGSizeMake(width*imagesArr.count,height);
    self.scrollView.delegate =self;
    self.scrollView.bounces=NO;
    for (int i=0; i<imagesArr.count; i++) {
        NSString *imagePath= imagesArr[i][@"path"];
        UIImageView *imgV=[[UIImageView alloc] initWithFrame:CGRectMake(width*i, 0, width, height)];
        imgV.layer.cornerRadius =5;
        imgV.layer.masksToBounds =YES;
        [imgV sd_setImageWithURL:[NSURL URLWithString:imagePath] placeholderImage:[UIImage imageNamed:@""]];
        //        imgV.contentMode =UIViewContentModeScaleAspectFit;
        [self.scrollView addSubview:imgV];
    }
}
#pragma mark 上一页
- (IBAction)prePageAction:(id)sender{
    
    if (self.currentPage==0)
    {
        return;
    }
    self.currentPage--;
    [self.scrollView setContentOffset:CGPointMake(self.scrollView.size.width*self.currentPage, 0) animated:YES];
    self.pageNumLabel.text =[NSString stringWithFormat:@"%ld/%ld",self.currentPage+1,self.imagesArrary.count];
}
#pragma mark 下一页
- (IBAction)nextPageAction:(id)sender {
    if (self.imagesArrary.count==0) {
        return;
    }
    if (self.currentPage==self.imagesArrary.count-1)
    {
        return;
    }
    self.currentPage++;
    [self.scrollView setContentOffset:CGPointMake(self.scrollView.size.width*self.currentPage, 0) animated:YES];
     self.pageNumLabel.text =[NSString stringWithFormat:@"%ld/%ld",self.currentPage+1,self.imagesArrary.count];
}

#pragma mark 拖动的时候
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    CGFloat pageWidth=scrollView.frame.size.width;
    NSInteger currentPage = fabs(scrollView.contentOffset.x) /pageWidth;
    self.currentPage=currentPage;
    self.pageNumLabel.text =[NSString stringWithFormat:@"%ld/%ld",self.currentPage+1,self.imagesArrary.count];
    
}
#pragma mark
-(void)countDownTimeAction
{
    NSString *currentTime=[DateTool currentDateString];
    int mintue=[DateTool dateTimeDifferenceWithStartTime:currentTime endTime:self.lessonInfoModel.from_time];

    [DateTool countDownWithTime:mintue countDownBlock:^(int timeLeft) {
        
        DDLog(@"距离上课时间:%d",mintue);

        if (timeLeft==3)
        {
        self.timerTipBgView.hidden=NO;
        [[LAlertViewCustom sharedInstance] alertViewTitle:@"提示" content:@"还有3分钟上课啦，请进入教室哦！" leftButtonTitle:@"知道了" rightButtonTitle:nil autoDismiss:NO rightButtonTapDoing:nil leftButtonTapORDismissDoing:nil];
        }
        else if (timeLeft ==0){
            self.timerTipBgView.hidden =YES;
        }
       self.countDownTimeLabel.text=[NSString stringWithFormat:@"%d",timeLeft];
    } endBlock:^{
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
