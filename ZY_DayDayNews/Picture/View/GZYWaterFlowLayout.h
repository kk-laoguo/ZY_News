//
//  GZYWaterFlowLayout.h
//  ZY_DayDayNews
//
//  Created by guozengying on 2017/3/3.
//  Copyright © 2017年 gzy. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GZYWaterFlowLayout;
@protocol GZYwWaterFlowLayoutDelete <NSObject>
@required
- (CGFloat)waterFlowLayout:(GZYWaterFlowLayout *)gzyWaterFlowyout heightForWidth:(CGFloat)width indexPath:(NSIndexPath *)indexPath;

@end

@interface GZYWaterFlowLayout : UICollectionViewLayout

@property (nonatomic, copy) CGFloat (^HeightBlock)(CGFloat width, NSIndexPath * indexPath);
/**  collectionView边距 默认 0 0 10 0 */
@property (nonatomic, assign) UIEdgeInsets sectionEdgeInset;
/** 每一列之间的间距 默认10 */
@property (nonatomic, assign) CGFloat columnMargin;
/** 每一行之间的间距 默认10 */
@property (nonatomic, assign) CGFloat rowMargin;
/** 显示多少列 默认2列 */
@property (nonatomic, assign) int columnsCount;

@property (nonatomic, assign) id<GZYwWaterFlowLayoutDelete>delegate;

@end
