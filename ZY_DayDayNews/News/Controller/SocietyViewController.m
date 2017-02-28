//
//  SocietyViewController.m
//  ZY_DayDayNews
//
//  Created by guozengying on 2017/2/23.
//  Copyright © 2017年 gzy. All rights reserved.
//

#import "SocietyViewController.h"
#import "ZYCycleBannerView.h"
#import "TopData.h"
#import "BaseEngine.h"
#import "NewsCell.h"
#import "NewsDetailVC.h"

@interface SocietyViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) ZYCycleBannerView * bannerView;
@property (nonatomic, strong) NSMutableArray    * topUrlArr;
@property (weak, nonatomic) IBOutlet UITableView *tableView;


@end

@implementation SocietyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.edgesForExtendedLayout = UIRectEdgeNone;
    [self request];
    [self initBannerView];
}
#pragma mark -- UITableViewDataSource/Delegate --
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 10;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSArray * cellArr = [[NSBundle mainBundle] loadNibNamed:@"NewsCell" owner:self options:nil];
    if (indexPath.row == 2) {
        NewsCell * cell = [tableView dequeueReusableCellWithIdentifier:@"ImageCell"];
        if (!cell) {
            cell = cellArr[1];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        return cell;
    }
    else{
        NewsCell * cell = [tableView dequeueReusableCellWithIdentifier:@"NewsCell"];
        if (!cell) {
            cell = cellArr[0];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NewsDetailVC * vc = [[NewsDetailVC alloc] init];
    vc.title = @"NewsDetail";
    [self.navigationController pushViewController:vc animated:YES];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 2) {
        return 100;
    }
    return 50;
    
}

- (void)initBannerView{
    self.bannerView = [[ZYCycleBannerView alloc] initWithFrame:CGRectMake(0, 0, KSCREEN_WIDTH, KSCREEN_WIDTH * 0.55)];
    self.bannerView.clickBlock = ^(NSInteger idnex){
        
    };
    self.tableView.tableHeaderView = self.bannerView;
}
- (void)request{
    [[BaseEngine shareEngine] getRequestWithPara:nil url:@"http://c.m.163.com/nc/article/headline/T1348647853363/0-10.html" success:^(id responseobject) {
        NSArray * dataArr = [TopData mj_objectArrayWithKeyValuesArray:responseobject[@"T1348647853363"][0][@"ads"]];
        NSMutableArray * titleArr = [NSMutableArray arrayWithCapacity:0];
        NSMutableArray * imgArr = [NSMutableArray arrayWithCapacity:0];
        for (TopData * topData in dataArr) {
            [self.topUrlArr addObject:topData.url];
            [titleArr addObject:topData.title];
            [imgArr addObject:topData.imgsrc];
        }
        self.bannerView.imgArr = imgArr;
        self.bannerView.titleArr = titleArr;
        
    } error:^(id error) {

    }];
}
#pragma mark -- geter
#pragma mark -- 懒加载 --
- (NSMutableArray *)topUrlArr{
    if (!_topUrlArr) {
        _topUrlArr = [NSMutableArray array];
    }
    return _topUrlArr;
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
