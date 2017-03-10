//
//  ZYNavigationViewController.m
//  ZY_DayDayNews
//
//  Created by guozengying on 2017/2/22.
//  Copyright © 2017年 gzy. All rights reserved.
//

#import "ZYNavigationViewController.h"

@interface ZYNavigationViewController ()<UIGestureRecognizerDelegate,UINavigationControllerDelegate>

@end

@implementation ZYNavigationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationBar.barTintColor = [UIColor whiteColor];
//    __weak ZYNavigationViewController * wekSelf = self;
//    ZY_BLOCK_SELF(ZYNavigationViewController)
//    //如果是因为自定义导航按钮而导致手势返回失效，那么可以在NavigationController的viewDidLoad函数中添加如下代码：
//    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)])
//    {
//        self.interactivePopGestureRecognizer.delegate = block_self;
//        self.delegate = block_self;
//    }
    
    //全屏滑动手势
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc]initWithTarget:self.interactivePopGestureRecognizer.delegate action:@selector(handleNavigationTransition:)];
    
    pan.delegate = self;
    //禁止之前的手势
    self.interactivePopGestureRecognizer.enabled = NO;
    
    [self.view addGestureRecognizer:pan];
}



- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return [[self.viewControllers lastObject] preferredInterfaceOrientationForPresentation];
}

//消除方法警告
-(void)handleNavigationTransition:(UIPanGestureRecognizer *)pan{
    
}

#pragma mark --  拦截push，一旦进入下个视图，隐藏tabbar，自定义返回按钮
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated{
    if (self.childViewControllers.count) {//非根控制器
        viewController.hidesBottomBarWhenPushed = YES;
        viewController.navigationItem.leftBarButtonItem = [UIBarButtonItem ItemWithIcon:@"navigationbar_back_os7" highIcon:nil target:self action:@selector(back)];
    }
//    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)])
//        self.interactivePopGestureRecognizer.enabled = NO;
    
    [super pushViewController:viewController animated:animated];
}
#pragma mark -- UIGestureRecognizerDelegate
-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    //是否出发手势
    return self.childViewControllers.count > 1;
}
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer*)gestureRecognizer{
    //判断是否为rootViewController
    if (self.navigationController && self.navigationController.viewControllers.count == 1) {
        return NO;
    }
    return YES;
}

- (void)back{
    [self popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



@end
