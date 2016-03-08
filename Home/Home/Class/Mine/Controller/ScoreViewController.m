//
//  ScoreViewController.m
//  Home
//
//  Created by scjy on 16/3/8.
//  Copyright © 2016年 scjy. All rights reserved.
//

#import "ScoreViewController.h"
#import "LPLevelView.h"
@interface ScoreViewController ()
@end

@implementation ScoreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self showBackButton];
   
    self.navigationController.navigationBar.barTintColor = kColor;
    //纯代码初始化
    LPLevelView *lView = [LPLevelView new];
    lView.frame = CGRectMake(100, 170, kWidth - 200, 100);
    lView.iconColor = kColor;
    lView.iconSize = CGSizeMake(50, 50);
    lView.canScore = YES;
    lView.animated = YES;
    lView.level = 3.5;
    [lView setScoreBlock:^(float level) {
        NSLog(@"打分：%f", level);
    }];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(100, 280, kWidth - 200, 40)];
    label.textAlignment = NSTextAlignmentCenter;
    label.text = @"期待您的评分";
    label.textColor = kColor;
    label.font = [UIFont systemFontOfSize:19.0];
    [self.view addSubview:label];
    [self.view addSubview:lView];

    // Do any additional setup after loading the view.
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
