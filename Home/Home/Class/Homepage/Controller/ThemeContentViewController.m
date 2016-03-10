//
//  ThemeContentViewController.m
//  Home
//
//  Created by scjy on 16/3/6.
//  Copyright © 2016年 scjy. All rights reserved.
//

#import "ThemeContentViewController.h"
#import <AFNetworking/AFHTTPSessionManager.h>
#import "ItemContentViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "LoginViewController.h"
#import "ShareView.h"
@interface ThemeContentViewController ()<UIWebViewDelegate>
@property (nonatomic, strong) NSString *idstr1;
@property (strong, nonatomic) UIWebView *webView;
@property (strong, nonatomic) UIScrollView *scrollView;
@property (strong, nonatomic) UIImageView *headView;
@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UIButton *likeBtn;
@property (strong, nonatomic) UIButton *shareBtn;
@property (strong, nonatomic) UIView *footView;
@property (strong, nonatomic) UILabel *likeLabel;
@property (strong, nonatomic) UILabel *shareLabel;
@property (nonatomic, strong) ShareView *shareView;


@end

@implementation ThemeContentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"专题详情";
    [self showBackButton];
    [self.scrollView addSubview:self.headView];
    [self.scrollView addSubview:self.titleLabel];
    [self.scrollView addSubview:self.webView];
    [self.likeBtn addSubview:self.likeLabel];
    [self.shareBtn addSubview:self.shareLabel];
    [self.footView addSubview:self.likeBtn];
    [self.footView addSubview:self.shareBtn];
    [self.view addSubview:self.footView];
    [self.view addSubview:self.scrollView];
    [self requestModel];
}
- (void)viewWillAppear:(BOOL)animated{
    animated = NO;
    self.tabBarController.tabBar.hidden = YES;

    [self.webView reload];
    [self requestModel];


}

- (void)requestModel{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html",@"text/json", @"text/javascript", nil];
    [manager GET:[NSString stringWithFormat:@"%@%@", kThemeContent, self.idStr] parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dic = responseObject;
        NSDictionary *dataDic = dic[@"data"];
        [self.headView sd_setImageWithURL:[NSURL URLWithString:dataDic[@"cover_image_url"]]];
        self.titleLabel.text = dataDic[@"title"];
        [self.webView loadHTMLString:dataDic[@"content_html"] baseURL:[NSURL URLWithString:dataDic[@"content_url"]]];
        
        self.likeLabel.text = [NSString stringWithFormat:@"%@",dataDic[@"likes_count"]];
        self.shareLabel.text = [NSString stringWithFormat:@"%@",dataDic[@"shares_count"]];
        ZLLog(@"数据请求成功");
        [self reloadInputViews];

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        ZLLog(@"数据请求失败");
    }];
}
#pragma mark---UIWebViewDelegate
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    NSArray *arr = [webView subviews];
    UIScrollView *scrollView1 = [arr objectAtIndex:0];
    self.webView.frame = CGRectMake(0, kWidth / 1.6 + 60, kWidth, [scrollView1 contentSize].height);
    self.scrollView.contentSize = CGSizeMake(kWidth, [scrollView1 contentSize].height + kWidth / 1.6 + 60);
    [self reloadInputViews];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    NSLog(@"%@",request);
    NSString *urlStr = request.URL.absoluteString;
    NSArray *array = [urlStr componentsSeparatedByString:@"/"];
    NSString *string = array.lastObject;
     switch (navigationType) {
        case UIWebViewNavigationTypeLinkClicked:
        {
            ItemContentViewController *good = [[ItemContentViewController alloc] init];
            good.idstr = string;
            [self.navigationController pushViewController:good animated:YES];
        }
            break;
            
        default:
            break;
    }
    return YES;
}
- (void)share{
    self.shareView = [[ShareView alloc] init];
}
#pragma mark---懒加载
- (UIWebView *)webView{
    if (_webView == nil) {
        self.webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, kWidth / 1.6 + 60, kWidth, kHeight - kWidth / 1.6 - 100)];
        self.webView.delegate = self;
        self.webView.scalesPageToFit = YES;
        self.webView.opaque = NO;
        UIScrollView *tempView=(UIScrollView *)[self.webView.subviews objectAtIndex:0];
        tempView.scrollEnabled=NO;
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 20, 200, 50)];
        label.backgroundColor = kColor;
    }
    return _webView;
}
- (UIScrollView *)scrollView{
    if (_scrollView == nil) {
        self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kWidth, kHeight - 40)];
        self.scrollView.contentSize = CGSizeMake(kWidth, 10000);
    }
    return _scrollView;
}
- (UIImageView *)headView{
    if (_headView == nil) {
        self.headView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kWidth, kWidth / 1.6)];
    }
    return _headView;
}
- (UILabel *)titleLabel{
    if (_titleLabel == nil) {
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, kWidth / 1.6, kWidth - 30, 60)];
        self.titleLabel.font = [UIFont systemFontOfSize:19.0];
        self.titleLabel.numberOfLines = 0;
    }
    return _titleLabel;
}
- (UIView *)footView{
    if (_footView == nil) {
        self.footView = [[UIView alloc] initWithFrame:CGRectMake(0, kHeight - 40, kWidth, 40)];
        self.footView.backgroundColor = [UIColor whiteColor];
    }
    return _footView;
}
- (UIButton *)likeBtn{
    if (_likeBtn == nil) {
        self.likeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.likeBtn.frame = CGRectMake(80, 5, 60, 30);
        UIImageView *imageview = [[UIImageView alloc] initWithFrame:CGRectMake(0, 5, 20, 20)];
        imageview.image = [UIImage imageNamed:@"icon_like"];
        [self.likeBtn addSubview:imageview];
        
    }
    return _likeBtn;
}
- (UIButton *)shareBtn{
    if (_shareBtn == nil) {
        self.shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.shareBtn.frame = CGRectMake(kWidth - 140, 5, 60, 30);
        UIImageView *imageview = [[UIImageView alloc] initWithFrame:CGRectMake(0, 5, 20, 20)];
        imageview.image = [UIImage imageNamed:@"leaf"];
        [self.shareBtn addTarget:self action:@selector(share) forControlEvents:UIControlEventTouchUpInside];
        [self.shareBtn addSubview:imageview];
        
    }
    return _shareBtn;

}
- (UILabel *)likeLabel{
    if (_likeLabel == nil) {
        self.likeLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, 40, 30)];
        self.likeLabel.font = [UIFont systemFontOfSize:15.0];
        self.likeLabel.textColor = [UIColor grayColor];
    }
    return _likeLabel;
}
- (UILabel *)shareLabel{
    if (_shareLabel == nil) {
        self.shareLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, 40, 30)];
        self.shareLabel.font = [UIFont systemFontOfSize:15.0];
        self.shareLabel.textColor = [UIColor grayColor];
    }
    return _shareLabel;
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
