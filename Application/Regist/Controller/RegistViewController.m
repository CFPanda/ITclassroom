//
//  RegistViewController.m
//  ITclassroom
//
//  Created by motion on 16/2/22.
//  Copyright (c) 2016年 duanchuanfen. All rights reserved.
//

#import "RegistViewController.h"
#define kURLStringVCode  @"http://www.codingke.com:82/?r=comm/sms&mobile=%@&type=0&timestamp=1456376377&sign=219493e13ce3e1e637a808b0b2fbc8b6077c75cf"

#define kURLStringRegist @"http://www.codingke.com:82/?r=user/reg&user=%@&deviceid=a4c896262db0c33a&model=H60-L01&password=%@&timestamp=1456376433&sign=84046db10d59a1f26754be8b4d4dd22960ce8217"
@interface RegistViewController ()
@property (weak,nonatomic) IBOutlet UITextField *accountTextField;
@property (weak,nonatomic) IBOutlet UITextField *passWorldTextField;
@property (weak,nonatomic) IBOutlet UITextField *passWorldTextFieldTwo;
@property (weak,nonatomic) IBOutlet UITextField *verificationCode;
@property (nonatomic,strong) NSString *phoneCode;
@end

@implementation RegistViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"注册";
    
    
}

#pragma mark - 获取验证码
- (IBAction)getVerificationCode:(UIButton *)sender {
    if (self.accountTextField.text.length == 0) {
        [self showAlertWithTitle:@"请输入手机号!"];
    
    }else  if(self.accountTextField.text.length < 11){
        [self showAlertWithTitle:@"手机号码格式错误!"];
    }else {
        NSString *phoneNumber = [self.accountTextField.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        NSString *urlString = [NSString stringWithFormat:kURLStringVCode,phoneNumber];
        [self requestWithUrlString:urlString WithPrama:nil];
    }
}

#pragma mark - 发送注册请求
-(void)requestSuccessWithInfo:(NSDictionary *)info{
    if ([info[@"data"] count] > 1) {
        if ([info[@"code"] isEqualToString:@"200"]){
            [self showAlertWithTitle:@"注册成功,返回登陆"];
            
        }else{
            [self showAlertWithTitle:info[@"msg"]];
        }
        
     }else{
        
         if ([info[@"code"] isEqualToString:@"200"]) {
            [self showAlertWithTitle:info[@"msg"]];
            _phoneCode = info[@"data"][@"date"];
        }else {
            [self showAlertWithTitle:@"注册失败,请重试!"];
        }
    }
    
    
    


}



- (IBAction)pressRegistBtn:(id)sender {
    if ([self checkInfo]) {
        
        NSString *urlString = [NSString stringWithFormat:kURLStringRegist,self.accountTextField.text,self.passWorldTextField.text];
        [self requestWithUrlString:urlString WithPrama:nil];
       
}
    
   
    
    
    



}

-(BOOL)checkInfo{
    if (_accountTextField.text.length == 0) {
        [self showAlertWithTitle:@"账号不能为空"];
        return NO;
    }
    
    if (_passWorldTextField.text.length == 0) {
        [self showAlertWithTitle:@"密码不能为空"];
        return NO;
    }
    
    if (_passWorldTextField.text.length < 6) {
        [self showAlertWithTitle:@"密码不能小于6位"];
        return NO;
    }
    
    
    if (self.verificationCode.text.length == 0) {
        [self showAlertWithTitle:@"请输入验证码!"];
        return NO;
    }
    if (self.verificationCode.text > 0&&self.verificationCode.text.length < 6) {
        [self showAlertWithTitle:@"验证码格式不正确"];
        return NO;
    }
    
    if (![self.verificationCode.text isEqualToString:_phoneCode]) {
        [self showAlertWithTitle:@"验证码格式不正确"];
        return NO;
    }
    
    if (![self.passWorldTextField.text isEqualToString:self. passWorldTextFieldTwo.text]) {
        [self showAlertWithTitle:@"两次密码输入不一致!"];
        
        return NO;
    }

    
    return YES;
    
}


@end
