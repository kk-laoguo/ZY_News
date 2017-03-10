//
//  GZYWaterFlowLayout.m
//  ZY_DayDayNews
//
//  Created by guozengying on 2017/3/3.
//  Copyright © 2017年 gzy. All rights reserved.
//

#import "GZYWaterFlowLayout.h"

@interface GZYWaterFlowLayout()
/** 这个字典用来存储每一列最大的Y值(每一列的高度) */
@property (nonatomic, strong) NSMutableDictionary * maxYDict;
/** 存放所有的布局属性 */
@property (nonatomic, strong) NSMutableArray *attrsArray;

@end

@implementation GZYWaterFlowLayout
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.columnMargin = 5;
        self.rowMargin = 5;
        //collectionView 和 view之间的间距
        self.sectionEdgeInset = UIEdgeInsetsMake(0, 0, 10, 0);
        self.columnsCount = 2;
    }
    return self;
}
//用来刷新layout的，当我们返回yes的时候。如果我们的需求不需要实时的刷新layout，
//那么最好判断newBounds 和 我们的collectionView的bounds是否相同，不同时返回yes；
//（例如苹果官方的lineLayout，因为每次滑动都要放大item，所以这了就直接返回yes）
//- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds{
//    return YES;
//}
//每次布局之前的准备
- (void)prepareLayout{
    [super prepareLayout];
    // 1.清空最大的Y值
    for (NSInteger i = 0; i < self.columnsCount; i ++) {
        NSString * column = [NSString stringWithFormat:@"%ld",(long)i];
        self.maxYDict[column] = @(self.sectionEdgeInset.top);
    }
    // 2.计算所有cell的属性
    [self.attrsArray removeAllObjects];
    NSInteger count = [self.collectionView numberOfItemsInSection:0];
    for (NSInteger i = 0; i < count; i ++) {
        UICollectionViewLayoutAttributes * attrs = [self layoutAttributesForItemAtIndexPath:[NSIndexPath indexPathForItem:i inSection:0]];
        [self.attrsArray addObject:attrs];
    }
    
}
/**
 *  返回所有的尺寸
 */
- (CGSize)collectionViewContentSize{
    //找出最高的那一列
    __block NSString * maxColumn = @"0";
    [self.maxYDict enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        if ([obj floatValue] > [self.maxYDict[maxColumn] floatValue]) {
            maxColumn = key;
        }
    }];
    return CGSizeMake(0, [self.maxYDict[maxColumn] floatValue]+self.sectionEdgeInset.bottom);
    
}
/**
 *  返回indexPath这个位置Item的布局属性
 */
- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath{
    //假设最短的那一列是0列
    __block NSString * minColumn = @"0";
    //找出最短的那一列
    [self.maxYDict enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        if ([obj floatValue] < [self.maxYDict[minColumn] floatValue]) {
            minColumn = key;
        }
    }];
    // 计算尺寸
    CGFloat width = (self.collectionView.frame.size.width - self.sectionEdgeInset.left - self.sectionEdgeInset.right - (self.columnsCount -1) * self.columnMargin)/self.columnsCount;
    CGFloat height;

    if ([_delegate respondsToSelector:@selector(waterFlowLayout:heightForWidth:indexPath:)]) {
         height = [self.delegate waterFlowLayout:self heightForWidth:width indexPath:indexPath];
    }
//    CGFloat height = self.HeightBlock(width,indexPath);
    
    // 计算位置
    CGFloat x = self.sectionEdgeInset.left + (width + self.columnMargin) * [minColumn floatValue];
    // self.rowMargin 每一行之间的距离
    CGFloat y = [self.maxYDict[minColumn] floatValue] + self.rowMargin;
    
    // 更新这一列的最大 Y 值
    
    self.maxYDict[minColumn] = @(y+height);
    
    // 创建属性
    UICollectionViewLayoutAttributes * attrs = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    attrs.frame = CGRectMake(x, y, width, height);
    return attrs;
}


/**
 *  返回rect范围内的布局属性
 *
 */
- (nullable NSArray<__kindof UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect{
    return self.attrsArray;
}


#pragma mark -- geter
#pragma mark -- 懒加载 --
- (NSMutableDictionary *)maxYDict{
    if (!_maxYDict) {
        _maxYDict = [[NSMutableDictionary alloc] init];
    }
    return _maxYDict;
}

- (NSMutableArray *)attrsArray{
    if (!_attrsArray) {
        _attrsArray = [NSMutableArray arrayWithCapacity:0];
    }
    return _attrsArray;
}

@end
