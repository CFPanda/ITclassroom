//
//  ForgetViewController.m
//  ITclassroom
//
//  Created by motion on 16/2/22.
//  Copyright (c) 2016年 duanchuanfen. All rights reserved.
//

#import "ForgetViewController.h"
#import "ResetpasswordViewController.h"
#define kURLGetverify @"http://www.codingke.com:82/?r=comm/sms&mobile=%@&type=1&timestamp=1456393506&sign=2d1dc9e03925220b6a59b4f881be0a078af3ab98"
#define kURLNextStep @"http://www.codingke.com:82/?r=user/findpwd&user=%@&verify=%@&timestamp=1456393551&sign=c2d5923bec0d4098992e37a3bbcc03f793477057"
@interface ForgetViewController ()
@property (weak, nonatomic) IBOutlet UITextField *accountTextField;
@property (weak, nonatomic) IBOutlet UITextField *verificationCode;
@property (nonatomic,strong) NSString *phoneCode;
@end

@implementation ForgetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"忘记密码";



}

- (IBAction)pressGetCode:(UIButton *)sender {
    if (self.accountTextField.text.length == 0) {
        [self showAlertWithTitle:@"请输入账号"];
        return;
    }
    if (self.accountTextField.text.length < 11||self.accountTextField.text.length > 12) {
        [self showAlertWithTitle:@"电话号码格式不正确"];
        return;
    }
    
    NSString *phoneNumber = [self.accountTextField.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *urlString = [NSString stringWithFormat:kURLGetverify,phoneNumber];
    [self requestWithUrlString:urlString WithPrama:nil];


}



- (IBAction)pressNext:(UIButton *)sender {
   
    if ([self checkInfo]) {
        NSString *phoneNumber = [self.accountTextField.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSString *urlString = [NSString stringWithFormat:kURLNextStep,phoneNumber,self.phoneCode];
        [self requestWithUrlString:urlString WithPrama:nil];
        
    }
    
    


}

     
-(BOOL)checkInfo{
    if (_verificationCode.text.length == 0) {
        [self showAlertWithTitle:@"请输入验证码!"];
        
        return NO;
    }
    
    if ([_verificationCode.text isEqualToString:_phoneCode]) {
        [self showAlertWithTitle:@"验证码不正确,请重新输入!"];
        return NO;
    }
    
    return YES;


}

-(void)requestSuccessWithInfo:(NSDictionary *)info{
    if ([info[@"data"] count] > 1) {
        if ([info[@"code"] isEqualToString:@"200"]){
            ResetpasswordViewController *resetPassword = [[ResetpasswordViewController alloc]init];
            
            resetPassword.uid = info[@"data"][@"id"];
            [self.navigationController pushViewController:resetPassword animated:YES];
       }
        return;
    }else{
        [self showAlertWithTitle:info[@"msg"]];
    }
    
    if ([info[@"code"] isEqualToString:@"200"]) {
        
        _phoneCode = info[@"data"][@"date"];
        [self showAlertWithTitle:info[@"msg"]];
    }
    
    
    
}

@end
