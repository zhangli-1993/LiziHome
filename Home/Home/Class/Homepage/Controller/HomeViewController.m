//
//  HomeViewController.m
//  Home
//
//  Created by scjy on 16/3/3.
//  Copyright © 2016年 scjy. All rights reserved.
//

#import "HomeViewController.h"
#import "ThemeTableViewCell.h"
#import <SDCycleScrollView.h>
#import <AFNetworking/AFHTTPSessionManager.h>
#import "EveryUpdateModel.h"
#import "PullingRefreshTableView.h"
#import <SDWebImage/UIButton+WebCache.h>
#import "KindViewController.h"
@interface HomeViewController ()<UITableViewDataSource, UITableViewDelegate, SDCycleScrollViewDelegate,PullingRefreshTableViewDelegate>
{
     NSString *identifier;
    NSInteger offset;
}
@property (nonatomic, strong) PullingRefreshTableView *tableView;
@property (nonatomic, strong) NSMutableArray *cycleArray;
@property (nonatomic, strong) NSMutableArray *updateArray;
@property (nonatomic, strong) NSMutableArray *allArray;
@property (nonatomic, strong) NSMutableArray *timeArray;
@property (nonatomic, strong) NSMutableArray *idArray;
@property (nonatomic, strong) NSMutableArray *nameArray;

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"栗子家居";
    self.navigationController.navigationBar.barTintColor = kColor;
    identifier = @"theme";
    offset = 0;
    [self.tableView launchRefreshing];
    [self.tableView setFooterOnly:YES];

    [self.tableView registerNib:[UINib nibWithNibName:@"ThemeTableViewCell" bundle:nil] forCellReuseIdentifier:identifier];
    [self.view addSubview:self.tableView];
    [self configHeaderView];
    [self requestModel];
    [self requestTwoModel];

}
- (void)viewWillAppear:(BOOL)animated{
    self.tabBarController.tabBar.hidden = NO;
}

#pragma mark---UITableViewDataSource,UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.allArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ThemeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    cell.model = self.allArray[indexPath.section];
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (section % 2 == 1) {
        return nil;
    }
    return self.timeArray[section];
}

#pragma mark---自定义分区头部
- (void)configHeaderView{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWidth, kWidth / 2.2)];
    SDCycleScrollView *cycleView = [SDCycleScrollView cycleScrollViewWithFrame:headerView.frame delegate:self placeholderImage:nil];
    cycleView.imageURLStringsGroup = self.cycleArray;
    cycleView.autoScrollTimeInterval = 2.0;
    [headerView addSubview:cycleView];
    self.tableView.tableHeaderView = headerView;
}
#pragma mark---SDCycleScrollViewDelegate
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index{
    KindViewController *kingVC = [[KindViewController alloc] init];
    kingVC.title = self.nameArray[index];
    kingVC.idStr = self.idArray[index];
    ZLLog(@"%@", kingVC.idStr);
    [self.navigationController pushViewController:kingVC animated:YES];
}
#pragma mark---数据请求
- (void)requestModel{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    [manager GET:kCyclePictures parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dic1 = responseObject;
        NSDictionary *dic2 = dic1[@"data"];
        NSArray *array1 = dic2[@"banners"];
        for (NSDictionary *dict in array1) {
            NSDictionary *dict1 = dict[@"target"];
            [self.cycleArray addObject:dict[@"image_url"]];
            [self.idArray addObject:dict1[@"id"]];
            [self.nameArray addObject:dict1[@"title"]];

        }
        [self configHeaderView];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        ZLLog(@"数据请求失败%@",error);
    }];
    
}
- (void)requestTwoModel{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    [manager GET:[NSString stringWithFormat:@"%@&offset=%ld", kUpdate, (long)offset] parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dic = responseObject;
        NSDictionary *DataDic = dic[@"data"];
        for (NSDictionary *dict in DataDic[@"items"]) {
            EveryUpdateModel *model = [[EveryUpdateModel alloc] initWithDictionary:dict];
            [self.allArray addObject:model];
             NSString *timeStr = [LHTools getDataFromString:dict[@"created_at"]];
            [self.timeArray addObject:timeStr];
        }
        //ZLLog(@"%@", self.allArray);
        ZLLog(@"数据请求成功");
        [self.tableView reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        ZLLog(@"数据请求失败%@", error);
    }];
    [self.tableView tableViewDidFinishedLoading];
    self.tableView.reachedTheEnd = NO;
}
#pragma mark----PullingRefreshTableViewDelegate
- (void)pullingTableViewDidStartRefreshing:(PullingRefreshTableView *)tableView{
    
}
- (void)pullingTableViewDidStartLoading:(PullingRefreshTableView *)tableView{
    offset += 20;
    [self performSelector:@selector(requestTwoModel) withObject:nil afterDelay:1.0];
}
//刷新完成时间
- (NSDate *)pullingTableViewRefreshingFinishedDate{
    return [LHTools getSystemNowDate];
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [self.tableView tableViewDidEndDragging:scrollView];
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.tableView tableViewDidScroll:scrollView];
}

#pragma mark---懒加载
- (PullingRefreshTableView *)tableView{
    if (_tableView == nil) {
        self.tableView = [[PullingRefreshTableView alloc] initWithFrame:self.view.frame pullingDelegate:self];
        self.tableView.dataSource = self;
        self.tableView.delegate = self;
        self.tableView.rowHeight = kWidth * 30 / 48;
    }
    return _tableView;
}
- (NSMutableArray *)cycleArray{
    if (_cycleArray == nil) {
        self.cycleArray = [NSMutableArray new];
    }
    return _cycleArray;
}
- (NSMutableArray *)updateArray{
    if (_updateArray == nil) {
        self.updateArray = [NSMutableArray new];
    }
    return _updateArray;
}
- (NSMutableArray *)allArray{
    if (_allArray == nil) {
        self.allArray = [NSMutableArray new];
    }
    return _allArray;
}
- (NSMutableArray *)timeArray{
    if (_timeArray == nil) {
        self.timeArray = [NSMutableArray new];
    }
    return _timeArray;
}
- (NSMutableArray *)idArray{
    if (_idArray == nil) {
        self.idArray = [NSMutableArray new];
    }
    return _idArray;
}
- (NSMutableArray *)nameArray{
    if (_nameArray == nil) {
        self.nameArray = [NSMutableArray new];
    }
    return _nameArray;
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
