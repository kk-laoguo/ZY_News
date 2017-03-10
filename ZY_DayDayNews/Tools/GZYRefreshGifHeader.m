//
//  GZYRefreshGifHeader.m
//  ZY_DayDayNews
//
//  Created by guozengying on 2017/3/7.
//  Copyright © 2017年 gzy. All rights reserved.
//

#import "GZYRefreshGifHeader.h"



@implementation GZYRefreshGifHeader

- (void)prepare{
    [super prepare];
    
    //设置普通状态的动画图片
    NSMutableArray * normalArr = [NSMutableArray arrayWithCapacity:0];
    for (NSInteger i = 1; i <= 60; i ++) {
        UIImage * image = [UIImage imageNamed:[NSString stringWithFormat:@"dropdown_anim__000%zd",i]];
        [normalArr addObject:image];
    }
    [self setImages:normalArr forState:MJRefreshStateIdle];
    
    //设置即将刷新状态的动画图片 (一松开就会刷新的状态)
    NSMutableArray * refreshArr = [NSMutableArray arrayWithCapacity:0];
    for (NSInteger i = 1; i <=3 ; i ++) {
       UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"dropdown_loading_0%zd", i]];
        [refreshArr addObject:image];
    }
    [self setImages:refreshArr forState:MJRefreshStatePulling];
    
    // 设置正在刷新状态的动画图片
    [self setImages:refreshArr forState:MJRefreshStateRefreshing];
}

@end
