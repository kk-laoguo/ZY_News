//
//  VideoCell.m
//  ZY_DayDayNews
//
//  Created by guozengying on 2017/3/7.
//  Copyright © 2017年 gzy. All rights reserved.
//

#import "VideoCell.h"
#import "VideoData.h"
#import "VideoDataFrame.h"
@implementation VideoCell

+ (instancetype)cellWithTableView:(UITableView *)tableView{

    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    VideoCell * cell = [tableView dequeueReusableCellWithIdentifier:ZYCell];
    if (!cell) {
        cell = [[VideoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ZYCell];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self layoutView];
    }
    return self;
}

//时间转换
- (NSString *)convertTime:(CGFloat)second{
    NSDateFormatter * fmt = [[NSDateFormatter alloc] init];
    NSDate * d = [NSDate dateWithTimeIntervalSince1970:second];
    if (second/3600 >= 1) {
        [fmt setDateFormat:@"HH:mm:ss"];
    } else {
        [fmt setDateFormat:@"mm:ss"];
    }
    NSString *showtimeNew = [fmt stringFromDate:d];
    return showtimeNew;
}


- (void)layoutView{
    //图片
    _imageview = [[UIImageView alloc] init];
    [self.contentView addSubview:_imageview];
    
    //标题背景
    UIImageView * imgBgTop = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, KSCREEN_WIDTH, 50)];
    imgBgTop.image = [UIImage imageNamed:@"top_shadow"];
    [self.contentView addSubview:imgBgTop];
    
    //标题
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.font = [UIFont systemFontOfSize:16.f];
    _titleLabel.textAlignment = NSTextAlignmentLeft;
    _titleLabel.numberOfLines = 0;
    _titleLabel.textColor = ZYColor(@"ffffff");
    [self.contentView addSubview:_titleLabel];
    
    
    _playcoverImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"play_btn"]];
    [self.contentView addSubview:_playcoverImage];
    
    //时长
    _lengthLabel = [[UILabel alloc] init];
    _lengthLabel.textColor = ZYColor(@"ffffff");
    _lengthLabel.backgroundColor = RGBA(1, 1, 1, 0.3);
    _lengthLabel.textAlignment = NSTextAlignmentCenter;
    _lengthLabel.layer.cornerRadius = 10.f;
    _lengthLabel.layer.masksToBounds = YES;
    _lengthLabel.font = [UIFont systemFontOfSize:11.f];
    [self.contentView addSubview:_lengthLabel];
    
    //来源图标
    _playImage = [[UIImageView alloc] init];
    _playImage.layer.cornerRadius = 12.f;
    _playImage.layer.masksToBounds = YES;
    [self.contentView addSubview:_playImage];
    
    //来源文字
    _playcountLabel = [[UILabel alloc] init];
    _playcountLabel.font = [UIFont systemFontOfSize:13.f];
    _playcountLabel.textColor = ZYColor(@"333333");
    _playcountLabel.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:_playcountLabel];
    
    //时间
    _ptimeLabel = [[UILabel alloc] init];
    _ptimeLabel.textColor = ZYColor(@"797979");
    _ptimeLabel.font = [UIFont systemFontOfSize:13.f];
    _ptimeLabel.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:_ptimeLabel];
    
    _lineV = [[UIView alloc] init];
    _lineV.backgroundColor = [UIColor magentaColor];
    [self.contentView addSubview:_lineV];
    
}
- (void)setVideodataframe:(VideoDataFrame *)videodataframe{
    _videodataframe = videodataframe;
    VideoData * videodata = _videodataframe.videodata;
    
    //图片
    [_imageview sd_setImageWithURL:[NSURL URLWithString:videodata.cover] placeholderImage:[UIImage imageNamed:@"sc_video_play_fs_loading_bg"]];
    _imageview.frame = _videodataframe.coverF;
    //标题
    _titleLabel.text = [videodata.title stringByReplacingOccurrencesOfString:@"&quot;" withString:@"\""];
    _titleLabel.frame = _videodataframe.titleF;
    
    //中间播放大图标
    _playcoverImage.frame = _videodataframe.playF;
    
    _lengthLabel.text = [self convertTime:videodata.length];
    _lengthLabel.frame = _videodataframe.lengthF;

    [_playImage sd_setImageWithURL:[NSURL URLWithString:videodata.topicImg]];
    _playImage.frame = _videodataframe.playImageF;
    
    _playcountLabel.text = videodata.topicName;
    _playcountLabel.frame = _videodataframe.playCountF;
    
    _ptimeLabel.text = videodata.ptime;
    _ptimeLabel.frame = _videodataframe.ptimeF;
    _lineV.frame = _videodataframe.lineVF;
}


- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

@end
