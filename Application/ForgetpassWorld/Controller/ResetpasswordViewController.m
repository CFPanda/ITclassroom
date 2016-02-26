//
//  ResetpasswordViewController.m
//  ITclassroom
//
//  Created by motion on 16/2/22.
//  Copyright (c) 2016年 duanchuanfen. All rights reserved.
//
#define kURLResetpwd @"http://www.codingke.com:82/?r=user/reset&uid=%@&password=%@&password1=%@&timestamp=1456393610&sign=2ea340aa0c2e8fb01c52b7f14e5830cf662ac7ce"
#import "ResetpasswordViewController.h"
#import "LoginViewController.h"
@interface ResetpasswordViewController ()
@property (weak, nonatomic) IBOutlet UITextField *password;
@property (weak, nonatomic) IBOutlet UITextField *passwordTwo;


@end

@implementation ResetpasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"重置密码";
   
}


- (IBAction)pressFinish:(UIButton *)sender {
    
    if ([self checkInfo]) {
        NSString *urlString = [NSString stringWithFormat:kURLResetpwd,self.uid,self.password.text,self.passwordTwo.text];
        [self requestWithUrlString:urlString WithPrama:nil];
    }
 }

-(BOOL)checkInfo{
    
    if (_password.text.length == 0) {
        [self showAlertWithTitle:@"请输入密码"];
        return NO;
    }
    if (_passwordTwo.text.length == 0) {
        [self showAlertWithTitle:@"请确认输入"];
        return NO;
    }
    
    if (![_passwordTwo.text isEqualToString:_password.text]) {
        return NO;
    }
    
    return YES;
}

-(void)requestSuccessWithInfo:(NSDictionary *)info{
    if ([info[@"code"] isEqualToString:@"200"]) {
        [self performSelector:@selector(backLogin) withObject:nil afterDelay:2.0];
    }
    [self showAlertWithTitle:info[@"msg"]];
}

-(void)backLogin{
    
    LoginViewController *login = [[LoginViewController alloc]init];
    [self.navigationController pushViewController:login animated:YES];

}


@end
