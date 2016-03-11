//
//  LoginViewController.m
//  Home
//
//  Created by scjy on 16/3/7.
//  Copyright © 2016年 scjy. All rights reserved.
//

#import "LoginViewController.h"
#import <BmobSDK/Bmob.h>
#import "MineViewController.h"
#import "AppDelegate.h"
@interface LoginViewController ()
@property (weak, nonatomic) IBOutlet UILabel *label1;
@property (weak, nonatomic) IBOutlet UILabel *label2;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
@property (weak, nonatomic) IBOutlet UIButton *forgetBtn;
@property (weak, nonatomic) IBOutlet UITextField *nameTF;
@property (weak, nonatomic) IBOutlet UITextField *codeTF;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.barTintColor = kColor;
    self.title = @"登录";
    [self showBackButton];
    self.label1.backgroundColor = kColor;
    self.label2.backgroundColor = kColor;
    self.codeTF.secureTextEntry = YES;
    self.loginBtn.backgroundColor = kColor;
    
    [self.loginBtn addTarget:self action:@selector(login) forControlEvents:UIControlEventTouchUpInside];
    // Do any additional setup after loading the view.
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

    self.tabBarController.tabBar.hidden = YES;
}
- (void)login{
   [BmobUser loginWithUsernameInBackground:self.nameTF.text password:self.codeTF.text block:^(BmobUser *user, NSError *error) {
       if (user) {

           ZLLog(@"登录成功");
           NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
           [userDefaults setObject:self.nameTF.text forKey:@"name"];
           [userDefaults setObject:self.codeTF.text forKey:@"password"];
           AppDelegate *myDelegate = [UIApplication sharedApplication].delegate;
           myDelegate.isLogin = YES;
           UIStoryboard *stro = [UIStoryboard storyboardWithName:@"MineStoryBoard" bundle:nil];
           MineViewController *mine = [stro instantiateViewControllerWithIdentifier:@"mine"];
           [mine.LoginButton setTitle:self.nameTF.text forState:UIControlStateNormal];
           [self.navigationController pushViewController:mine animated:YES];
          //[self.navigationController popViewControllerAnimated:YES];
           
       } else {
           ZLLog(@"登录失败%@",error);
           UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"账号或密码不正确" preferredStyle:UIAlertControllerStyleAlert];
           UIAlertAction *alertAction1 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
               
           }];
           UIAlertAction *alertAction2 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
               
           }];
           [alert addAction:alertAction1];
           [alert addAction:alertAction2];
           [self presentViewController:alert animated:YES completion:nil];
       }
   }];
    

    
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
