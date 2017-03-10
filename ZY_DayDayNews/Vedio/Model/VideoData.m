//
//  VideoData.m
//  ZY_DayDayNews
//
//  Created by guozengying on 2017/3/7.
//  Copyright © 2017年 gzy. All rights reserved.
//

#import "VideoData.h"

@implementation VideoData
-(NSString *)ptime
{
    NSString *str1 = [_ptime substringToIndex:10];
    str1 = [str1 substringFromIndex:5];
    
    return str1;
}

@end
