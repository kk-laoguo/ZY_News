//
//  PictureViewController.m
//  ZY_DayDayNews
//
//  Created by guozengying on 2017/2/22.
//  Copyright © 2017年 gzy. All rights reserved.
//

#import "PictureViewController.h"
#import "GZYWaterFlowLayout.h"
#import "PhotoCell.h"

@interface PictureViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,GZYwWaterFlowLayoutDelete>
{
    GZYWaterFlowLayout * _layout;
}

@property (nonatomic, strong) UICollectionView  * collectionView;
@property (nonatomic, strong) NSMutableArray    * photoArr;
@property (nonatomic, assign) NSInteger           pn;
@property (nonatomic, copy) NSString            * tag1;
@property (nonatomic, copy) NSString            * tag2;
/** 分类数组 */
@property (nonatomic, strong) NSArray           * classArr;
/** 导航右按钮标题    */
@property (nonatomic, copy) NSString            * titleName;


@end

@implementation PictureViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleName = @"美女";
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem backItemWithImage:[UIImage imageNamed:@"arrow_down"] Title:self.titleName Target:self Selector:@selector(dropDownMenu) titleColor:nil];
    [self.view addSubview:self.collectionView];
//    _layout.HeightBlock = ^CGFloat(CGFloat sender,NSIndexPath *index){
//        return 200;
//    };
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
//    return self.photoArr.count;
    return 50;
    
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
//    if (self.photoArr.count) {
//        PhotoCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
//        cell.photo = self.photoArr[indexPath.item];
//        return cell;
//        
//    }
    PhotoCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor redColor];
    cell.titleLab.text = [NSString stringWithFormat:@"%ld",(long)indexPath.row];
    return cell;
    
}
#pragma mark -- GZYwWaterFlowLayoutDelete
- (CGFloat)waterFlowLayout:(GZYWaterFlowLayout *)gzyWaterFlowyout heightForWidth:(CGFloat)width indexPath:(NSIndexPath *)indexPath{
    
    return arc4random()%100 + 80;
    
}
#pragma mark -- geter
#pragma mark -- 懒加载 --
- (UICollectionView *)collectionView{
    if (!_collectionView) {
        _layout = [[GZYWaterFlowLayout alloc] init];
        _layout.delegate = self;
        _collectionView = [[UICollectionView alloc]
                           initWithFrame:CGRectMake(0, 0, KSCREEN_WIDTH, KSCREENH_HEIGHT - ZYNavBarAndStatus_Height) collectionViewLayout:_layout];
       
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [_collectionView registerNib:[UINib nibWithNibName:@"PhotoCell" bundle:nil] forCellWithReuseIdentifier:@"cell"];
    }
    return _collectionView;
}

- (void)dropDownMenu{
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
