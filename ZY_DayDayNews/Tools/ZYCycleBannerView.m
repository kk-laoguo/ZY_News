//
//  ZYCycleBannerView.m
//  ZY_DayDayNews
//
//  Created by guozengying on 2017/2/24.
//  Copyright © 2017年 gzy. All rights reserved.
//
//
//                       _oo0oo_
//                      o8888888o
//                      88" . "88
//                      (| -_- |)
//                      0\  =  /0
//                    ___/`---'\___
//                  .' \\|     |// '.
//                 / \\|||  :  |||// \
//                / _||||| -:- |||||- \
//               |   | \\\  -  /// |   |
//               | \_|  ''\---/''  |_/ |
//               \  .-\__  '-'  ___/-. /
//             ___'. .'  /--.--\  `. .'___
//          ."" '<  `.___\_<|>_/___.' >' "".
//         | | :  `- \`.;`\ _ /`;.`/ - ` : | |
//         \  \ `_.   \_ __\ /__ _/   .-` /  /
//     =====`-.____`.___ \_____/___.-`___.-'=====
//                       `=---='
//
//
//     ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
//
//               佛祖保佑         永无BUG
//
//
//

#import "ZYCycleBannerView.h"
#import "ZYCycleBannerCell.h"

#define KSCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define KSCREENH_HEIGHT [UIScreen mainScreen].bounds.size.height

static CGFloat const timeInterval = 5.0f;//滚动时间间隔
static CGFloat const labHeight = 34;//文本框的高度
static CGFloat const margin = 9;//间距
static CGFloat const pageControlConst = 27;
static CGFloat const textFont = 14;//字体大小
static NSString * const k_cellID = @"cell";



@interface ZYCycleBannerView()<UICollectionViewDelegate, UICollectionViewDataSource,UIScrollViewDelegate>
{
    NSInteger _currentItemIndex;
    NSInteger _totalItemsCount;
}
@property (nonatomic, strong) UICollectionViewFlowLayout    * flowlayout;
@property (nonatomic, strong) UICollectionView              * collectionView;
@property (nonatomic, strong) NSTimer                       * timer;
@property (nonatomic, strong) UIPageControl                 * pageControl;
@property (nonatomic, strong) UILabel                       * textLab;


@end

@implementation ZYCycleBannerView

- (void)dealloc{
    self.collectionView.delegate = nil;
    self.collectionView.dataSource = nil;
    [self invalidateTimer];

}

- (instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if (self) {
        
        [self setupControl];
        self.showPageControl = YES;
        self.currentPageControlColor = [UIColor whiteColor];
        self.otherPageControlColor = [UIColor blackColor];

    }
    return self;
}
- (void)layoutSubviews {
    [super layoutSubviews];
    if (self.collectionView.contentOffset.x == 0 && _totalItemsCount) {
        int targetIndex = 0;
        targetIndex = _totalItemsCount * 0.5;
        [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:targetIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
    }
}

#pragma mark -- 初始化控件 --
- (void)setupControl{
    
    [self addSubview:self.collectionView];
    [self addSubview:self.pageControl];
    [self addSubview:self.textLab];


}
#pragma mark -- UICollectionViewDataSource --
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _totalItemsCount;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    ZYCycleBannerCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:k_cellID forIndexPath:indexPath];
    NSInteger itemIndex = [self pageContrlIndexWithCurrentItemIndex:indexPath.item];
    if (itemIndex < self.imgArr.count) {
        NSString * imgUrl = self.imgArr[itemIndex];
        [cell setImageViewWithUrl:imgUrl];
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (self.clickBlock) {
        self.clickBlock([self pageContrlIndexWithCurrentItemIndex:indexPath.item]);
    }
}

//开启定时器
- (void)initTimer{
    
    _timer = [NSTimer scheduledTimerWithTimeInterval:timeInterval target:self selector:@selector(nextPage) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
    
}
//销毁定时器
- (void)invalidateTimer{
    
    [_timer invalidate];
    _timer = nil;
    
}
#pragma mark --
#pragma mark - private actions/私有方法 --
- (void)nextPage{
    
    if (!_totalItemsCount) {
        return;
    }
    NSInteger targetIndex = [self currentIndex] +1;
    [self scrollToIndex:targetIndex];
}

- (void)scrollToIndex:(NSInteger)targetIndex{
    
    if (targetIndex >= _totalItemsCount) {
        targetIndex = _totalItemsCount * 0.5;
        [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:targetIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
        return;
    }
    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:targetIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:YES];
   
}
- (NSInteger)currentIndex{
    
    if (self.collectionView.width == 0 || self.collectionView.height == 0) {
        return 0;
    }
    NSInteger index = 0;
    index = (self.collectionView.contentOffset.x + self.flowlayout.itemSize.width * 0.5) / self.flowlayout.itemSize.width;
    return index;
}

- (NSInteger)pageContrlIndexWithCurrentItemIndex:(NSInteger)index{
    return index % self.imgArr.count;
}

#pragma mark --
#pragma mark -- setter --
//是否可以滑动
- (void)setAutoScroll:(BOOL)autoScroll{
    
    _autoScroll = autoScroll;
    if (_autoScroll) {
        [self initTimer];
    }
}

- (void)setImgArr:(NSMutableArray *)imgArr{
    
    _imgArr = imgArr;
    if (_imgArr.count == 0) {
        return;
    }
    
    self.pageControl.numberOfPages = _imgArr.count;
    self.pageControl.currentPage = [self pageContrlIndexWithCurrentItemIndex:[self currentIndex]];
    _totalItemsCount = _imgArr.count * 100;
    [self.collectionView reloadData];
    //有数据再开启定时器
    self.autoScroll = YES; // 等于  [self setAutoScroll:YES];相当于调用了setter方法
    self.pageStyle = pageControl_Right;
    self.textLab.frame = CGRectMake(margin, self.height-labHeight, KSCREEN_WIDTH-2*margin-self.pageControl.width, labHeight);
}

- (void)setTitleArr:(NSMutableArray *)titleArr{
    
    _titleArr = titleArr;
    if (!_titleArr.count) {
        return;
    }
    self.textLab.text = _titleArr[0];
}
//是否显示pageControl
- (void)setShowPageControl:(BOOL)showPageControl{
    
    _showPageControl = showPageControl;
    self.pageControl.hidden = !_showPageControl;
}


- (void)setPageStyle:(ZYPageControlStyle)pageStyle{
    
    _pageStyle = pageStyle;
    CGFloat width = self.imgArr.count * 10 * 1.5;
    CGFloat height = 20.f;
    switch (_pageStyle) {
        case pageControl_Left:
            self.pageControl.frame = CGRectMake(margin, self.height - pageControlConst, width, height);
            break;
        case pageControl_Center:
            self.pageControl.frame = CGRectMake((KSCREEN_WIDTH - width)/2, self.height - pageControlConst, width, height);
            break;
        case pageControl_Right:
            self.pageControl.frame = CGRectMake(KSCREEN_WIDTH - width - margin, self.height - pageControlConst, width, height);
            break;
        default:
            break;
    }
}

#pragma mark -- UIScrollViewDelegate --
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (!self.imgArr.count) {
        return;
    }
    NSInteger currentIndex = [self pageContrlIndexWithCurrentItemIndex:[self currentIndex]];
    self.pageControl.currentPage = currentIndex;
    
    if (self.titleArr.count > 0) {
        self.textLab.text = self.titleArr[currentIndex];
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    if (_autoScroll) {
        [self invalidateTimer];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    if (_autoScroll) {
        [self initTimer];
    }
}


#pragma mark -- geter
#pragma mark -- 懒加载 --
- (UICollectionView *)collectionView{
    if (!_collectionView) {
        _collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:self.flowlayout];
        _collectionView.pagingEnabled = YES;
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [_collectionView registerClass:[ZYCycleBannerCell class] forCellWithReuseIdentifier:k_cellID];
    }
    return _collectionView;
}
- (UICollectionViewFlowLayout *)flowlayout{
    if (!_flowlayout) {
        _flowlayout = [[UICollectionViewFlowLayout alloc] init];
        _flowlayout.minimumLineSpacing = 0;
        _flowlayout.itemSize = CGSizeMake(KSCREEN_WIDTH, self.height);
        _flowlayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    }
    return _flowlayout;
}
- (UIPageControl *)pageControl{
    if (!_pageControl) {
        _pageControl = [[UIPageControl alloc] init];
        _pageControl.userInteractionEnabled = NO;
        _pageControl.currentPageIndicatorTintColor = self.currentPageControlColor;
        _pageControl.pageIndicatorTintColor = self.otherPageControlColor;
    }
    return _pageControl;
}
- (UILabel *)textLab{
    if (!_textLab) {
        _textLab = [[UILabel alloc] init];
        _textLab.font = [UIFont systemFontOfSize:textFont];
        _textLab.textColor = [UIColor whiteColor];
        _textLab.backgroundColor = [UIColor clearColor];
    }
    return _textLab;
}


@end
