//
//  Photo.h
//  ZY_DayDayNews
//
//  Created by guozengying on 2017/3/3.
//  Copyright © 2017年 gzy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Photo : NSObject

@property (nonatomic, assign) CGFloat         small_width;
@property (nonatomic, assign) CGFloat         small_height;
@property (nonatomic, copy) NSString        * small_url;
@property (nonatomic, copy) NSString        * title;

@property (nonatomic , copy) NSString       * image_url;
@property (nonatomic , assign) CGFloat        image_width;
@property (nonatomic , assign) CGFloat        image_height;

@end
