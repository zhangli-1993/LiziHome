//
//  CollectionViewController.m
//  Home
//
//  Created by scjy on 16/3/10.
//  Copyright © 2016年 scjy. All rights reserved.
//

#import "CollectionViewController.h"
#import "ThemeTableViewCell.h"
#import "DataBaseManager.h"
#import "Collect.h"
#import "EveryUpdateModel.h"
#import "ThemeContentViewController.h"
@interface CollectionViewController ()<UITableViewDataSource, UITableViewDelegate>
{
    NSString *identifier;
}
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *allArray;
@property (nonatomic, strong) NSMutableArray *idArray;

@end

@implementation CollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的收藏";
    self.navigationController.navigationBar.barTintColor = kColor;
    self.allArray = [NSMutableArray new];
    self.idArray = [NSMutableArray new];
    DataBaseManager *manager = [DataBaseManager sharedInstance];
    NSMutableArray *array = [manager selectAllCollect];
    for (Collect *collect in array) {
        EveryUpdateModel *model = [[EveryUpdateModel alloc] initWithDictionary:collect.dic];
        [self.allArray addObject:model];
        [self.idArray addObject:[NSString stringWithFormat:@"%ld", collect.num]];
    }
    identifier = @"theme";
    [self.tableView registerNib:[UINib nibWithNibName:@"ThemeTableViewCell" bundle:nil] forCellReuseIdentifier:identifier];
    [self.view addSubview:self.tableView];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ThemeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    cell.model = self.allArray[indexPath.row];
    return cell;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.allArray.count;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ThemeContentViewController *tvc = [[ThemeContentViewController alloc] init];
    tvc.idStr = self.idArray[indexPath.row];
    [self.navigationController pushViewController:tvc animated:YES];
}
#pragma mark---lazy
- (UITableView *)tableView{
    if (_tableView == nil) {
        self.tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
        self.tableView.dataSource = self;
        self.tableView.delegate = self;
        self.tableView.rowHeight = kWidth * 30 / 48;
    }
    return _tableView;
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
