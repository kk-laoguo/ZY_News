//
//  GZYPlay.m
//  ZY_DayDayNews
//
//  Created by guozengying on 2017/3/6.
//  Copyright © 2017年 gzy. All rights reserved.
//

#import "GZYPlay.h"
#import <AVFoundation/AVFoundation.h>
#import "GZYCircleLoadingView.h"
static NSString * const status = @"status";
static NSString * const loadedTimeRanges = @"loadedTimeRanges";

@interface GZYPlay ()

@property (nonatomic, strong) AVPlayerItem          * playerItem;
@property (nonatomic, strong) AVPlayerLayer         * playerLayer;
@property (nonatomic, strong) AVPlayer              * player;
/** 加载进度视图 */
@property (nonatomic, strong) GZYCircleLoadingView  * circleLoadingView;
/** 背景view */
@property (nonatomic, strong) UIView                * bottomView;
/** 视频标题 */
@property (nonatomic, strong) UILabel               * titleLab;
/** 视屏标题背景图片 */
@property (nonatomic, strong) UIImageView           * imageBgTop;
/** 底部工具 */
@property (nonatomic, strong) UIView                * bottomBar;
/** 视屏底部背景图片 */
@property (nonatomic, strong) UIImageView           * imgBgBottom;
/** 播放暂停按钮 */
@property (nonatomic, strong) UIButton              * playOrPauseBtn;
/** 全屏按钮 */
@property (nonatomic, strong) UIButton              * fullScreenBtn;
/** 是否支持全屏 */
@property (nonatomic, assign) BOOL                     isFullScreen;

@end

@implementation GZYPlay

- (void)dealloc{

    [self removePlayer];
}
- (void)removePlayer{
    if (self.superview) {
        [self.player pause];
        [self.player.currentItem cancelPendingSeeks];
        [self.player.currentItem.asset cancelLoading];
        [self.playerItem removeObserver:self forKeyPath:status];
        [self.playerItem removeObserver:self forKeyPath:loadedTimeRanges];
        [[NSNotificationCenter defaultCenter] removeObserver:self];
        [self removeFromSuperview];
    }
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        //监听屏幕改变
        //Get the device object
        UIDevice * device = [UIDevice currentDevice];
        //Tell it to start monitoring the accelerometer for orientation
        [device beginGeneratingDeviceOrientationNotifications];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orientationChanged:) name:UIDeviceOrientationDidChangeNotification object:device];

        self.circleLoadingView.isShowProgress = YES;

        [self addSubview:self.circleLoadingView];
    }
    return self;
}
//kvo监听播放器状态
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    
//    AVPlayerItem *playerItem = object;
    if ([keyPath isEqualToString:@"status"]) {
        AVPlayerStatus status = [[change objectForKey:@"new"] intValue];
        if (status == AVPlayerStatusReadyToPlay){
            KLog(@"准备播放");
            [self.circleLoadingView stopAnimation];
            //            self.totalDuration = CMTimeGetSeconds(playerItem.duration);
            //            self.totalDurationLabel.text = [self timeFormatted:self.totalDuration];
        } else if (status == AVPlayerStatusFailed){
            KLog(@"播放失败");
        } else if (status == AVPlayerStatusUnknown){
            KLog(@"unknown");
        }
    }
    else if ([keyPath isEqualToString:@"loadedTimeRanges"]) {
        //        NSArray *array = playerItem.loadedTimeRanges;
        //        CMTimeRange timeRange = [array.firstObject CMTimeRangeValue];//本次缓冲时间范围
        //        float startSeconds = CMTimeGetSeconds(timeRange.start);
        //        float durationSeconds = CMTimeGetSeconds(timeRange.duration);
        //        NSTimeInterval totalBuffer = startSeconds + durationSeconds;//缓冲总长度
        ////        self.slider.middleValue = totalBuffer / CMTimeGetSeconds(playerItem.duration);
        //        //        NSLog(@"totalBuffer：%.2f",totalBuffer);
        //
        //        //loading animation
        //        if (self.slider.middleValue  <= self.slider.value || (totalBuffer - 1.0) < self.current) {
        //            DLog(@"正在缓冲...");
        //            self.activityIndicatorView.hidden = NO;
        //            //            self.activityIndicatorView.center = self.center;
        //            [self.activityIndicatorView startAnimating];
        //        }else {
        //            self.activityIndicatorView.hidden = YES;
        //            if (self.playOrPauseBtn.selected) {
        //                [self.player play];
        //            }
        //        }
    }
}
//添加kvo noti
- (void)addObserverAndNotification{
    //监控状态属性 AVPlayerStatusUnknown,AVPlayerStatusReadyToPlay,AVPlayerStatusFailed
    [self.playerItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
    //加载进度
    [self.playerItem addObserver:self forKeyPath:@"loadedTimeRanges" options:NSKeyValueObservingOptionNew context:nil];
}
#pragma mark -- setter --
- (void)setMp4_url:(NSString *)mp4_url{
    _mp4_url = mp4_url;
    [self.layer addSublayer:self.playerLayer];
    [self insertSubview:self.bottomView aboveSubview:self];
    [self insertSubview:self.circleLoadingView aboveSubview:self.bottomView];
    [self.circleLoadingView startAnimation];
    [self.player play];
}
- (void)setTitle:(NSString *)title{
    _title = title;
    self.titleLab.text = title;
}


#pragma mark -- 屏幕改变通知 --
- (void)orientationChanged:(NSNotification *)note{
    
    UIDeviceOrientation orientation = [[UIDevice currentDevice] orientation];
    switch (orientation) {
        case UIDeviceOrientationPortrait://屏幕变正
            [self up];
            break;
        case UIDeviceOrientationFaceDown://
            break;
        case UIDeviceOrientationLandscapeLeft://左转
           [[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationLandscapeRight animated:YES];
            [self landScapeLeft];
            break;
        case UIDeviceOrientationLandscapeRight://屏幕变右转
             [[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationLandscapeLeft animated:YES];
            break;
        default:
            break;
    }
}
- (void)up{
    if (self.superview) {
        [[UIApplication sharedApplication] setStatusBarHidden:NO];
        [UIView animateKeyframesWithDuration:0.3 delay:0 options:UIViewKeyframeAnimationOptionAllowUserInteraction animations:^{
            [self isFullScreen:NO];
        } completion:nil];
    }
}
- (void)landScapeLeft{
    if (self.superview) {
        [[UIApplication sharedApplication] setStatusBarStyle:YES];
        [UIView animateKeyframesWithDuration:0.3 delay:0 options:UIViewKeyframeAnimationOptionAllowUserInteraction animations:^{
            [self isFullScreen:YES];
        } completion:nil];
    }
}
//是否全屏
- (void)isFullScreen:(BOOL)isFullScreen{
    self.isFullScreen = isFullScreen;
    //CGAffineTransformIdentity:恢复
    /*
     .CGAffineTransformMakeTranslation(CGFloat tx, CGFloat ty)（平移:设置平移量）
     
     2.CGAffineTransformMakeScale(CGFloat sx, CGFloat sy)（缩放:设置缩放比例）仅通过设置缩放比例就可实现视图扑面而来和缩进频幕的效果。
     
     3.CGAffineTransformMakeRotation(CGFloat angle)（旋转:设置旋转角度）
     
     以上3个都是针对视图的原定最初位置的中心点为起始参照进行相应操作的，在操作结束之后可对设置量进行还原：
     
     view.transform＝CGAffineTransformIdentity;
     
     另外还可以通过CGAffineTransformTranslate等方法对现有的transform进行进一步处理；
     */
    self.transform = self.isFullScreen ? CGAffineTransformMakeRotation(M_PI / 2):CGAffineTransformIdentity;

    CGFloat originY = self.isFullScreen ? 0:self.currentOriginY;
    CGFloat w = KSCREEN_WIDTH;
    CGFloat h = self.isFullScreen ? KSCREENH_HEIGHT:KSCREEN_WIDTH * 0.56;
    
    self.frame = CGRectMake(0, originY, w, h);
    self.playerLayer.frame = self.bounds;
    
    //设置底部工具栏
    self.bottomView.frame = CGRectMake(0, 0,self.isFullScreen ? KSCREENH_HEIGHT:KSCREEN_WIDTH, self.isFullScreen ? KSCREEN_WIDTH : self.height);
    self.imageBgTop.width = self.isFullScreen ? KSCREENH_HEIGHT:KSCREEN_WIDTH;
    self.titleLab.width = self.isFullScreen ? KSCREENH_HEIGHT -20:KSCREEN_WIDTH -20;
    self.bottomBar.y = self.isFullScreen ? KSCREEN_WIDTH - 37:self.height - 37;
    self.bottomBar.width = self.isFullScreen ? KSCREENH_HEIGHT:KSCREEN_WIDTH;
    self.imgBgBottom.width = self.isFullScreen ? KSCREENH_HEIGHT:KSCREEN_WIDTH;
    self.fullScreenBtn.x = self.isFullScreen ? KSCREENH_HEIGHT -10 - 37:KSCREEN_WIDTH -10 -37;
    
    if (self.isFullScreen) {
        self.circleLoadingView.frame = CGRectMake(KSCREENH_HEIGHT/2-20, KSCREEN_WIDTH/2-20, 40, 40);
        [WINDOW addSubview:self];
    }
    else{
        self.circleLoadingView.frame = CGRectMake(self.width/2-20, self.height/2-20, 40, 40);
        if (self.CurrentRowBlock) {
            self.CurrentRowBlock();
        }
    }
    
}

//获取url是网络的还是本地的
- (AVPlayerItem *)getAVPlayItem{
    if ([self.mp4_url rangeOfString:@"http"].location != NSNotFound) {
        AVPlayerItem * playerItem = [AVPlayerItem playerItemWithURL:[NSURL URLWithString:[self.mp4_url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
        return playerItem;
    }
    else{
        AVAsset * moviceAsset = [[AVURLAsset alloc] initWithURL:[NSURL fileURLWithPath:self.mp4_url] options:nil];
        AVPlayerItem * playerItem = [AVPlayerItem playerItemWithAsset:moviceAsset];
        return playerItem;
    }
}
//播放/暂停
- (void)playOrPause:(UIButton *)button{
    button.selected = !button.selected;
    if (button.selected) {
        [button setImage:[UIImage imageNamed:@"video_pause"] forState:UIControlStateNormal];
        [self.player play];
    }
    else{
        [button setImage:[UIImage imageNamed:@"video_play"] forState:UIControlStateNormal];
        [self.player pause];
    }
}

//全屏/不全屏
- (void)fullScreen:(UIButton *)button{
    button.selected = !button.selected;
    [self isFullScreen:button.selected];
    if (self.isFullScreen) {
        [[UIApplication sharedApplication] setStatusBarHidden:YES];
    }
}


#pragma mark -- geter
#pragma mark -- lazy --
- (GZYCircleLoadingView *)circleLoadingView{
    if (!_circleLoadingView) {
        _circleLoadingView = [[GZYCircleLoadingView alloc] initWithViewFrame:CGRectMake(self.width/2.0 -20, self.height/2.0-20, 40, 40)];
    }
    return _circleLoadingView;
}
- (AVPlayer *)player{
    if (!_player) {
        self.playerItem = [self getAVPlayItem];
        _player = [AVPlayer playerWithPlayerItem:self.playerItem];
        [self addObserverAndNotification];
    }
    return _player;
}
- (AVPlayerLayer *)playerLayer{
    if (!_playerLayer) {
        _playerLayer = [AVPlayerLayer playerLayerWithPlayer:self.player];
        _playerLayer.frame = self.bounds;
        _playerLayer.backgroundColor = [UIColor blackColor].CGColor;
        _playerLayer.videoGravity = AVLayerVideoGravityResizeAspect;//视频填充模式
    }
    return _playerLayer;
}

- (UIView *)bottomView{
    if (!_bottomView) {
        _bottomView = [[UIView alloc] init];
        _bottomView.backgroundColor = [UIColor clearColor];
        _bottomView.frame = CGRectMake(0, 0, KSCREEN_WIDTH, self.height);
        
        self.imageBgTop = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, KSCREEN_WIDTH, 50)];
        self.imageBgTop.image = [UIImage imageNamed:@"top_shadow"];
        [_bottomView addSubview:self.imageBgTop];
        
        self.titleLab = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, KSCREEN_WIDTH-20, 40)];
        self.titleLab.font = [UIFont systemFontOfSize:16.f];
        self.titleLab.numberOfLines = 0;
        self.titleLab.textColor = [UIColor colorWithHexString:@"ffffff"];
        [_bottomView addSubview:self.titleLab];
        
        self.bottomBar = [[UIView alloc] initWithFrame:CGRectMake(0, self.height-37, KSCREEN_WIDTH, 37)];
        [_bottomView addSubview:self.bottomBar];
        
        self.imgBgBottom = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, KSCREEN_WIDTH, 37)];
        self.imgBgBottom.image = [UIImage imageNamed:@"bottom_shadow"];
        [self.bottomBar addSubview:self.imgBgBottom];
        
        self.playOrPauseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.playOrPauseBtn.frame = CGRectMake(10, 10, 17, 17);
        [self.playOrPauseBtn setImage:[UIImage imageNamed:@"video_pause"] forState:UIControlStateNormal];
        [self.playOrPauseBtn addTarget:self action:@selector(playOrPause:) forControlEvents:UIControlEventTouchUpInside];
        self.playOrPauseBtn.selected = YES;
        [self.bottomBar addSubview:self.playOrPauseBtn];
        
        self.fullScreenBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.fullScreenBtn.frame = CGRectMake(KSCREEN_WIDTH -10 - 37, 0, 37, 37);
        [self.fullScreenBtn setImage:[UIImage imageNamed:@"sc_video_play_ns_enter_fs_btn"] forState:UIControlStateNormal];
        [self.fullScreenBtn addTarget:self action:@selector(fullScreen:) forControlEvents:UIControlEventTouchUpInside];
        [self.bottomBar addSubview:self.fullScreenBtn];
        
        [self addSubview:_bottomView];
    
    }
    return _bottomView;
}


@end
