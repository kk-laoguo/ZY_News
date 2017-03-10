//
//  PhotoCell.h
//  ZY_DayDayNews
//
//  Created by guozengying on 2017/3/3.
//  Copyright © 2017年 gzy. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Photo;

@interface PhotoCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *photoImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;

@property (nonatomic, strong) Photo * photo;


@end
