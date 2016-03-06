//
//  KindViewController.m
//  Home
//
//  Created by scjy on 16/3/5.
//  Copyright © 2016年 scjy. All rights reserved.
//

#import "KindViewController.h"
#import "EveryUpdateModel.h"
#import "ThemeTableViewCell.h"
#import "SVPullToRefresh.h"
#import <AFNetworking/AFHTTPSessionManager.h>
#import "ThemeContentViewController.h"
@interface KindViewController ()<UITableViewDataSource, UITableViewDelegate>
{
    NSString *identifier;
    NSInteger offset;

}
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *themeArray;
@end

@implementation KindViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.barTintColor = kColor;
    [self showBackButton];
    self.tabBarController.tabBar.hidden = YES;
    identifier = @"theme";
    offset = 0;
    [self.tableView registerNib:[UINib nibWithNibName:@"ThemeTableViewCell" bundle:nil] forCellReuseIdentifier:identifier];
    __weak KindViewController *weakSelf = self;
    [self.tableView addInfiniteScrollingWithActionHandler:^{
        [weakSelf insertRowAtBottom];
    }];
    [self.view addSubview:self.tableView];
    [self requestModel];
}

#pragma mark---UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.themeArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ThemeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    cell.model = self.themeArray[indexPath.row];
    return cell;
}



#pragma mark---UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ThemeContentViewController *tVC = [[ThemeContentViewController alloc] init];
    EveryUpdateModel *model = self.themeArray[indexPath.row];
    tVC.idStr = model.idStr;
    [self.navigationController pushViewController:tVC animated:YES];
    
}
#pragma mark---数据请求
- (void)requestModel{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    [manager GET:[NSString stringWithFormat:@"%@%@/items?limit=20&gender=2&generation=1&offset=%ld", kKind, self.idStr, offset] parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dic = responseObject;
        NSDictionary *DataDic = dic[@"data"];
        for (NSDictionary *dict in DataDic[@"items"]) {
            EveryUpdateModel *model = [[EveryUpdateModel alloc] initWithDictionary:dict];
            [self.themeArray addObject:model];
        }
        [self.tableView reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        ZLLog(@"数据请求失败%@",error);
    }];
    
}
- (void)insertRowAtBottom{
    offset += 20;
    [self performSelector:@selector(requestModel) withObject:nil afterDelay:1.0];
}


#pragma mark---懒加载
- (UITableView *)tableView{
    if (_tableView == nil) {
        self.tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.tableView.rowHeight = kWidth * 0.57;
        self.tableView.backgroundColor = [UIColor colorWithRed:0.7 green:0.7 blue:0.7 alpha:0.3];
    }
    return _tableView;
}
- (NSMutableArray *)themeArray{
    if (_themeArray == nil) {
        self.themeArray = [NSMutableArray new];
    }
    return _themeArray;
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
