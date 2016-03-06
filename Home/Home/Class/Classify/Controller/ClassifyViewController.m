//
//  ClassifyViewController.m
//  Home
//
//  Created by scjy on 16/3/3.
//  Copyright © 2016年 scjy. All rights reserved.
//

#import "ClassifyViewController.h"
#import <AFNetworking/AFHTTPSessionManager.h>
#import "ClassifyModel.h"
#import "ClassifyCollectionViewCell.h"
#import "KindViewController.h"
@interface ClassifyViewController ()<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>
@property (nonatomic, strong) UICollectionView *collectView;
@property (nonatomic, strong) NSMutableArray *placeArray;
@property (nonatomic, strong) NSMutableArray *kindArray;
@property (nonatomic, strong) NSMutableArray *allArray;


@end

@implementation ClassifyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"分类";
     self.navigationController.navigationBar.barTintColor = kColor;
    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(20, 25, kWidth, 40)];
    label1.text = @"地点";
    //label1.textColor = kColor;
    [self.collectView addSubview:label1];
    UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(20, 180 + (kWidth - 50 ) / 2, kWidth, 40)];
    label2.text = @"品类";
    //label2.textColor = kColor;
    [self.collectView addSubview:label2];
    [self.view addSubview:self.collectView];
    [self requestModel];

    // Do any additional setup after loading the view.
}
- (void)viewWillAppear:(BOOL)animated{
    self.tabBarController.tabBar.hidden = NO;

}
#pragma mark---custom method
- (void)requestModel{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    [manager GET:kClassify parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dic1 = responseObject;
        NSDictionary *dic2 = dic1[@"data"];
        NSArray *array1 = dic2[@"channel_groups"];
        NSArray *channel1 = array1[0][@"channels"];
        NSArray *channel2 = array1[1][@"channels"];
        for (NSDictionary *dic in channel1) {
            ClassifyModel *model = [[ClassifyModel alloc] initWithDictionary:dic];
            [self.placeArray addObject:model];
        }
        for (NSDictionary *dic in channel2) {
            ClassifyModel *model = [[ClassifyModel alloc] initWithDictionary:dic];
            [self.kindArray addObject:model];
        }
        [self.allArray addObject:self.placeArray];
        [self.allArray addObject:self.kindArray];
        [self.collectView reloadData];

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        ZLLog(@"数据请求失败");
    }];
}
#pragma mark---UICollectionViewDataSource, UICollectionViewDelegate,
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (section == 0) {
        return self.placeArray.count;
    }
    return self.kindArray.count;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    ClassifyCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"classify" forIndexPath:indexPath];
    NSArray *array = self.allArray[indexPath.section];
    cell.model = array[indexPath.row];
    cell.backgroundColor = [UIColor whiteColor];
    return cell;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return self.allArray.count;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    KindViewController *kindVC = [[KindViewController alloc] init];
    ClassifyModel *model = self.allArray[indexPath.section][indexPath.row];
     kindVC.idStr = model.idStr;
    kindVC.title = model.name;
    [self.navigationController pushViewController:kindVC animated:YES];
}

#pragma mark---UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake((kWidth - 50 ) / 4, (kWidth - 50 ) / 4 + 40);
}
-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
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
        layout.sectionInset = UIEdgeInsetsMake(70, 10, 0, 10);
        
        //通过一个layout布局来创建一个collectView
        self.collectView = [[UICollectionView alloc] initWithFrame:self.view.frame collectionViewLayout:layout];
        //设置代理
        self.collectView.dataSource = self;
        self.collectView.delegate = self;
        [self.collectView registerClass:[ClassifyCollectionViewCell class] forCellWithReuseIdentifier:@"classify"];
        self.collectView.backgroundColor = [UIColor whiteColor];
    }
    return _collectView;
}
- (NSMutableArray *)placeArray{
    if (_placeArray == nil) {
        self.placeArray = [NSMutableArray new];
    }
    return _placeArray;
}
- (NSMutableArray *)kindArray{
    if (_kindArray == nil) {
        self.kindArray = [NSMutableArray new];
    }
    return _kindArray;
}
- (NSMutableArray *)allArray{
    if (_allArray == nil) {
        self.allArray = [NSMutableArray new];
    }
    return _allArray;
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
