//
//  GZYPlay.h
//  ZY_DayDayNews
//
//  Created by guozengying on 2017/3/6.
//  Copyright © 2017年 gzy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GZYPlay : UIView

@property (nonatomic, copy) void(^CurrentRowBlock)();
/** title */
@property (nonatomic, strong) NSString      * title;
@property (nonatomic, strong) NSString      * mp4_url;
/** 当前在cell上的播放器的 Y值 */
@property (nonatomic, assign) CGFloat        currentOriginY;

- (void)removePlayer;

@end
