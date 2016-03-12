//
//  FindViewController.m
//  Home
//
//  Created by scjy on 16/3/11.
//  Copyright © 2016年 scjy. All rights reserved.
//

#import "FindViewController.h"
#import <BmobSDK/Bmob.h>
#import "ProgressHUD.h"
#import "LoginViewController.h"
@interface FindViewController ()<UITextFieldDelegate>
@property (nonatomic, strong) UITextField *numTF;
@property (nonatomic, strong) UITextField *verifyTF;
@property (nonatomic, strong) UIButton *sendBtn;
@property (nonatomic, strong) UIButton *nextBtn;
@property (nonatomic, assign) NSString *number;
@property (nonatomic, strong) UITextField *codeTF;
@property (nonatomic, strong) UILabel *label;


@end

@implementation FindViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"忘记密码";
    self.navigationController.navigationBar.barTintColor = kColor;
    self.view.backgroundColor = [UIColor colorWithRed:0.7 green:0.7 blue:0.7 alpha:0.3];
    self.numTF = [[UITextField alloc] initWithFrame:CGRectMake(0, 120, kWidth, 40)];
    self.numTF.placeholder = @"请输入手机号码";
    self.numTF.backgroundColor = [UIColor whiteColor];
    self.verifyTF = [[UITextField alloc] initWithFrame:CGRectMake(0, 161, kWidth * 2 / 3, 40)];
    self.verifyTF.placeholder = @"请输入验证码";
    self.verifyTF.backgroundColor = [UIColor whiteColor];
    self.sendBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.sendBtn.frame = CGRectMake(kWidth * 2 / 3 + 1, 161, kWidth / 3 - 1, 40);
    [self.sendBtn setTitle:@"发送验证码" forState:UIControlStateNormal];
    [self.sendBtn setTitleColor:kColor forState:UIControlStateNormal];
    self.sendBtn.backgroundColor = [UIColor whiteColor];
    [self.sendBtn addTarget:self action:@selector(sendVerity) forControlEvents:UIControlEventTouchUpInside];
    self.nextBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.nextBtn.frame = CGRectMake(50, 300, kWidth - 100, 40);
    [self.nextBtn setTitle:@"完成" forState:UIControlStateNormal];
    [self.nextBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.nextBtn.backgroundColor = kColor;
    [self.nextBtn addTarget:self action:@selector(next) forControlEvents:UIControlEventTouchUpInside];
    self.codeTF = [[UITextField alloc] initWithFrame:CGRectMake(0, 211, kWidth, 40)];
    self.codeTF.backgroundColor = [UIColor whiteColor];
    self.codeTF.placeholder = @"请重新设置密码";
    self.label = [[UILabel alloc] initWithFrame:CGRectMake(0, 251, kWidth, 30)];
    self.label.textAlignment = NSTextAlignmentCenter;
    self.label.text = @"密码可为6到20位的字母，数字，符号组合";
    self.label.font = [UIFont systemFontOfSize:13.0];
    self.label.textColor = [UIColor lightGrayColor];
    [self.view addSubview:self.numTF];
    [self.view addSubview:self.sendBtn];
    [self.view addSubview:self.verifyTF];
    [self.view addSubview:self.nextBtn];
    [self.view addSubview:self.codeTF];
    [self.view addSubview:self.label];
}
- (void)sendVerity{
    [BmobSMS requestSMSCodeInBackgroundWithPhoneNumber:self.numTF.text andTemplate:@"test" resultBlock:^(int number, NSError *error) {
        if (error) {
            ZLLog(@"%@", error);
        } else {
            [self.sendBtn setTitle:@"验证码已发送" forState:UIControlStateNormal];
        }
    }];
   
}
- (void)next{
    [BmobUser resetPasswordInbackgroundWithSMSCode:self.verifyTF.text andNewPassword:self.codeTF.text block:^(BOOL isSuccessful, NSError *error) {
        if (isSuccessful) {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"密码修改完成" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
           
                [self.navigationController popViewControllerAnimated:YES];
            }];
            [alert addAction:action];
            [self presentViewController:alert animated:YES completion:nil];
        } else {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"密码修改失败" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            [alert addAction:action];
            [self presentViewController:alert animated:YES completion:nil];
        }
    }];
   
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
