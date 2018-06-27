


//
//  TempClassViewController.m
//  iPad_wayPal
//
//  Created by waypal on 2018/5/18.
//  Copyright © 2018年 waypal. All rights reserved.
//

#import "TempClassViewController.h"
#import "HSFCodeInputView.h"
#import "LessonViewModel.h"
#import "Config.h"
@interface TempClassViewController ()<HSFCodeInputViewDelegate>
@property (weak, nonatomic) IBOutlet UIView *iuptCodeBgView;
@property(nonatomic,strong)NSString * tempCodeStr;
@property (nonatomic,strong)LessonViewModel *lessViewModel;
@property (nonatomic,strong) TempClassModel * tempModel;//临时教室的配置model

@end

@implementation TempClassViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.lessViewModel=[[LessonViewModel alloc] init];
    [self configPasswordUI];
}

-(void)configPasswordUI{
    //每位 验证码／密码 位置信息
    CGFloat codeBgWH = 52;
    CGFloat codeBgPadding = (self.iuptCodeBgView.frame.size.width-codeBgWH*4)/3;
    //验证码个数
    NSInteger numberOfVertificationCode = 4;
    
    //验证View大小
    CGFloat inputViewWidth = codeBgWH * 4 + codeBgPadding *3;
    CGFloat inputViewHeight = codeBgWH;
    
    HSFCodeInputView *inputView = [[HSFCodeInputView alloc]initWithFrame:CGRectMake(0, 0, inputViewWidth, inputViewHeight)];
    inputView.delegate = self;
    inputView.numberOfVertificationCode = numberOfVertificationCode;
    inputView.type=HSFCodeInputViewType_Login;
    //是否密码模式
    inputView.secureTextEntry = NO;
    [self.iuptCodeBgView addSubview:inputView];
}



#pragma mark 请求进入临时直播间的数据
-(void)requestEnterTempClassData{
        WeakSelf(self);
    TempClassModel * model=[[TempClassModel alloc] init];
    [self.lessViewModel enterTempClassRoomWithRoomPassword:self.tempCodeStr];
    [self.lessViewModel setBlockWithReturnBlock:^(id returnValue) {
            NSDictionary * infoDict =(NSDictionary*)returnValue;
            [model setValuesForKeysWithDictionary:infoDict];
            weakself.tempModel =model;
        if (weakself.enterTempClassBlockDoing)
        {
            weakself.enterTempClassBlockDoing(weakself.tempModel);
        }
        [weakself dismissViewControllerAnimated:YES completion:nil];
        
    } WithErrorBlock:^(id errorCode) {
        [LoadingView tipViewWithTipString:errorCode];
        
    } WithFailureBlock:^{
        [LoadingView tipViewWithTipString:@"网络请求失败"];
    }];
}
#pragma mark 点击确定
- (IBAction)sureAction:(id)sender {
    [self requestEnterTempClassData];
}
- (IBAction)colseAction:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark  delegate
-(void)codeInputView:(HSFCodeInputView *)inputView code:(NSString *)code
{
    self.tempCodeStr=code;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
