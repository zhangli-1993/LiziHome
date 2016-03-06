//
//  ThemeContentViewController.m
//  Home
//
//  Created by scjy on 16/3/6.
//  Copyright © 2016年 scjy. All rights reserved.
//

#import "ThemeContentViewController.h"
#import <AFNetworking/AFHTTPSessionManager.h>
#import "ThemeContentView.h"
@interface ThemeContentViewController ()
@property (nonatomic, strong) ThemeContentView *contentView;
@end

@implementation ThemeContentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"专题详情";
    [self showBackButton];
    self.tabBarController.tabBar.hidden = YES;
    [self.view addSubview:self.contentView];
    [self requestModel];
 
}
- (void)requestModel{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html",@"text/json", @"text/javascript", nil];
    [manager GET:[NSString stringWithFormat:@"%@%@", kThemeContent, self.idStr] parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dic = responseObject;
        NSDictionary *dataDic = dic[@"data"];
        self.contentView.dataDic = dataDic;
        ZLLog(@"数据请求成功");

        //[self.contentView reloadInputViews];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        ZLLog(@"数据请求失败");
    }];
}

- (ThemeContentView *)contentView{
    if (_contentView == nil) {
        self.contentView = [[ThemeContentView alloc] initWithFrame:self.view.frame];
    }
    return _contentView;
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
