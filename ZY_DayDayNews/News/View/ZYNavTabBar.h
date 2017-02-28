//
//  ZYNavTabBar.h
//  ZY_DayDayNews
//
//  Created by guozengying on 2017/2/23.
//  Copyright © 2017年 gzy. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ZYNavTabBarDelegate <NSObject>

@optional

- (void)itemDidSelectedIndex:(NSInteger)index currentIndex:(NSInteger)currentIndex;


@end


@interface ZYNavTabBar : UIView

@property (nonatomic, assign) id <ZYNavTabBarDelegate>delegate;
@property (nonatomic, assign) NSInteger currtentItemIndex; //当前选中item的索引
@property (nonatomic, strong) NSArray * itmeTitleArr; //item标题数组
@property (nonatomic, strong) UIColor * lineColor; //顶部线的颜色

@end
