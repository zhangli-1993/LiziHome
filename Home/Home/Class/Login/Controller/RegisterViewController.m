//
//  RegisterViewController.m
//  Home
//
//  Created by scjy on 16/3/7.
//  Copyright © 2016年 scjy. All rights reserved.
//

#import "RegisterViewController.h"
#import <BmobSDK/Bmob.h>
#import "ProgressHUD.h"
#import "MineViewController.h"
#import "LoginViewController.h"
#import "AppDelegate.h"
@interface RegisterViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *userNumberTF;
@property (weak, nonatomic) IBOutlet UITextField *codeTF;
@property (weak, nonatomic) IBOutlet UITextField *sureTF;
@property (weak, nonatomic) IBOutlet UISwitch *lookSwitch;
@property (weak, nonatomic) IBOutlet UIButton *registerBtn;

@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"注册";
    self.navigationController.navigationBar.barTintColor = kColor;
    [self showBackButton];
    self.codeTF.secureTextEntry = YES;
    self.sureTF.secureTextEntry = YES;
    self.registerBtn.backgroundColor = kColor;
    [self.registerBtn addTarget:self action:@selector(registerAction) forControlEvents:UIControlEventTouchUpInside];
    self.lookSwitch.on = NO;
    [self.lookSwitch addTarget:self action:@selector(lookCode:) forControlEvents:UIControlEventTouchUpInside];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

    self.tabBarController.tabBar.hidden = YES;
}
- (void)lookCode:(UISwitch*)aaa{
    if (aaa.on) {
        self.codeTF.secureTextEntry = NO;
        self.sureTF.secureTextEntry = NO;
    } else {
        self.codeTF.secureTextEntry = YES;
        self.sureTF.secureTextEntry = YES;
        
    }}
- (void)registerAction{
    if (![self ckeckout]) {
        return;
    }
    [ProgressHUD show:@"注册中..."];
    BmobUser *user = [[BmobUser alloc] init];
    [user setUsername:self.userNumberTF.text];
    [user setPassword:self.codeTF.text];
    [user setMobilePhoneNumber:self.userNumberTF.text];
    [user signUpInBackgroundWithBlock:^(BOOL isSuccessful, NSError *error) {
        if (isSuccessful) {
            [ProgressHUD showSuccess:@"注册成功"];
            UIStoryboard *mine = [UIStoryboard storyboardWithName:@"MineStoryBoard" bundle:nil];
            MineViewController *lVC = [mine instantiateViewControllerWithIdentifier:@"mine"];
            [self.navigationController pushViewController:lVC animated:NO];
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            [userDefaults setObject:self.userNumberTF.text forKey:@"name"];
            [userDefaults setObject:self.codeTF.text forKey:@"password"];
            [lVC.LoginButton setTitle:self.userNumberTF.text forState:UIControlStateNormal];
            AppDelegate *myDelegate = [UIApplication sharedApplication].delegate;
            myDelegate.isLogin = YES;
            
            
            
        } else {
            [ProgressHUD showError:@"注册失败"];
        }
    }];
}
- (BOOL)ckeckout{
    if (self.userNumberTF.text.length <= 0 || [self.userNumberTF.text stringByReplacingOccurrencesOfString:@" " withString:@""].length <= 0) {
        //alert提示框
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"手机号码不能为空" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *alertAction1 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        UIAlertAction *alertAction2 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [alert addAction:alertAction1];
        [alert addAction:alertAction2];
        [self presentViewController:alert animated:YES completion:nil];
        return NO;
    }
    //两次输入密码一致
    if (![self.codeTF.text isEqualToString:self.sureTF.text]) {
        //alert提示框
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"两次输入密码不一致" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *alertAction1 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        UIAlertAction *alertAction2 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [alert addAction:alertAction1];
        [alert addAction:alertAction2];
        [self presentViewController:alert animated:YES completion:nil];
        
        return NO;
    }
    //输入的密码不能为空
    if (self.codeTF.text.length <= 0) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"密码不能为空" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *alertAction1 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        UIAlertAction *alertAction2 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [alert addAction:alertAction1];
        [alert addAction:alertAction2];
        [self presentViewController:alert animated:YES completion:nil];
        
        return NO;
    }
    if (self.codeTF.text.length < 6) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"密码长度不能少于6位" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *alertAction1 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        UIAlertAction *alertAction2 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [alert addAction:alertAction1];
        [alert addAction:alertAction2];
        [self presentViewController:alert animated:YES completion:nil];
        
        return NO;
    }
    //正则表达式
    //判断手机号是否有效
    if (![[NSPredicate predicateWithFormat:@"SELF MATCHES %@",@"^1[34578]\\d{9}$"] evaluateWithObject:self.userNumberTF.text]) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"手机号码错误" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *alertAction1 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        UIAlertAction *alertAction2 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        }];
        [alert addAction:alertAction1];
        [alert addAction:alertAction2];
        [self presentViewController:alert animated:YES completion:nil];
        
        return NO;

    }
    
    
    return YES;
    
}



#pragma mark---UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}
- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
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
