//
//  ZYCycleBannerView.h
//  ZY_DayDayNews
//
//  Created by guozengying on 2017/2/24.
//  Copyright © 2017年 gzy. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^clickBannerBlock)(NSInteger currentIndex);
typedef NS_ENUM(NSUInteger, ZYPageControlStyle){//pageControll样式
    pageControl_Left,
    pageControl_Center,
    pageControl_Right
};

@interface ZYCycleBannerView : UIView
//点击图片回调
@property (nonatomic, copy) clickBannerBlock      clickBlock;
//图片
@property (nonatomic, strong) NSMutableArray    * imgArr;
//文本
@property (nonatomic, strong) NSMutableArray    * titleArr;
//当前pageControl的颜色
@property (nonatomic, strong) UIColor           * currentPageControlColor;
//未选中pageControl的颜色
@property (nonatomic, strong) UIColor           * otherPageControlColor;
//是否自动滑动, 默认 Yes
@property (nonatomic, assign) BOOL                autoScroll;
//是否显示pageControl, 默认 Yes
@property (nonatomic, assign) BOOL                showPageControl;
//pageControll默认距右
@property (nonatomic, assign) ZYPageControlStyle   pageStyle;

@end
