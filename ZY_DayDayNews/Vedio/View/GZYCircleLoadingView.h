//
//  GZYCircleLoadingView.h
//  ZY_DayDayNews
//
//  Created by guozengying on 2017/3/6.
//  Copyright © 2017年 gzy. All rights reserved.
//

#import <UIKit/UIKit.h>
//加载视图类
@interface GZYCircleLoadingView : UIView

/**
 *  初始化设置 默认size为40，线宽为3,如果不需要修改，则调用
 *  第一个方法，直接设置view的frame即可。如果需要修改，则调用第二个方法，设置颜色，宽度，尺寸
 */
- (instancetype)initWithViewFrame:(CGRect)frame;
- (instancetype)initWithViewFrame:(CGRect)frame tintColor:(UIColor *)tintColor size:(CGFloat)size lineWidth:(CGFloat)lineWidth;


/**  进度   */
@property (nonatomic, assign) CGFloat        progress;
/**  是否显示进度   */
@property (nonatomic, assign) BOOL           isShowProgress;
/**
 * 开始动画, 初始化完成之后就可以调用start
 */
- (void)startAnimation;
/**
 *  结束动画，内部已经隐藏视图，移除动画了，不需要外部再次设置
 */
- (void)stopAnimation;

@end
