//
//  ZYTabbarViewController.m
//  ZY_DayDayNews
//
//  Created by guozengying on 2017/2/22.
//  Copyright © 2017年 gzy. All rights reserved.
//

#import "ZYTabbarViewController.h"
#import "NewsViewController.h"
#import "PictureViewController.h"
#import "VideoViewController.h"
#import "MyViewController.h"
#import "ZYNavigationViewController.h"
@interface ZYTabbarViewController ()

@end

@implementation ZYTabbarViewController
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    for (UIView * child in self.tabBar.subviews) {
        if ([child isKindOfClass:[UIColor class]]) {
            [child removeFromSuperview];
        }
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
//    [[UITabBar appearance] setBarTintColor:[UIColor clearColor]];
//    [UITabBar appearance].translucent = YES;
    
    //背景图片为透明色
    //[[UITabBar appearance] setBackgroundImage:[self createImageWithColor:[UIColor clearColor]]];
    self.tabBar.backgroundColor = [UIColor colorWithHexString:@"ffffff" alpha:0.9];
    //设置为半透明
    self.tabBarController.tabBar.translucent = YES;
    
    [self setupViewController];
}
- (void)setupViewController{
    
    NewsViewController * newsVc = [[NewsViewController alloc] init];
    [self addChildViewController:newsVc title:@"新闻" imageName:@"tabbar_news" selectedImage:@"tabbar_news_hl"];
    PictureViewController * pictureVc = [[PictureViewController alloc] init];
    [self addChildViewController:pictureVc title:@"图片" imageName:@"tabbar_picture" selectedImage:@"tabbar_picture_hl"];
    VideoViewController * vedioVc = [[VideoViewController alloc] init];
    [self addChildViewController:vedioVc title:@"视频" imageName:@"tabbar_video" selectedImage:@"tabbar_video_hl"];
    MyViewController * myVc = [[MyViewController alloc] init];
    [self addChildViewController:myVc title:@"我的" imageName:@"tabbar_setting" selectedImage:@"tabbar_setting_hl"];
}

- (void)addChildViewController:(UIViewController *)childVc title:(NSString *)title imageName:(NSString *)imageName selectedImage:(NSString *)selectedImage{
    childVc.tabBarItem.image = [[UIImage imageNamed:imageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    childVc.tabBarItem.selectedImage = [[UIImage imageNamed:selectedImage] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    childVc.title = title;
    [childVc.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor redColor],NSFontAttributeName:[UIFont systemFontOfSize:13.f]} forState:UIControlStateSelected];
//    if ([childVc isKindOfClass:[PictureViewController class]]) {
//        CGFloat offset = 10.0;
//        //tabBar图片居中显示，不显示文字
//        childVc.title = @"";
//
//        childVc.tabBarItem.imageInsets = UIEdgeInsetsMake(offset, 0, -offset, 0);
//    }

    ZYNavigationViewController * nav = [[ZYNavigationViewController alloc] initWithRootViewController:childVc];
    nav.tabBarItem.titlePositionAdjustment = UIOffsetMake(0, -3);
    [self addChildViewController:nav];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
