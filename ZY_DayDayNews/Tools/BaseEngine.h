//
//  BaseEngine.h
//  ZY_DayDayNews
//
//  Created by guozengying on 2017/2/28.
//  Copyright © 2017年 gzy. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef void (^successBlock)(id responseobject);
typedef void (^failBlock)(id error);

@interface BaseEngine : NSObject
+ (instancetype)shareEngine;
/** 销毁单例类 */
- (void)clear;

- (void)getRequestWithPara:(NSMutableDictionary *)para
                       url:(NSString *)url
                       success:(successBlock)successBolck
                       error:(failBlock)failBlock;

@end
