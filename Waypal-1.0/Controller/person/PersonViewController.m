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
#import "UpLoadHeadManager.h"
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
@property (weak, nonatomic) IBOutlet UIView *person_infoBgView;
@property (nonatomic,strong)SettingView * settingV;
@property (weak, nonatomic) IBOutlet UIView *editLine;
@property (nonatomic,strong) NSString * avatarImagePath;
@end

@implementation PersonViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.person_UserNameTF.delegate=self;
    self.person_nameTF.delegate =self;
    lViewBorderRadius(self.person_avatarImgView, 60, 2,[UIColor whiteColor]);
    [self userInfo];
    [self showSettingView];
    [self addTapGestureInAvatarImgView];
    [self defaultShowResource];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(uploadSucess:) name:@"uploadSuccess" object:nil];
    
}
-(void)uploadSucess:(NSNotification *)nofi{
    DDLog(@"上传成功");
    self.avatarImagePath= nofi.userInfo[@"imagePath"];
}
#pragma mark 初始化settingview
-(void)showSettingView{
    WeakSelf(self);
    self.settingV =[[[NSBundle mainBundle]loadNibNamed:@"SettingView" owner:self options:0] lastObject];
    self.settingV.frame=CGRectMake(0, 0, self.person_infoBgView.frame.size.width, self.person_infoBgView.frame.size.height);
    [self.person_infoBgView addSubview: self.settingV];
    self.settingV.upVersionBlock = ^(NSString *currentVersion) {
        [weakself updateAppVersion];
    };
    self.settingV.loginOutBlock = ^{
        [weakself loginOut];
    };
}

#pragma mark 默认选择的我的资料
-(void)defaultShowResource
{
    self.selectedBtn =self.person_sourceBtn;
    self.settingV.hidden =YES;
    self.person_avatarImgView.userInteractionEnabled =NO;
    
}
-(void)userInfo{
    NSDictionary *userInfoDict=[RapidStorageClass readDictionaryDataArchiverWithKey:@"userInfo"];
    NSDictionary *userInfo=userInfoDict[@"output"][@"user"];
    self.person_nameTF.text =[NSString stringWithFormat:@"%@",userInfo[@"nick"]];
    self.person_UserNameTF.text =[NSString stringWithFormat:@"%@",userInfo[@"username"]];
    NSString * advatar_url=userInfo[@"avatar"];
    [self.person_avatarImgView sd_setImageWithURL:[NSURL URLWithString:advatar_url] placeholderImage:[UIImage imageNamed:@"lesson_adavtar"]options:SDWebImageAllowInvalidSSLCertificates];
    
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
        if (self.person_editBtn.selected==YES) {
            [self editAction:self.person_editBtn];
        }
        self.person_ResourceBgView.hidden =YES;
        self.settingV.hidden=NO;
    }
}


- (IBAction)editAction:(UIButton *)sender {
    sender.selected=!sender.selected;
    NSString * title=sender.selected?@"完成":@"编辑资料";
    [sender setTitle:title forState:UIControlStateNormal];
    self.person_nameTF.enabled = sender.selected?YES:NO;
    self.person_avatarImgView.userInteractionEnabled =sender.selected?YES:NO;
    if (!sender.selected){
        [self finishEditUserInfo];
        self.editLine.backgroundColor=[UIColor clearColor];
        
    }else{
        self.editLine.backgroundColor=[UIColor colorWithHexString:@"#FE9319"];
    }
}
-(void)finishEditUserInfo{
    NSString * nick =self.person_nameTF.text;
    NSString * name=self.person_UserNameTF.text;
    NSString *password=@"";
    PersonViewModel *personVM =[[PersonViewModel alloc ] init];
    if (self.avatarImagePath.length==0) {
        NSDictionary *userInfoDict=[RapidStorageClass readDictionaryDataArchiverWithKey:@"userInfo"];
        NSDictionary *userInfo=userInfoDict[@"output"][@"user"];
        NSString * advatar_url=userInfo[@"avatar"];
        self.avatarImagePath= advatar_url;
    }
    [personVM editUserInfoWithName:name nick:nick password:password avatarImagePath:self.avatarImagePath];
    [personVM setBlockWithReturnBlock:^(id returnValue) {
        [LoadingView tipViewWithTipString:@"信息保存成功"];
        
    } WithErrorBlock:^(id errorCode) {
        [LoadingView tipViewWithTipString:errorCode];
        
    } WithFailureBlock:^{
        [LoadingView tipViewWithTipString:@"网络请求失败"];
    }];
}

- (IBAction)backAction:(id)sender {
    WeakSelf(self);
    [self dismissViewControllerAnimated:YES completion:^{
        if (weakself.editNickNameBlock) {
            weakself.editNickNameBlock(self.person_nameTF.text,self.person_avatarImgView.image);
        }
    }];
}

//退出登录
-(void)loginOut
{
    [CustomAlterView showAlterViewWithTitle:@"提示" message:@"是否退出登录？" rightBtnText:@"确定" leftBtnText:@"取消" rightBtnBlock:^{
        UIViewController *loginVC =lStoryboard(@"Main", @"login");
        [RapidStorageClass deleteDictionaryDataArchiverWithKey:Key_LOGININFORMATION];
        [RapidStorageClass deleteToken];
        LLTClearCustomViewController *nav=[[LLTClearCustomViewController alloc]initWithRootViewController:loginVC];
        [[UIApplication sharedApplication]keyWindow].rootViewController =nav;
    } leftBtnBlock:nil presentViewController:self];
}
-(void)updateAppVersion{
    [self checkUpdateVersion];
}

- (void)checkUpdateVersion
{
    NSDictionary *versionDict=[[AppVersionModel shareInstance]VersionInfoDict] ;
    NSDictionary *infoDic=[[NSBundle mainBundle] infoDictionary];
    __block NSString *currentVersion=infoDic[@"CFBundleShortVersionString"];
    if (!versionDict)
    {
        return;
    }
    if ([versionDict[@"is_upgrade"] intValue]==1)
    {
        NSString *contentString = versionDict[@"message"];
        [[LAlertViewCustom sharedInstance] alertViewTitle:@"有新版本喽" content:contentString leftButtonTitle:@"取消" rightButtonTitle:@"前往更新" autoDismiss:NO rightButtonTapDoing:^{
       
//itms-apps://itunes.apple.com/cn/app/waypal/id1390222146?mt=8
            NSString * appStoreURL=versionDict[@"download_url"];
            if (@available(iOS 10.0, *)) {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:appStoreURL] options:@{} completionHandler:nil];
            } else {
                [[UIApplication sharedApplication]openURL:[NSURL URLWithString:appStoreURL]];
            }
        } leftButtonTapORDismissDoing:nil];
    }
    else{
        [[LAlertViewCustom sharedInstance] alertViewTitle:@"版本信息" content:[NSString stringWithFormat:@"当前最新版本"] leftButtonTitle:nil rightButtonTitle:@"好" autoDismiss:NO rightButtonTapDoing:nil  leftButtonTapORDismissDoing:nil];
        
    }
}

-(void)addTapGestureInAvatarImgView
{
    UITapGestureRecognizer * tap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(changeAvatarImgView:)];
    tap.numberOfTapsRequired=1;
    self.person_avatarImgView.userInteractionEnabled=YES;
    [self.person_avatarImgView addGestureRecognizer:tap];
}
-(void)changeAvatarImgView:(UITapGestureRecognizer*)tap
{
    //调起actionsheet 选择上传方式
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"选择照片" message:nil preferredStyle: UIAlertControllerStyleActionSheet];
    UIAlertAction *deleteAction = [UIAlertAction actionWithTitle:@"相机" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [[UpLoadHeadManager sharedInstance] clUploadHeadImageWithMethed:1 withBlock:^(UIImage *obj, NSString *imagePath) {
            self.person_avatarImgView.image=obj;
        }];
    }];
    UIAlertAction *saveAction = [UIAlertAction actionWithTitle:@"从相册选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        [[UpLoadHeadManager sharedInstance] clUploadHeadImageWithMethed:2 withBlock:^(UIImage *obj, NSString *imagePath) {
            self.person_avatarImgView.image=obj;
            self.avatarImagePath =imagePath;
        }];
    }];
    UIPopoverPresentationController *popover = alertController.popoverPresentationController;
    if (popover) {
        popover.sourceView = self.person_avatarImgView;
        popover.sourceRect = self.person_avatarImgView.bounds;
        popover.permittedArrowDirections = UIPopoverArrowDirectionAny;
    }
    
    [UpLoadHeadManager sharedInstance].successBlock = ^(UIImage *obj, NSString *imagePath) {
        self.avatarImagePath=imagePath;
        self.person_avatarImgView.image=obj;
    };
    [alertController addAction:deleteAction];
    [alertController addAction:saveAction];
    [self presentViewController:alertController animated:YES completion:nil];
    
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
        self.person_nameTF.textColor =[UIColor colorWithHexString:@"#FE9319"];
        self.person_nameLabel.textColor=[UIColor colorWithHexString:@"#FE9319"];
        
    }
}
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField ==self.person_nameTF) {
        self.editLine.backgroundColor =[UIColor clearColor];
        self.person_nameTF.textColor =[UIColor colorWithHexString:@"#FE9319"];
        self.person_nameLabel.textColor=[UIColor colorWithHexString:@"#923BA8"];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
