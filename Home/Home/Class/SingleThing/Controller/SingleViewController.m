//
//  SingleViewController.m
//  Home
//
//  Created by scjy on 16/3/3.
//  Copyright © 2016年 scjy. All rights reserved.
//

#import "SingleViewController.h"
#import <AFNetworking/AFHTTPSessionManager.h>
#import "SingleModel.h"
#import "SingleCollectionViewCell.h"
#import "SVPullToRefresh.h"
#import "ItemContentViewController.h"
@interface SingleViewController ()<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>
{
    NSInteger offset;
}
@property (nonatomic, strong) UICollectionView *collectView;
@property (nonatomic, strong) NSMutableArray *itemArray;

@end

@implementation SingleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"单品";
    self.navigationController.navigationBar.barTintColor = kColor;
    offset = 0;
    __weak SingleViewController *weakSelf = self;
    //下拉刷新
//    [self.collectView addPullToRefreshWithActionHandler:^{
//        [weakSelf insertRowAtTop];
//    }];
    [self.collectView addInfiniteScrollingWithActionHandler:^{
        [weakSelf insertRowAtBottom];
    }];
    [self.view addSubview:self.collectView];
    [self requestModel];
    // Do any additional setup after loading the view.
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    self.tabBarController.tabBar.hidden = NO;
    [self.collectView triggerPullToRefresh];
}

#pragma mark---网络请求
- (void)requestModel{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    [manager GET:[NSString stringWithFormat:@"%@&offset=%ld", kItem, offset] parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dic1 = responseObject;
        NSDictionary *dic = dic1[@"data"];
        NSArray *array = dic[@"items"];
        for (NSDictionary *dic2 in array) {
            NSDictionary *dataDic = dic2[@"data"];
            SingleModel *model = [[SingleModel alloc] initWithDictionary:dataDic];
            [self.itemArray addObject:model];
        }
        [self.collectView reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        ZLLog(@"网络请求失败");
    }];
}
#pragma mark---UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.itemArray.count;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    SingleCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"single" forIndexPath:indexPath];
    cell.model = self.itemArray[indexPath.row];
    cell.backgroundColor = [UIColor whiteColor];
    cell.layer.cornerRadius = 5;
    cell.clipsToBounds = YES;

    return cell;
}
#pragma mark---UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    ItemContentViewController *gVC = [[ItemContentViewController alloc] init];
    SingleModel *model = self.itemArray[indexPath.row];
    gVC.idstr = model.idStr;
    [self.navigationController pushViewController:gVC animated:YES];
}
#pragma mark---UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake((kWidth - 15 ) / 2 , kWidth * 2 / 3);
}
-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}
#pragma mark---custom mothed

- (void)insertRowAtBottom{
    offset += 20;
    [self performSelector:@selector(requestModel) withObject:nil afterDelay:1.0];
}

#pragma mark---懒加载
- (UICollectionView *)collectView{
    if (_collectView == nil) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
//设置布局方向为垂直（默认垂直方向）
layout.scrollDirection = UICollectionViewScrollDirectionVertical;
//设置item的间距
layout.minimumInteritemSpacing = 5;
//设置每一行的间距
layout.minimumLineSpacing = 5;
//section的边距
layout.sectionInset = UIEdgeInsetsMake(0, 5, 5, 5);
//通过一个layout布局来创建一个collectView
self.collectView = [[UICollectionView alloc] initWithFrame:self.view.frame collectionViewLayout:layout];
//设置代理
self.collectView.dataSource = self;
self.collectView.delegate = self;
[self.collectView registerClass:[SingleCollectionViewCell class] forCellWithReuseIdentifier:@"single"];
self.collectView.backgroundColor = [UIColor colorWithRed:0.7 green:0.7 blue:0.7 alpha:0.3];

    }
    return _collectView;
}
- (NSMutableArray *)itemArray{
    if (_itemArray == nil) {
        self.itemArray = [NSMutableArray new];
    }
    return _itemArray;
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
