//
//  ItemContentViewController.m
//  Home
//
//  Created by scjy on 16/3/7.
//  Copyright © 2016年 scjy. All rights reserved.
//

#import "ItemContentViewController.h"
#import <SDCycleScrollView.h>
#import <AFNetworking/AFHTTPSessionManager.h>
@interface ItemContentViewController ()<UITableViewDataSource,
UITableViewDelegate, SDCycleScrollViewDelegate, UIWebViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) SDCycleScrollView *CycleScrollView;
@property (nonatomic, strong) UIWebView *webView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *priceLabel;
@property (nonatomic, strong) UILabel *descriptionLabel;
@property (nonatomic, strong) UIButton *buyButton;
@property (nonatomic, strong) UIView *threeView;
@property (nonatomic, strong) NSDictionary *dataDic;


@end

@implementation ItemContentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"商品详情";
    self.tabBarController.tabBar.hidden = YES;
    self.navigationController.navigationBar.barTintColor = kColor;
    [self.threeView addSubview:self.buyButton];
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.threeView];

    [self showBackButton];
    [self setHeadView];
    [self requestModel];
}
- (void)viewWillAppear:(BOOL)animated{
    [self.tableView reloadData];
}
#pragma mark---自定义
- (void)requestModel{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html",@"text/json", @"text/javascript", nil];
    [manager GET:[NSString stringWithFormat:@"%@%@", kGoodsContent, self.idstr] parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dic = responseObject;
        self.dataDic = [NSDictionary new];
        self.dataDic = dic[@"data"];
        self.CycleScrollView.imageURLStringsGroup = self.dataDic[@"image_urls"];
        self.titleLabel.text = self.dataDic[@"name"];
        self.priceLabel.text = [NSString stringWithFormat:@"￥%@", self.dataDic[@"price"]];
        self.descriptionLabel.text = self.dataDic[@"description"];
        [self.webView loadHTMLString:self.dataDic[@"detail_html"] baseURL:nil];
        [self.buyButton setTitle:self.dataDic[@"source"][@"button_title"] forState:UIControlStateNormal];
        [self.buyButton addTarget:self action:@selector(buyAction) forControlEvents:UIControlEventTouchUpInside];
        ZLLog(@"数据请求成功");
        [self.tableView reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        ZLLog(@"数据请求失败%@", error);
    }];
}
- (void)buyAction{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.dataDic[@"purchase_url"]]];
//    [self.webView loadHTMLString:self.dataDic[@"purchase_url"] baseURL:nil];
}
- (void)setHeadView{
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWidth, kWidth * 5 / 4 - 20)];
    headView.backgroundColor = [UIColor whiteColor];
    self.tableView.tableHeaderView = headView;
    
    [headView addSubview:self.CycleScrollView];
    [headView addSubview:self.titleLabel];
    [headView addSubview:self.priceLabel];
    [headView addSubview:self.descriptionLabel];
    
}

#pragma mark---UITableViewDataSource, UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *str = @"goods";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:str];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:str];
    }
    
    [cell addSubview:self.webView];
    return cell;
    
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return @"图文详情";
}
#pragma mark---UIWebViewDelegate
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    NSArray *arr = [webView subviews];
    UIScrollView *scrollView1 = [arr objectAtIndex:0];
    self.webView.frame = CGRectMake(0, 0, kWidth, [scrollView1 contentSize].height);
    ZLLog(@"%f", [scrollView1 contentSize].height);
    self.tableView.rowHeight = [scrollView1 contentSize].height;
    [self.tableView reloadData];
}

#pragma mark---懒加载
- (UITableView *)tableView{
    if (_tableView == nil) {
        self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kWidth, kHeight) style:UITableViewStylePlain];
        self.tableView.dataSource = self;
        self.tableView.delegate = self;
    }
    return _tableView;
}
- (SDCycleScrollView *)CycleScrollView{
    if (_CycleScrollView == nil) {
        self.CycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, kWidth, kWidth * 3 / 4) delegate:self placeholderImage:nil];
        self.CycleScrollView.autoScrollTimeInterval = 2.0;
    }
    return _CycleScrollView;
}
- (UIWebView *)webView{
    if (_webView == nil) {
        self.webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, kWidth, 1000)];
        self.webView.delegate = self;
        self.webView.scalesPageToFit = YES;
        self.webView.opaque = NO;
        
    }
    return _webView;
}
- (UILabel *)titleLabel{
    if (_titleLabel == nil) {
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, kWidth * 3 / 4, kWidth - 30, 40)];
        self.titleLabel.font = [UIFont systemFontOfSize:21.0];
    }
    return _titleLabel;
}
- (UILabel *)priceLabel{
    if (_priceLabel == nil) {
        self.priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, kWidth * 3 / 4 + 40, kWidth - 30, 40)];
        self.priceLabel.font = [UIFont systemFontOfSize:19.0];
        self.priceLabel.textColor = kColor;
    }
    return _priceLabel;
}
- (UILabel *)descriptionLabel{
    if (_descriptionLabel == nil) {
        self.descriptionLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, kWidth * 3 / 4 + 70, kWidth - 30, kWidth / 2 - 90)];
        self.descriptionLabel.numberOfLines = 0;
    }
    return _descriptionLabel;
}

- (UIView *)threeView{
    if (_threeView == nil) {
        self.threeView = [[UIView alloc] initWithFrame:CGRectMake(0, kHeight - 50, kWidth, 50)];
        self.threeView.backgroundColor = [UIColor colorWithRed:0.7 green:0.7 blue:0.7 alpha:0.3];
    }
    return _threeView;
}
- (UIButton *)buyButton{
    if (_buyButton == nil) {
        self.buyButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.buyButton.frame = CGRectMake(80, 10, kWidth - 160, 30);
        self.buyButton.backgroundColor = kColor;
        [self.buyButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
    return _buyButton;
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
