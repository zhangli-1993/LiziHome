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
@interface SingleViewController ()<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>
@property (nonatomic, strong) UICollectionView *collectView;
@property (nonatomic, strong) NSMutableArray *itemArray;

@end

@implementation SingleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"单品";
    self.navigationController.navigationBar.barTintColor = kColor;
    [self.collectView registerNib:[UINib nibWithNibName:@"SingleCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"single"];
    [self.view addSubview:self.collectView];
    [self requestModel];
    // Do any additional setup after loading the view.
}
#pragma mark---网络请求
- (void)requestModel{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    [manager GET:kItem parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dic1 = responseObject;
        NSArray *array = dic1[@"data"][@"items"];
        for (NSDictionary *dic2 in array) {
            NSDictionary *dataDic = dic2[@"data"];
            SingleModel *model = [[SingleModel alloc] initWithDictionary:dataDic];
            [self.itemArray addObject:model];
        }
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
    cell.backgroundColor = [UIColor orangeColor];
    ZLLog(@"```%@", cell.model);
    return cell;
    
}
#pragma mark---UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
}
#pragma mark---UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake((kWidth - 15 ) / 2 , kWidth - 15);
}

#pragma mark---懒加载
- (UICollectionView *)collectView{
    if (_collectView == nil) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        //设置布局方向为垂直（默认垂直方向）
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        layout.headerReferenceSize = CGSizeMake(kWidth, 137);
        //设置item的间距
        layout.minimumInteritemSpacing = 5;
        //设置每一行的间距
        layout.minimumLineSpacing = 5;
        //section的边距
        layout.sectionInset = UIEdgeInsetsMake(0, 5, 5, 5);
        //设置每个item的大小
        //layout.itemSize = CGSizeMake((kWidth - 15 ) / 2 , kWidth - 15);
        //通过一个layout布局来创建一个collectView
        self.collectView = [[UICollectionView alloc] initWithFrame:self.view.frame collectionViewLayout:layout];
        self.collectView.backgroundColor = [UIColor colorWithRed:0.7 green:0.7 blue:0.7 alpha:0.7];
        //设置代理
        self.collectView.dataSource = self;
        self.collectView.delegate = self;
        [self.collectView registerClass:[SingleCollectionViewCell class] forCellWithReuseIdentifier:@"single"];
        
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
