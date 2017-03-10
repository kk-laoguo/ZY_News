//
//  BaseEngine.m
//  ZY_DayDayNews
//
//  Created by guozengying on 2017/2/28.
//  Copyright © 2017年 gzy. All rights reserved.
//

#import "BaseEngine.h"

static id _instance;
@implementation BaseEngine
- (void)clear{
    static dispatch_once_t onceToken;
    onceToken = 0;
}
+ (instancetype)allocWithZone:(struct _NSZone *)zone{
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [super allocWithZone:zone];
    });
    return _instance;
}
+ (instancetype)shareEngine{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
    });
    return _instance;
}
- (id)copyWithZone:(NSZone *)zone{
    return _instance;
}

- (void)getRequestWithPara:(NSMutableDictionary *)para url:(NSString *)url success:(successBlock)successBolck error:(failBlock)failBlock{
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    [manager GET:url parameters:para progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        successBolck(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failBlock(error);
    }];
    
}


@end
