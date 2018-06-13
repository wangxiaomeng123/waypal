//
//  MRegisterViewController.m
//  Waypal-1.0
//
//  Created by waypal on 2018/6/7.
//  Copyright © 2018年 waypal. All rights reserved.
//

#import "MRegisterViewController.h"
#import "Config.h"
#import "MInspectClass.h"
#import "LoadingView.h"
#import "PublicLoginViewModel.h"
@interface MRegisterViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *phoneTF;
@property (weak, nonatomic) IBOutlet UITextField *verfiCodeTF;
@property (weak, nonatomic) IBOutlet UITextField *passwordTF;
@property (weak, nonatomic) IBOutlet UIButton *getVerfiCodeBtn;
@property (weak, nonatomic) IBOutlet UIView *phoneLine;
@property (weak, nonatomic) IBOutlet UIView *verfiCodeLine;
@property (weak, nonatomic) IBOutlet UIView *passwordLine;
@property (weak, nonatomic) IBOutlet UIButton *isDisagreeBtn;
@property(nonatomic,strong) PublicLoginViewModel *loginVModel;

@end

@implementation MRegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.loginVModel=[[PublicLoginViewModel alloc] init];
//    [self transformAnimation];
}
- (IBAction)getVerficodeAction:(id)sender {
    
    WeakSelf(self);
    NSString * phoneNum=self.phoneTF.text;
    if (   ! [MInspectClass isValidateMobile:phoneNum]) {
        [LoadingView tipViewWithTipString:@"请输入有效手机号"];
        return;
    }
    [self.loginVModel getVerficdoeWithPhoneNum:self.phoneTF.text];
    [self.loginVModel setBlockWithReturnBlock:^(id returnValue) {
     [weakself.getVerfiCodeBtn  startWithTime:60 title:@"获取验证码" countDownTitle:@"s" mainColor:nil countColor:nil];
    } WithErrorBlock:^(id errorCode) {
                [LoadingView tipViewWithTipString:[NSString stringWithFormat:@"%@",errorCode]];
    } WithFailureBlock:^{
        [LoadingView tipViewWithTipString:@"网络请求失败"];
    }];
    
}
- (IBAction)isDisagressProtocolAction:(UIButton *)sender{
    
        sender.selected=!sender.selected;
    
}
- (IBAction)registerAction:(id)sender
{
    WeakSelf(self);
    NSString * alterStr= [self alterString];
    if (alterStr.length!=0) {
        [LoadingView  tipViewWithTipString:[self alterString]];
        return;
    }
    [self.loginVModel resigterWithPhoneNum:self.phoneTF.text verficode:self.verfiCodeTF.text password:self.passwordTF.text];
    [self.loginVModel setBlockWithReturnBlock:^(id returnValue)
     {
         [lUSER_DEFAULT setObject:weakself.phoneTF.text forKey:Key_RemberUserAccount];
         [weakself dismissViewControllerAnimated:YES completion:nil];
        
    } WithErrorBlock:^(id errorCode) {
        [LoadingView tipViewWithTipString:[NSString stringWithFormat:@"%@",errorCode]];
    } WithFailureBlock:^{
        [LoadingView tipViewWithTipString:@"网络请求失败"];
    }];
    
    
    
    
    
}
- (IBAction)goToLoginAction:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(NSString *)alterString{
    
    if (self.phoneTF.text.length ==0) {
        return @"请输入手机号";
    }
    else{
        if (![MInspectClass isValidateMobile:self.phoneTF.text]) {
            return @"请输入有效手机号";
        }
    }
    if (self.verfiCodeTF.text.length ==0) {
        return @"请输入验证码";
    }
    if (self.passwordTF.text.length==0) {
        return @"请设置密码";
    }
    if (!self.isDisagreeBtn.selected) {
        return @"请同意《waypal注册协议》";
    }
    return nil;
    
}



#pragma mark === 永久闪烁的动画 ======
-(CABasicAnimation *)opacityForever_Animation:(float)time
{
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"opacity"];//必须写opacity才行。
    animation.fromValue = [NSNumber numberWithFloat:1.0f];
    animation.toValue = [NSNumber numberWithFloat:0.0f];//这是透明度。
    animation.autoreverses = YES;
//    animation.duration = time;
    animation.repeatCount = MAXFLOAT;
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    animation.timingFunction=[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];///没有的话是均匀的动画。
    return animation;
    
    
    
}

- (IBAction)textChangeAction:(UITextField*)sender {
    if (sender ==self.phoneTF) {
        if (self.phoneTF.text.length>11) {
               self.phoneTF.text =[self.phoneTF.text substringToIndex:11];
        }
     
    }
    if (sender==self.verfiCodeTF) {
        if (self.verfiCodeTF.text.length >4) {
             self.verfiCodeTF.text =[self.verfiCodeTF.text substringToIndex:4];
        }
    }
    if (sender ==self.passwordTF) {
//        self.passwordTF.text =[self.passwordTF.text substringFromIndex:8];
    }
    
    
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (textField ==self.phoneTF) {
        self.phoneLine.backgroundColor =[UIColor colorWithHexString:@"#FF8F00"];
    }
    if (textField==self.verfiCodeTF) {
        self.verfiCodeLine.backgroundColor =[UIColor colorWithHexString:@"#FF8F00"];

    }
    if (textField ==self.passwordTF) {
        self.passwordLine.backgroundColor =[UIColor colorWithHexString:@"#FF8F00"];
    }
    
}
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    
    if (textField ==self.phoneTF) {
        self.phoneLine.backgroundColor =[UIColor colorWithHexString:@"#ACACAC"];
    }
    if (textField==self.verfiCodeTF) {
        self.verfiCodeLine.backgroundColor =[UIColor colorWithHexString:@"#ACACAC"];
        
    }
    if (textField ==self.passwordTF) {
        self.passwordLine.backgroundColor =[UIColor colorWithHexString:@"#ACACAC"];
    }
    
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
