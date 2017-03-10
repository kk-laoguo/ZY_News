//
//  VDCategoryView.h
//  ZY_DayDayNews
//
//  Created by guozengying on 2017/3/6.
//  Copyright © 2017年 gzy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VDCategoryView : UIView

@property (nonatomic, copy) void(^SelectBlock)(NSInteger tag, NSString * title);

@end
