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
#import "BaseEngine.h"
#import "VideoData.h"
#import "VideoDataFrame.h"
#import "GZYPlay.h"
#import "VideoCell.h"

@interface VideoViewController ()<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate>

@property (nonatomic, strong) UITableView       * tableView;
@property (nonatomic, strong) NSMutableArray    * videoArr;
@property (nonatomic, assign) NSInteger           count;//请求参数

@property (nonatomic, strong) VDCategoryView    * headerView;
@property (nonatomic, strong) GZYPlay           * player;


@end

@implementation VideoViewController
- (void)dealloc{
    if (self.player) {
        [self.player removePlayer];
        self.player = nil;
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if (self.player) {
        [self.player removePlayer];
        self.player = nil;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tableView];
    [self initHeader];
    
}
- (void)initHeader{
    ZY_BLOCK_SELF(VideoViewController);
    GZYRefreshGifHeader * header = [GZYRefreshGifHeader headerWithRefreshingBlock:^{
        block_self.count = 0;
        [block_self loadData];
    }];
    header.lastUpdatedTimeLabel.hidden = YES;
    header.stateLabel.hidden = YES;
    self.tableView.mj_header = header;
    [header beginRefreshing];
    
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [block_self loadData];
    }];
}

#pragma mark -- UITableViewDataSource/Delegate --
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.videoArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    VideoCell * cell = [VideoCell cellWithTableView:tableView];
    if (self.videoArr.count>0) {
        cell.videodataframe = self.videoArr[indexPath.row];
    }
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    VideoDataFrame * video = self.videoArr[indexPath.row];
    return video.cellH;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    VideoDataFrame * videoframe = self.videoArr[indexPath.row];
    VideoData * videodata = videoframe.videodata;
    //创建播放器
    if (self.player) {
        [self.player removePlayer];
        self.player = nil;
    }
    CGFloat originY = videoframe.cellH * indexPath.row + videoframe.coverF.origin.y + KSCREEN_WIDTH * 0.25;
    self.player = [[GZYPlay alloc] initWithFrame:CGRectMake(0, originY,KSCREEN_WIDTH, KSCREEN_WIDTH * 0.56)];
    self.player.mp4_url = videodata.mp4_url;
    self.player.title = videodata.title;
    self.player.currentOriginY = originY;
    ZY_BLOCK_SELF(VideoViewController);
    self.player.CurrentRowBlock = ^(){
        [block_self.tableView addSubview:block_self.player];
    };
    [self.tableView addSubview:self.player];
    
    
}
//判断滚动事件，如何超出播放界面，停止播放
#pragma mark -- UIScrollViewDelegate --
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (self.player) {
        if ((fabs(scrollView.contentOffset.y) + ZYNavBarAndStatus_Height) > self.player.bottom) {
            [self.player removePlayer];
            self.player = nil;
        }
    }
}
#pragma mark -- load data --
- (void)loadData{
    
    ZY_BLOCK_SELF(VideoViewController);
    NSString * url = [NSString stringWithFormat:@"http://c.m.163.com/nc/video/home/%zd-10.html",self.count];
    [[BaseEngine shareEngine] getRequestWithPara:nil url:url success:^(id responseobject) {
        
   
        NSArray * dataArr= [VideoData mj_objectArrayWithKeyValuesArray:responseobject[@"videoList"]];
        NSMutableArray * arr = [NSMutableArray array];
        for (VideoData * model in dataArr) {
            VideoDataFrame * frame = [[VideoDataFrame alloc] init];
            frame.videodata = model;
            [arr addObject:frame];
        }
        if (block_self.count == 0) {
            block_self.videoArr = arr;
        }else{
            [block_self.videoArr addObjectsFromArray:arr];
        }
        block_self.count += 10;
        [block_self.tableView reloadData];
        [block_self.tableView.mj_header endRefreshing];
        [block_self.tableView.mj_footer endRefreshing];

        block_self.tableView.mj_footer.hidden = dataArr.count < 10;
        
    } error:^(id error) {
        [block_self.tableView.mj_header endRefreshing];
        [block_self.tableView.mj_footer endRefreshing];
    }];
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
