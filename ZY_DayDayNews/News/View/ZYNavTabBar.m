//
//  ZYNavTabBar.m
//  ZY_DayDayNews
//
//  Created by guozengying on 2017/2/23.
//  Copyright © 2017年 gzy. All rights reserved.
//

#import "ZYNavTabBar.h"

const CGFloat fontSize = 16.f;
const CGFloat margin = 40;

@interface ZYNavTabBar ()

@property (nonatomic, strong) UIScrollView * navigationScrollView;
@property (nonatomic, strong) UILabel * line;
@property (nonatomic, strong) NSArray * itemWidthArr;
@property (nonatomic, strong) NSMutableArray * itemButtonArr;


@end

@implementation ZYNavTabBar

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.navigationScrollView];
    }
    return self;
}

#pragma mark --
#pragma mark -- setter --
- (void)setItmeTitleArr:(NSArray *)itmeTitleArr{
    
    _itmeTitleArr = itmeTitleArr;
    if (_itmeTitleArr.count) {
        
        self.itemWidthArr = [self getItemWidthWithTitles:itmeTitleArr];
        self.navigationScrollView.contentSize = CGSizeMake([self contentWidthWithItemWidthArr:self.itemWidthArr], 0);
    }
}
//偏移
- (void)setCurrtentItemIndex:(NSInteger)currtentItemIndex{
    
    _currtentItemIndex = currtentItemIndex;
    UIButton * button = self.itemButtonArr[currtentItemIndex];
    CGFloat flag = KSCREEN_WIDTH- margin;
    if (CGRectGetMaxX(button.frame) +50 >= flag) {
        CGFloat offsetX = CGRectGetMaxX(button.frame) - flag;
        if (_currtentItemIndex < _itmeTitleArr.count-1) {
            offsetX = offsetX + button.width;
        }
        [self.navigationScrollView setContentOffset:CGPointMake(offsetX, 0) animated:YES];
    }else{
        [self.navigationScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    }
    // 下滑线的偏移量
    [UIView animateWithDuration:0.1f animations:^{
        self.line.frame = CGRectMake(button.x+15,42, [self.itemWidthArr[currtentItemIndex] floatValue], _line.height);
        
    } completion:^(BOOL finished) {
        
    }];
}

#pragma mark --
#pragma mark - private actions/私有方法 --
//计算数组内字体的宽度
- (NSArray *)getItemWidthWithTitles:(NSArray *)titleArr{
    
    NSMutableArray * widthArr = [NSMutableArray array];
    for (NSString * title in titleArr) {
        
        CGFloat width = [title sizeWithFont:[UIFont systemFontOfSize:fontSize] maxW:KSCREEN_WIDTH].width;
        [widthArr addObject:[NSNumber numberWithFloat:width]];
    }
    return widthArr;
}

//计算navigationScrollView的偏移量
- (CGFloat)contentWidthWithItemWidthArr:(NSArray *)widthArr{
    
    CGFloat itemButtonX = 0;
    self.itemButtonArr = [NSMutableArray array];
    for (NSInteger i = 0; i < widthArr.count; i ++) {
        
        UIButton * itemButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [itemButton setTitle:self.itmeTitleArr[i] forState:UIControlStateNormal];
        itemButton.titleLabel.font = [UIFont systemFontOfSize:fontSize];
        [itemButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        CGFloat itemWidth = [widthArr[i] integerValue] + 15*2;
        itemButton.frame = CGRectMake(itemButtonX, 0, itemWidth, 44);
//        [itemButton addTarget:self action:@selector(itemClick:type:) forControlEvents:UIControlEventTouchUpInside];
        [itemButton addTarget:self action:@selector(itemClick:) forControlEvents:UIControlEventTouchUpInside];
        itemButtonX += itemButton.frame.size.width;
        [self.navigationScrollView addSubview:itemButton];
        [self.itemButtonArr addObject:itemButton];
    }

    //默认第一个选中
    self.line.frame = CGRectMake(15, 42, [widthArr[0] floatValue], 2.0f);
    [self.navigationScrollView addSubview:self.line];
    [self itemClick:self.itemButtonArr[0]];
    return itemButtonX;
}

- (void)itemClick:(UIButton *)button{
    
    if ([_delegate respondsToSelector:@selector(itemDidSelectedIndex:currentIndex:)]) {
        [_delegate itemDidSelectedIndex:[self.itemButtonArr indexOfObject:button] currentIndex:_currtentItemIndex];

    }
}
#pragma mark -- geter
#pragma mark -- 懒加载 --
- (UIScrollView *)navigationScrollView{
    if (!_navigationScrollView) {
        _navigationScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 20, KSCREEN_WIDTH-margin, 44)];
        _navigationScrollView.backgroundColor = [UIColor whiteColor];
        _navigationScrollView.showsHorizontalScrollIndicator = NO;
    }
    return _navigationScrollView;
}

- (UILabel *)line{
    if (!_line) {
        _line = [[UILabel alloc] initWithFrame:CGRectZero];
        _line.backgroundColor = [UIColor redColor];
    }
    return _line;
}

- (NSArray *)itemWidthArr{
    if (!_itemWidthArr) {
        _itemWidthArr = [NSArray array];
    }
    return _itemWidthArr;
}
@end
