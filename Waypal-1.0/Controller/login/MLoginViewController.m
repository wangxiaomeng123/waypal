

//
//  MLoginViewController.m
//  iPad_wayPal
//
//  Created by waypal on 2018/5/16.
//  Copyright © 2018年 waypal. All rights reserved.
//

#import "MLoginViewController.h"
#import "PublicLoginViewModel.h"
#import "Config.h"
#import "LessonViewController.h"
#import "LoadingView.h"

@interface MLoginViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *login_user;
@property (weak, nonatomic) IBOutlet UITextField *login_password;
@property (weak, nonatomic) IBOutlet UILabel *errorTipLabel;
@property (weak, nonatomic) IBOutlet UIView *login_loginBgView;
@property (weak, nonatomic) IBOutlet UIView *login_userLine;
@property (weak, nonatomic) IBOutlet UIView *login_pwsLine;

@end

@implementation MLoginViewController
-(void)viewWillAppear:(BOOL)animated
{
  //    1.官方设置导航透明
    UINavigationBar *nav=self.navigationController.navigationBar;
    [nav setBackgroundImage:[UIImage imageNamed:@"Nav.png"] forBarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
    [nav setShadowImage:[UIImage new]];
    self.login_user.text=[lUSER_DEFAULT objectForKey:Key_RemberUserAccount]?[lUSER_DEFAULT objectForKey:Key_RemberUserAccount]:@"";
}
- (void)setStatusBarBackgroundColor:(UIColor *)color {
    
    UIView *statusBar = [[[UIApplication sharedApplication] valueForKey:@"statusBarWindow"] valueForKey:@"statusBar"];
    if ([statusBar respondsToSelector:@selector(setBackgroundColor:)]) {
        statusBar.backgroundColor = color;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.login_user.delegate=self;
    self.login_password.delegate =self;
    self.view.backgroundColor =[UIColor colorWithPatternImage:[UIImage imageNamed:@"background@2x"]];


}

- (IBAction)loginAction:(id)sender {
    
    NSString *userName =self.login_user.text;
    NSString *password =self.login_password.text;
    if (userName.length==0) {
       self.errorTipLabel.text=@"请输入用户名";
        return;
    }
    if (password.length ==0) {
        self.errorTipLabel.text=@"请输入密码";
        return;
    }
    
    PublicLoginViewModel *loginVM =[[PublicLoginViewModel alloc] init];
    [loginVM loginWithUserName:userName password:password];
    
    [loginVM setBlockWithReturnBlock:^(id returnValue) {
        DDLog(@"returnValue:%@",returnValue);
        [self enterLessonListViewController];
        
    } WithErrorBlock:^(id errorCode) {
        self.errorTipLabel.text=[NSString stringWithFormat:@"%@",errorCode];
    } WithFailureBlock:^{
        [LoadingView tipViewWithTipString:@"数据请求失败"];
    }];
    
}
#pragma mark  进入课程列表页
-(void)enterLessonListViewController
{
    WeakSelf(self);
     UIStoryboard * s =[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    LessonViewController *lessonVC=  [s instantiateViewControllerWithIdentifier:@"Lesson"];
    lessonVC.comebackAction = ^{
        [weakself dismissViewControllerAnimated:NO completion:nil];
    };
    [[UIApplication sharedApplication]keyWindow ].rootViewController =lessonVC;
 
}

- (IBAction)forgetPasswordAction:(id)sender {
    
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    if ([textField isEqual:self.login_user])
    {
        self.login_userLine.backgroundColor=[UIColor colorWithHexString:@"#FF8F00"];
    }
    else if ([textField isEqual:self.login_password])
    {
      self.login_pwsLine.backgroundColor=[UIColor colorWithHexString:@"#FF8F00"];
    }

}
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    if ([textField isEqual:self.login_user ])
    {
        self.login_userLine.backgroundColor=[UIColor colorWithHexString:@"#ACACAC"];
    }
    else if ([textField isEqual:self.login_password])
    {
        self.login_pwsLine.backgroundColor=[UIColor colorWithHexString:@"#ACACAC"];
    }
}

- (IBAction)registerAction:(id)sender {
    
 UIViewController *registerVC=   lStoryboard(@"Main", @"register");
 [self  presentViewController:registerVC animated:YES completion:nil];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
