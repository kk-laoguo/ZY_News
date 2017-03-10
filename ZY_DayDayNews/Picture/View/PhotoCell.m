//
//  PhotoCell.m
//  ZY_DayDayNews
//
//  Created by guozengying on 2017/3/3.
//  Copyright © 2017年 gzy. All rights reserved.
//

#import "PhotoCell.h"
#import "Photo.h"
@implementation PhotoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setPhoto:(Photo *)photo{
    _photo = photo;
    [self.photoImageView sd_setImageWithURL:[NSURL URLWithString:photo.small_url] placeholderImage:nil];
    self.titleLab.text = photo.title;
}

@end
