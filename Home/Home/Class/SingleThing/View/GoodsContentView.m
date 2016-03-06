//
//  GoodsContentView.m
//  Home
//
//  Created by scjy on 16/3/6.
//  Copyright © 2016年 scjy. All rights reserved.
//

#import "GoodsContentView.h"
#import <SDCycleScrollView.h>
@interface GoodsContentView ()<SDCycleScrollViewDelegate, UIWebViewDelegate>
{
    NSString *str;
}
@property (nonatomic, strong) UIScrollView *mainScrollView;
@property (nonatomic, strong) UIView *firstView;
@property (nonatomic, strong) SDCycleScrollView *CycleScrollView;
@property (nonatomic, strong) UIWebView *webView;
@property (nonatomic, strong) UIView *twoView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *priceLabel;
@property (nonatomic, strong) UILabel *descriptionLabel;
@property (nonatomic, strong) UILabel *introduceLabel;
@property (nonatomic, strong) UIButton *buyButton;
@property (nonatomic, strong) UIView *threeView;

@end

@implementation GoodsContentView
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {

        [self configView];
    }
    return self;
}
- (void)configView{
    self.backgroundColor = [UIColor whiteColor];
    [self.firstView addSubview:self.CycleScrollView];
    [self.firstView addSubview:self.titleLabel];
    [self.firstView addSubview:self.priceLabel];
    [self.firstView addSubview:self.descriptionLabel];
    [self.twoView addSubview:self.introduceLabel];
    [self.twoView addSubview:self.webView];
    [self.mainScrollView addSubview:self.firstView];
    [self.mainScrollView addSubview:self.twoView];
    [self addSubview:self.mainScrollView];
    [self addSubview:self.threeView];
    [self.threeView addSubview:self.buyButton];
    
}
- (void)setDataDic:(NSDictionary *)dataDic{
    self.CycleScrollView.imageURLStringsGroup = dataDic[@"image_urls"];
    self.titleLabel.text = dataDic[@"name"];
    self.priceLabel.text = [NSString stringWithFormat:@"￥%@", dataDic[@"price"]];
    self.descriptionLabel.text = dataDic[@"description"];
    [self.webView loadHTMLString:dataDic[@"detail_html"] baseURL:nil];
    [self.buyButton setTitle:dataDic[@"source"][@"button_title"] forState:UIControlStateNormal];
    str = self.dataDic[@"purchase_url"];
    [self.buyButton addTarget:self action:@selector(openBuy)forControlEvents:UIControlEventTouchUpInside];
    ZLLog(@"%@", str);

}
- (void)openBuy{
    ZLLog(@"%@", str);
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
}
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    NSArray *arr = [webView subviews];
    UIScrollView *scrollView1 = [arr objectAtIndex:0];
    self.webView.frame = CGRectMake(0, 40, kWidth, [scrollView1 contentSize].height);
    self.mainScrollView.contentSize = CGSizeMake(kWidth, [scrollView1 contentSize].height + kWidth * 5 / 4 + 60);
    
}



- (UIScrollView *)mainScrollView{
    if (_mainScrollView == nil) {
        self.mainScrollView = [[UIScrollView alloc] initWithFrame:self.frame];
    }
    return _mainScrollView;
}
- (UIView *)firstView{
    if (_firstView == nil) {
        self.firstView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWidth, kWidth * 5 / 4 - 20)];
        self.firstView.backgroundColor = [UIColor whiteColor];
    }
    return _firstView;
}
- (UIView *)twoView{
    if (_twoView == nil) {
        self.twoView = [[UIView alloc] initWithFrame:CGRectMake(0, kWidth * 5 / 4 - 20, kWidth,kHeight - kWidth * 5 / 4 + 20)];
        self.twoView.backgroundColor = [UIColor whiteColor];

    }
    return _twoView;
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
        self.webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 40, kWidth, 1000)];
        self.webView.delegate = self;
        self.webView.scalesPageToFit = YES;
        self.webView.opaque = NO;
        UIScrollView *tempView=(UIScrollView *)[self.webView.subviews objectAtIndex:0];
        tempView.scrollEnabled = NO;
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
- (UILabel *)introduceLabel{
    if (_introduceLabel == nil) {
        self.introduceLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kWidth, 40)];
        self.introduceLabel.textAlignment = NSTextAlignmentCenter;
        self.introduceLabel.text = @"图文介绍";
        self.introduceLabel.backgroundColor = kColor;
        self.introduceLabel.textColor = [UIColor whiteColor];
        
        
    }
    return _introduceLabel;
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

@end
