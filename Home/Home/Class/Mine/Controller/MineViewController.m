//
//  MineViewController.m
//  Home
//
//  Created by scjy on 16/3/3.
//  Copyright © 2016年 scjy. All rights reserved.
//

#import "MineViewController.h"
#import "LoginViewController.h"
@interface MineViewController ()
@property (weak, nonatomic) IBOutlet UIButton *LoginButton;

@end

@implementation MineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor brownColor];
    [self.LoginButton addTarget:self action:@selector(loginAction) forControlEvents:UIControlEventTouchUpInside];
    // Do any additional setup after loading the view.
}
- (void)loginAction{
    UIStoryboard *login = [UIStoryboard storyboardWithName:@"Login" bundle:nil];
    UINavigationController *nav = [login instantiateViewControllerWithIdentifier:@"login"];
    [self.navigationController presentViewController:nav animated:YES completion:nil];
    
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
