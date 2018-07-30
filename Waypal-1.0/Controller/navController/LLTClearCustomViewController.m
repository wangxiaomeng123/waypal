//
//  LLTClearCustomViewController.m
//  xiaojingyu
//
//  Created by lintao li on 2017/10/17.
//  Copyright © 2017年 kekejl. All rights reserved.
//

#import "LLTClearCustomViewController.h"
#import "UINavigationBar+Awesome.h"
#import "Config.h"

@interface LLTClearCustomViewController () <UIGestureRecognizerDelegate>

@end

@implementation LLTClearCustomViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationBar.hidden =YES;

    // Do any additional setup after loading the view.
    //    1.官方设置导航透明
    UINavigationBar *nav=self.navigationController.navigationBar;
    [nav setBackgroundImage:[UIImage imageNamed:@"Nav.png"] forBarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
    [nav setShadowImage:[UIImage new]];
    WeakSelf(self);
    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.interactivePopGestureRecognizer.delegate = weakself;
    }
}

#pragma mark 创建返回按钮
-(UIBarButtonItem *)createBackButton {
    return [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"x_login_nav_backItem_icon"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(popself)];
}

#pragma mark 返回按钮
-(void)popself {
    [self popViewControllerAnimated:YES];
}
#pragma mark 重写方法
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    [super pushViewController:viewController animated:animated];
    if (viewController.navigationItem.leftBarButtonItem == nil && [self.viewControllers count] > 1) {
        viewController.navigationItem.leftBarButtonItem =[self createBackButton];
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
