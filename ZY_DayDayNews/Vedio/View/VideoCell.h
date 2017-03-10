//
//  VideoCell.h
//  ZY_DayDayNews
//
//  Created by guozengying on 2017/3/7.
//  Copyright © 2017年 gzy. All rights reserved.
//

#import <UIKit/UIKit.h>
@class VideoDataFrame;
@interface VideoCell : UITableViewCell
@property (nonatomic, strong) VideoDataFrame        * videodataframe;
/** 标题 */
@property (nonatomic, strong) UILabel               * titleLabel;
/** 背景图片 */
@property (nonatomic, strong) UIImageView           * imageview;
/** 中间播放图标 */
@property (nonatomic, strong) UIImageView           * playcoverImage;
/** 时长 */
@property (nonatomic, strong) UILabel               * lengthLabel;
/** 来源图片 */
@property (nonatomic, strong) UIImageView           * playImage;
/** 来源文字 */
@property (nonatomic, strong) UILabel               * playcountLabel;
/** 时间 */
@property (nonatomic, strong) UILabel               * ptimeLabel;
/** cell底部横线 */
@property (nonatomic, strong) UIView                * lineV;

+ (instancetype)cellWithTableView:(UITableView *)tableView;


@end
