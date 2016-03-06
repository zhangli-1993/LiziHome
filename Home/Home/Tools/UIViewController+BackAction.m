//
//  UIViewController+BackAction.m
//  Home
//
//  Created by scjy on 16/3/5.
//  Copyright © 2016年 scjy. All rights reserved.
//

#import "UIViewController+BackAction.h"

@implementation UIViewController (BackAction)
- (void)showBackButton{
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(0, 0, 44, 44);
    [backBtn setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    backBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 0);
    [backBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftBtn = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem = leftBtn;
}

- (void)back{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
