//
//  ZYCycleBannerCell.m
//  ZY_DayDayNews
//
//  Created by guozengying on 2017/2/27.
//  Copyright © 2017年 gzy. All rights reserved.
//

#import "ZYCycleBannerCell.h"


@interface ZYCycleBannerCell()
@property (nonatomic, strong) UIImageView * imageView;


@end

@implementation ZYCycleBannerCell



- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        self.imageView = [[UIImageView alloc] initWithFrame:self.bounds];
        [self addSubview:self.imageView];
    }
    return self;
}

- (void)setImageViewWithUrl:(NSString *)imageUrl{
    
    if ([imageUrl hasPrefix:@"http"]) {
        [self.imageView sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:nil];
    }else{
        UIImage * image = [UIImage imageNamed:imageUrl];
        if (!image) {
            [UIImage imageWithContentsOfFile:imageUrl];
        }
        self.imageView.image = image;
    }
}
@end
