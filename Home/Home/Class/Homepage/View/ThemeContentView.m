//
//  ThemeContentView.m
//  Home
//
//  Created by scjy on 16/3/6.
//  Copyright © 2016年 scjy. All rights reserved.
//

#import "ThemeContentView.h"
#import <SDWebImage/UIImageView+WebCache.h>
@interface ThemeContentView ()<UIWebViewDelegate>
@property (strong, nonatomic) UIWebView *webView;
@property (strong, nonatomic) UIScrollView *scrollView;
@property (strong, nonatomic) UIImageView *headView;
@property (strong, nonatomic) UILabel *titleLabel;

@end
@implementation ThemeContentView
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self configView];
    }
    return self;
}
- (void)configView{
    [self.scrollView addSubview:self.headView];
    [self.scrollView addSubview:self.titleLabel];
    [self.scrollView addSubview:self.webView];
    [self addSubview:self.scrollView];
}
- (void)setDataDic:(NSDictionary *)dataDic{
    [self.headView sd_setImageWithURL:[NSURL URLWithString:dataDic[@"cover_image_url"]]];
    self.titleLabel.text = dataDic[@"title"];
    [self.webView loadHTMLString:dataDic[@"content_html"] baseURL:[NSURL URLWithString:dataDic[@"content_url"]]];
}
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    NSArray *arr = [webView subviews];
    UIScrollView *scrollView1 = [arr objectAtIndex:0];
    self.webView.frame = CGRectMake(0, kWidth / 1.6 + 60, kWidth, [scrollView1 contentSize].height);
    self.scrollView.contentSize = CGSizeMake(kWidth, [scrollView1 contentSize].height + kWidth / 1.6 + 60);
}



- (UIWebView *)webView{
    if (_webView == nil) {
        self.webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, kWidth / 1.6 + 60, kWidth, kHeight - kWidth / 1.6 - 60)];
        self.webView.delegate = self;
        self.webView.scalesPageToFit = YES;
        self.webView.opaque = NO;
        UIScrollView *tempView=(UIScrollView *)[self.webView.subviews objectAtIndex:0];
        tempView.scrollEnabled=NO;
  
    }
    return _webView;
}
- (UIScrollView *)scrollView{
    if (_scrollView == nil) {
        self.scrollView = [[UIScrollView alloc] initWithFrame:self.frame];
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
@end
