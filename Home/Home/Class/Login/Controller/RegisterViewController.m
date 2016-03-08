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
    [user signUpInBackgroundWithBlock:^(BOOL isSuccessful, NSError *error) {
        if (isSuccessful) {
            [ProgressHUD showSuccess:@"注册成功"];
        } else {
            [ProgressHUD showError:@"注册失败"];
        }
    }];
}
- (BOOL)ckeckout{
    if (self.userNumberTF.text.length <= 0 || [self.userNumberTF.text stringByReplacingOccurrencesOfString:@" " withString:@""].length <= 0) {
        //alert提示框
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"用户名不能为空" preferredStyle:UIAlertControllerStyleAlert];
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
    if (self.codeTF.text.length < 8) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"密码长度不能少于8位" preferredStyle:UIAlertControllerStyleAlert];
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
    //判断邮箱是否存在
    if (![[NSPredicate predicateWithFormat:@"SELF MATCHES %@",@"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"] evaluateWithObject:self.codeTF.text]) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"邮箱账号错误" preferredStyle:UIAlertControllerStyleAlert];
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
