//
//  TopData.h
//  ZY_DayDayNews
//
//  Created by guozengying on 2017/2/27.
//  Copyright © 2017年 gzy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TopData : NSObject
/**
 *  滚动条图片
 */
@property (nonatomic , copy) NSString *imgsrc;
/**
 *  滚动条标题
 */
@property (nonatomic , copy) NSString *title;
/**
 *  链接
 */
@property (nonatomic , copy) NSString *url;

@property (nonatomic, strong) NSArray * ads;



/**
 *  imgurl  详细图片
 */
@property (nonatomic , copy) NSString *imgurl;
/**
 *  详细内容
 */
@property (nonatomic , copy) NSString *note;
/**
 *  标题
 */
@property (nonatomic , copy) NSString *setname;

@property (nonatomic , copy) NSString *imgtitle;

@end
