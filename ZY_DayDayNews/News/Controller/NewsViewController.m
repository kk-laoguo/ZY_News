//
//  NewsViewController.m
//  ZY_DayDayNews
//
//  Created by guozengying on 2017/2/22.
//  Copyright © 2017年 gzy. All rights reserved.
//

#import "NewsViewController.h"
#import "ZYNavTabBar.h"
#import "SocietyViewController.h"
#import "OtherViewController.h"

@interface NewsViewController ()<ZYNavTabBarDelegate,UIScrollViewDelegate>
{
    NSInteger _currentIndex;
}
@property (nonatomic, strong) UIScrollView * scrollView;
@property (nonatomic, strong) ZYNavTabBar * navTabBar;
@property (nonatomic, strong) NSArray * titleArr;
@property (nonatomic, strong) NSMutableArray * viewControllerArr; //添加视图控制的数组
@property (nonatomic, strong) NSArray * contentArr; // 用于拼接url

@end

@implementation NewsViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    [self initControl];
}

#pragma mark -- 初始化控件 --
- (void)initControl{
    
    [self.view addSubview:self.navTabBar];
    [self.view addSubview:self.scrollView];
    UILabel * navLine = [[UILabel alloc] initWithFrame:CGRectMake(0, 63, KSCREEN_WIDTH, 1)];
    navLine.backgroundColor = [UIColor colorWithHexString:@"999999"];
    [self.view addSubview:navLine];
    
    UIButton * rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightBtn setImage:[UIImage imageNamed:@"top_navigation_square"] forState:UIControlStateNormal];
    rightBtn.frame = CGRectMake(KSCREEN_WIDTH - 40, 20, 40, 40);
    [rightBtn addTarget:self action:@selector(weatherClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:rightBtn];
    
    self.viewControllerArr = [NSMutableArray arrayWithCapacity:0];
    
    SocietyViewController * oneViewController = [[SocietyViewController alloc] init];
    [self.viewControllerArr addObject:oneViewController];
    for (NSInteger i = 0; i < self.contentArr.count; i ++) {
        
        OtherViewController * vc = [[OtherViewController alloc] init];
        vc.title = self.titleArr[i+1];
        vc.content = self.contentArr[i];
        [self.viewControllerArr addObject:vc];
    }
    self.scrollView.contentSize = CGSizeMake(KSCREEN_WIDTH * self.viewControllerArr.count, 0);
    UIViewController * vc = (UIViewController *)self.viewControllerArr[0];
    vc.view.frame = CGRectMake(0, 0, KSCREEN_WIDTH, self.scrollView.height);
    [self.scrollView addSubview:vc.view];
    [self addChildViewController:vc];
}
#pragma mark --
#pragma mark - private actions/私有方法 --
- (void)weatherClick{
    
}

#pragma mark -- UIScrollViewDelegate --
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    _currentIndex = scrollView.contentOffset.x / KSCREEN_WIDTH;
    _navTabBar.currtentItemIndex = _currentIndex;
    /** 当scrollview滚动的时候加载当前视图 */
    UIViewController * vc = (UIViewController *)self.viewControllerArr[_currentIndex];
    vc.view.frame = CGRectMake(_currentIndex * KSCREEN_WIDTH, 0, KSCREEN_WIDTH, self.scrollView.height);
    [self.scrollView addSubview:vc.view];
    [self addChildViewController:vc];
}
#pragma mark -- ZYNavTabBarDelegate -- 
- (void)itemDidSelectedIndex:(NSInteger)index currentIndex:(NSInteger)currentIndex{
    
    if (labs(currentIndex - index) >=2) { //int类型取绝对值
        
        [self.scrollView setContentOffset:CGPointMake(index * KSCREEN_WIDTH, 0) animated:NO];
        
    }else{
        
        [self.scrollView setContentOffset:CGPointMake(index * KSCREEN_WIDTH, 0) animated:YES];
    }
}

#pragma mark -- geter
#pragma mark -- 懒加载 --
- (UIScrollView *)scrollView{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, ZYNavBarAndStatus_Height, KSCREEN_WIDTH, KSCREENH_HEIGHT-ZYNavBarAndStatus_Height)];
        _scrollView.delegate = self;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.bounces = YES;
        _scrollView.pagingEnabled = YES;
    
    }
    return _scrollView;
}
- (ZYNavTabBar *)navTabBar{
    if (!_navTabBar) {
        _navTabBar = [[ZYNavTabBar alloc] initWithFrame:CGRectMake(0, 0, KSCREEN_WIDTH, ZYNavBarAndStatus_Height)];
        _navTabBar.delegate = self;
        _navTabBar.itmeTitleArr = self.titleArr;
//        _navTabBar.currtentItemIndex = 0;
    }
    return _navTabBar;
}
- (NSArray *)titleArr{
    if (!_titleArr) {
        _titleArr = @[@"社会",@"国内",@"国际",@"娱乐",@"体育",@"科技",@"奇闻趣事",@"生活健康"];
    }
    return _titleArr;
}
- (NSArray *)contentArr{
    if (!_contentArr) {
        _contentArr = @[@"guonei",@"world",@"huabian",@"tiyu",@"keji",@"qiwen",@"health"];
    }
    return _contentArr;
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
