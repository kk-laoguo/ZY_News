//
//  VedioViewController.m
//  ZY_DayDayNews
//
//  Created by guozengying on 2017/2/22.
//  Copyright © 2017年 gzy. All rights reserved.
//

#import "VideoViewController.h"
#import "VDCategoryView.h"
#import "GZYRefreshGifHeader.h"


@interface VideoViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView       * tableView;
@property (nonatomic, strong) NSMutableArray    * videoArr;
@property (nonatomic, assign) NSInteger           count;//请求参数

@property (nonatomic, strong) VDCategoryView    * headerView;


@end

@implementation VideoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tableView];
    
}
- (void)initUI{
    
    ZY_BLOCK_SELF(VedioViewController);
    GZYRefreshGifHeader * header = [GZYRefreshGifHeader headerWithRefreshingBlock:^{
        block_self.count = 0;
        
    }];
    
}

#pragma mark -- UITableViewDataSource/Delegate --
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 10;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:ZYCell forIndexPath:indexPath];
    cell.textLabel.text = ZYCell;
    return cell;
}
#pragma mark -- load data --
- (void)loadData{
    ZY_BLOCK_SELF(VedioViewController)
}

#pragma mark -- geter
#pragma mark -- 懒加载 --
- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, KSCREEN_WIDTH, KSCREENH_HEIGHT-ZYNavBarAndStatus_Height)];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.tableHeaderView = self.headerView;
    }
    return _tableView;
}
- (VDCategoryView *)headerView{
    if (!_headerView) {
        _headerView = [[VDCategoryView alloc] init];
        _headerView.SelectBlock = ^(NSInteger tag, NSString * title){
            
            
        };
    }
    return _headerView;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
