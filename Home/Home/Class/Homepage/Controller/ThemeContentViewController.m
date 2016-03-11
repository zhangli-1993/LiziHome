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
#import "DataBaseManager.h"
#import "AppDelegate.h"
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
@property (nonatomic, strong) NSDictionary *dataDic;


@end

@implementation ThemeContentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"专题详情";
    [self showBackButton];
    [self.scrollView addSubview:self.headView];
    [self.scrollView addSubview:self.titleLabel];
    [self.scrollView addSubview:self.webView];
    DataBaseManager *manager = [DataBaseManager sharedInstance];
    NSMutableArray *array = [manager selectAllCollectWithNum:[self.idStr integerValue]];
    if (array.count > 0) {
        [self.likeBtn setTitle:@"取消收藏" forState:UIControlStateNormal];
        self.likeBtn.tag = 110;
    } else {
        [self.likeBtn setTitle:@"收藏"forState:UIControlStateNormal];
        self.likeBtn.tag = 111;
    }
    [self.footView addSubview:self.likeBtn];
    [self.footView addSubview:self.shareBtn];
    [self.view addSubview:self.footView];
    [self.view addSubview:self.scrollView];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
    [self requestModel];
    [self.webView reload];



}

- (void)requestModel{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html",@"text/json", @"text/javascript", nil];
    [manager GET:[NSString stringWithFormat:@"%@%@", kThemeContent, self.idStr] parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        self.dataDic = [NSDictionary new];
        NSDictionary *dic = responseObject;
        self.dataDic = dic[@"data"];
        [self.headView sd_setImageWithURL:[NSURL URLWithString:self.dataDic[@"cover_image_url"]]];
        self.titleLabel.text = self.dataDic[@"title"];
        [self.webView loadHTMLString:self.dataDic[@"content_html"] baseURL:[NSURL URLWithString:self.dataDic[@"content_url"]]];
        
        self.likeLabel.text = [NSString stringWithFormat:@"%@",self.dataDic[@"likes_count"]];
        self.shareLabel.text = [NSString stringWithFormat:@"%@",self.dataDic[@"shares_count"]];
        ZLLog(@"数据请求成功");
//        [self reloadInputViews];

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
//    [self reloadInputViews];
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
            UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:good];
            good.idstr = string;
            [self presentViewController:nav animated:YES completion:nil];
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

- (void)like:(UIButton *)btn{
    AppDelegate *myDelegate = [[UIApplication sharedApplication] delegate];
    if (myDelegate.isLogin == NO) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"要登录才可以收藏哦" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    } else {
    DataBaseManager *manager= [DataBaseManager sharedInstance];
    if (btn.tag == 111) {
        [manager insertIntoCollect:self.dataDic withNumber:[self.idStr integerValue]];
        [btn setTitle:@"取消收藏" forState:UIControlStateNormal];
        btn.tag = 110;
    } else {
        [manager deleteWithNum:[self.idStr integerValue]];
        [btn setTitle:@"收藏" forState:UIControlStateNormal];
        btn.tag = 111;
    }
}
    
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
        self.footView.backgroundColor = [UIColor colorWithRed:0.7 green:0.7 blue:0.7 alpha:0.3];
    }
    return _footView;
}
- (UIButton *)likeBtn{
    if (_likeBtn == nil) {
        self.likeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.likeBtn.frame = CGRectMake(60, 5, (kWidth - 180) / 2, 30);
        self.likeBtn.backgroundColor = kColor;
        self.likeBtn.layer.cornerRadius = 5;
        self.likeBtn.clipsToBounds = YES;
 
        self.likeBtn.titleLabel.font = [UIFont systemFontOfSize:18.0];
        self.likeBtn.titleLabel.textColor = [UIColor whiteColor];

        [self.likeBtn addTarget:self action:@selector(like:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _likeBtn;
}
- (UIButton *)shareBtn{
    if (_shareBtn == nil) {
        self.shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.shareBtn.frame = CGRectMake(kWidth / 2 + 30, 5, (kWidth - 180) / 2, 30);
//        [self.shareBtn setImage:[UIImage imageNamed:@"leaf"] forState:UIControlStateNormal];
//        self.shareBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, self.shareBtn.frame.size.width * 2 / 3);
        [self.shareBtn setTitle:@"分享"forState:UIControlStateNormal];
        self.shareBtn.backgroundColor = kColor;
        self.shareBtn.layer.cornerRadius = 5;
        self.shareBtn.clipsToBounds = YES;
       // self.shareBtn.titleEdgeInsets = UIEdgeInsetsMake(0, -self.shareBtn.frame.size.width * 1 / 3, 0, 0);
        self.shareBtn.titleLabel.font = [UIFont systemFontOfSize:18.0];
        self.shareBtn.titleLabel.textColor = [UIColor whiteColor];
        [self.shareBtn addTarget:self action:@selector(share) forControlEvents:UIControlEventTouchUpInside];
   
        
    }
    return _shareBtn;

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
