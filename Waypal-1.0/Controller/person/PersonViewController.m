//
//  PersonViewController.m
//  iPad_wayPal
//
//  Created by waypal on 2018/5/17.
//  Copyright © 2018年 waypal. All rights reserved.
//

#import "PersonViewController.h"
#import "PersonViewModel.h"
#import "SettingView.h"
#import "CustomAlterView.h"
#import "AppVersionModel.h"
#import "Config.h"
#import "LLTClearCustomViewController.h"
@interface PersonViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *person_avatarImgView;
@property (weak, nonatomic) IBOutlet UITextField *person_UserNameTF;
@property (weak, nonatomic) IBOutlet UITextField *person_nameTF;
@property (weak, nonatomic) IBOutlet UIButton *person_editBtn;
@property (weak, nonatomic) IBOutlet UILabel *person_nameLabel;//nick
@property (weak, nonatomic) IBOutlet UIButton *person_sourceBtn;
@property (weak, nonatomic) IBOutlet UIButton *person_settingBtn;
@property (weak, nonatomic) IBOutlet UIView *peroson_bgView;
@property (weak, nonatomic) IBOutlet UIImageView *person_bgImageView;
@property (nonatomic,strong)UIButton *selectedBtn;
@property (weak, nonatomic) IBOutlet UIView *person_ResourceBgView;
@property (weak, nonatomic) IBOutlet UILabel *student_nickNameLabel;
@property (weak, nonatomic) IBOutlet UIView *person_infoBgView;
@property (nonatomic,strong)SettingView * settingV;
@property (weak, nonatomic) IBOutlet UIView *editLine;
@end

@implementation PersonViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    WeakSelf(self);
    self.person_nameLabel.transform = CGAffineTransformMakeRotation(-M_PI*1/6);
    self.person_UserNameTF.delegate=self;
    self.person_nameTF.delegate =self;
    
    self.person_avatarImgView.layer.borderColor =[UIColor whiteColor].CGColor;
    [self userInfo];
    self.settingV =[[[NSBundle mainBundle]loadNibNamed:@"SettingView" owner:self options:0] lastObject];
     self.settingV.frame=CGRectMake(0, 0, self.person_infoBgView.frame.size.width, self.person_infoBgView.frame.size.height);
    [self.person_infoBgView addSubview: self.settingV];
    self.settingV.upVersionBlock = ^(NSString *currentVersion) {
        [weakself updateAppVersion];
    };
    self.settingV.loginOutBlock = ^{
        [weakself loginOut];
    };
    [self defaultShowResource];
    
    
    
}
#pragma mark 默认选择的我的资料
-(void)defaultShowResource
{
    self.selectedBtn =self.person_sourceBtn;
    self.settingV.hidden =YES;
    self.person_settingBtn.transform = CGAffineTransformMakeScale(0.5, 0.5);
}
-(void)userInfo{
    NSDictionary *userInfoDict=[RapidStorageClass readDictionaryDataArchiverWithKey:@"userInfo"];
    NSDictionary *userInfo=userInfoDict[@"output"][@"user"];
    self.person_nameTF.text =[NSString stringWithFormat:@"%@",userInfo[@"nick"]];
    self.person_nameLabel.text =[NSString stringWithFormat:@"%@",userInfo[@"nick"]];
    self.person_UserNameTF.text =[NSString stringWithFormat:@"%@",userInfo[@"username"]];
}
- (IBAction)sourceAndSettingChangeAction:(UIButton *)sender
{
    if (sender!= self.selectedBtn) {
        self.selectedBtn.selected = NO;
        sender.selected = YES;
        self.selectedBtn = sender;
    }else{
        self.selectedBtn.selected = YES;
    }
    if (self.selectedBtn==self.person_sourceBtn)
    {
       self.person_ResourceBgView.hidden =NO;
       self.settingV.hidden=YES;
      
    }
    else if (self.selectedBtn==self.person_settingBtn){
        self.person_ResourceBgView.hidden =YES;
        self.settingV.hidden=NO;
    }
    [self changeViewButtonWithButton];
    
 
}


- (IBAction)editAction:(UIButton *)sender {
    sender.selected=!sender.selected;
    NSString * title=sender.selected?@"完成":@"编辑资料";
    [sender setTitle:title forState:UIControlStateNormal];
    self.person_nameTF.enabled = sender.selected?YES:NO;
    self.person_nameLabel.text =self.person_nameTF.text;
    if (!sender.selected){
        [self finishEditUserInfo];
        self.editLine.backgroundColor=[UIColor clearColor];

    }else{
        self.editLine.backgroundColor=[UIColor whiteColor];
    }
}
-(void)finishEditUserInfo{
    NSString * nick =self.person_nameTF.text;
    NSString * name=self.person_UserNameTF.text;
    NSString *password=@"";
    PersonViewModel *personVM =[[PersonViewModel alloc ] init];
    [personVM editUserInfoWithName:name nick:nick password:password];
    [personVM setBlockWithReturnBlock:^(id returnValue) {
        [LoadingView tipViewWithTipString:@"信息保存成功"];
    } WithErrorBlock:^(id errorCode) {
        [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"%@",errorCode]];

    } WithFailureBlock:^{
         [LoadingView tipViewWithTipString:@"网络请求失败"];
    }];
}

- (IBAction)backAction:(id)sender {
    WeakSelf(self);
       [self dismissViewControllerAnimated:YES completion:^{
        if (weakself.editNickNameBlock) {
            weakself.editNickNameBlock(weakself.person_nameLabel.text);
        }
    }];
}

-(void)changeViewButtonWithButton{
    if (self.selectedBtn ==self.person_sourceBtn) {
        [UIView animateWithDuration:0.5 animations:^{
             self.person_sourceBtn.transform = CGAffineTransformMakeScale(1, 1);
        }];
     }
    else
    {
        [UIView animateWithDuration:0.5 animations:^{
        self.person_sourceBtn.transform = CGAffineTransformMakeScale(0.5, 0.5);
        }];
    }
    if (self.selectedBtn==self.person_settingBtn) {
        [UIView animateWithDuration:0.5 animations:^{
            self.person_settingBtn.transform = CGAffineTransformMakeScale(1, 1);
        }];
    }
    else
    {
        [UIView animateWithDuration:0.5 animations:^{
            self.person_settingBtn.transform = CGAffineTransformMakeScale(0.5, 0.5);
        }];
    }
}
//退出登录
-(void)loginOut
{
    [CustomAlterView showAlterViewWithTitle:@"提示" message:@"是否退出登录？" rightBtnText:@"确定" leftBtnText:@"取消" rightBtnBlock:^{
        UIViewController *loginVC =lStoryboard(@"Main", @"login");
      [RapidStorageClass deleteDictionaryDataArchiverWithKey:Key_LOGININFORMATION];
        [lUSER_DEFAULT removeObjectForKey:ACCESSTOKEN];
        LLTClearCustomViewController *nav=[[LLTClearCustomViewController alloc]initWithRootViewController:loginVC];
       [[UIApplication sharedApplication]keyWindow].rootViewController =nav;
    } leftBtnBlock:nil presentViewController:self];
 
}
-(void)updateAppVersion{
    [self checkUpdateVersion];
   
}



/**
 output =     {
 "download_url" = "";
 "is_upgrade" = 1;
 };
 */
- (void)checkUpdateVersion
{
    NSDictionary *versionDict=[[AppVersionModel shareInstance]VersionInfoDict] ;
        if (!versionDict)
    {
        return;
    }
    if ([versionDict[@"is_upgrade"] intValue]==1)
    {
        NSString *contentString = versionDict[@"message"];
        [[LAlertViewCustom sharedInstance] alertViewTitle:@"有新版本喽" content:contentString leftButtonTitle:@"取消" rightButtonTitle:@"前往更新" autoDismiss:NO rightButtonTapDoing:^{
   
            if (@available(iOS 10.0, *)) {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:versionDict[@"download_url"]] options:@{} completionHandler:nil];
            } else {
                [[UIApplication sharedApplication]openURL:versionDict[@"download_url"]];
            }
            
        } leftButtonTapORDismissDoing:nil];
    }
    else{
        [[LAlertViewCustom sharedInstance] alertViewTitle:@"版本信息" content:@"当前为最新版本" leftButtonTitle:nil rightButtonTitle:@"好" autoDismiss:NO rightButtonTapDoing:nil  leftButtonTapORDismissDoing:nil];
    }
}




- (IBAction)changeNicknameAction:(id)sender {
    if (self.person_nameTF.text.length>8) {
        self.person_nameTF.text =[self.person_nameTF.text substringToIndex:8];
    }
    
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (textField ==self.person_nameTF) {
        self.editLine.backgroundColor =[UIColor colorWithHexString:@"#FF8F00"];
    }
}
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField ==self.person_nameTF) {
        self.editLine.backgroundColor =[UIColor whiteColor];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
