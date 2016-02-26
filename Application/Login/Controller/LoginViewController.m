//
//  LoginViewController.m
//  ITclassroom
//
//  Created by motion on 16/2/22.
//  Copyright (c) 2016年 duanchuanfen. All rights reserved.
//

#import "LoginViewController.h"
#import "RegistViewController.h"
#import "ForgetViewController.h"
#import <MediaPlayer/MediaPlayer.h>
#import "FirstPageViewController.h"
#import "RegistViewController.h"
#import "ForgetViewController.h"

#import "LessonViewController.h"
#import "PersonViewController.h"

#define kURLString  @"http://www.codingke.com:82/?r=user/login&user=%@&deviceid=a4c896262db0c33a&model=H60-L01&password=%@&timestamp=1452873001&sign=56f260e29d32128019cc176a2cf76d1930227d6f"
@interface LoginViewController ()<UITextFieldDelegate>
@property (weak,nonatomic) IBOutlet UITextField *accountTextField;
@property (weak,nonatomic) IBOutlet UITextField *passWorldTextField;
@property (weak,nonatomic) IBOutlet UIButton *remember;
@property (weak, nonatomic) IBOutlet UIButton *rememberButton;
@property(nonatomic,assign)BOOL statusRememberBtn;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"登陆";
    self.accountTextField.delegate = self;
    self.passWorldTextField.delegate = self;
    NSUserDefaults *deafults = [NSUserDefaults standardUserDefaults];
    NSString *user = [deafults valueForKey:@"user"];
    NSString *password = [deafults valueForKey:@"password"];
    _statusRememberBtn = [deafults boolForKey:@"statusRememberBtn"];
    if (user != nil&&password != nil&&_statusRememberBtn) {
        self.accountTextField.text = [deafults valueForKey:@"user"];
        self.passWorldTextField.text = [deafults valueForKey:@"password"];
    }
}


#pragma mark - 点击按钮  UI事件
//登陆按钮
- (IBAction)pressLogin:(UIButton *)sender {
    
    if ([self checkInfo]) {
        NSString *urlString = [NSString stringWithFormat:kURLString,self.accountTextField.text,self.passWorldTextField.text];
        
        [self requestWithUrlString:urlString WithPrama:nil];
    }
}


//记住密码按钮
- (IBAction)clickRemember:(UIButton *)sender {
    
    NSUserDefaults *defauts = [NSUserDefaults standardUserDefaults];
    sender.selected = !(sender.selected);
    if (sender.selected) {
        
        [defauts setObject:@YES forKey:@"statusRememberBtn"];
        [defauts setValue:_accountTextField.text forKey:@"user"];
        [defauts setValue:_passWorldTextField.text forKey:@"password"];
        [sender setTitle:@"清空密码" forState:(UIControlStateSelected)];
    }else {
        [defauts setObject:@NO forKey:@"statusRememberBtn"];
        [defauts setValue:_accountTextField.text forKey:@""];
        [defauts setValue:_passWorldTextField.text forKey:@""];
         self.accountTextField.text = @"";
        self.passWorldTextField.text = @"";
        [sender setTitle:@"记住密码" forState:(UIControlStateNormal)];
        _statusRememberBtn = NO;
    }
}

//注册按钮
- (IBAction)clickRegist:(UIButton *)sender {
    RegistViewController *regist = [[RegistViewController alloc]init];
    [self.navigationController pushViewController:regist animated:YES];
}


//忘记密码按钮
- (IBAction)clickForget:(UIButton *)sender {
    ForgetViewController *forget = [[ForgetViewController alloc]init];
    [self.navigationController pushViewController:forget animated:YES];
}

#pragma mark - 发送登陆请求
-(void)requestSuccessWithInfo:(NSDictionary *)info{
    NSLog(@"%@",info);
    if ([info[@"code"] isEqualToString:@"200"]) {
        
        [self createRootViewController];
        
    }else{
        [self showAlertWithTitle:info[@"msg"]];
     }
}


#pragma mark - 检查密码和账号是否已经输入 以及信息的格式是否正确.
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
    
    return YES;

}


#pragma mark - textFied 的代理方法
-(void)textFieldDidBeginEditing:(UITextField *)textField{
    [textField becomeFirstResponder];
    
}
-(void)textFieldDidEndEditing:(UITextField *)textField{
    [textField resignFirstResponder];
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    [_accountTextField resignFirstResponder];
    [_passWorldTextField resignFirstResponder];
}



#pragma mark - 登陆成功后切换主窗口的根视图控制器
-(void)createRootViewController{
    
    UITabBarController *tabbar = [[[UITabBarController alloc]init]init];
    FirstPageViewController *first = [[FirstPageViewController alloc]init];
    UINavigationController *nav1 = [[UINavigationController alloc]initWithRootViewController:first];
    first.tabBarItem.title = @"首页";
    UITabBarItem *item1 = [[UITabBarItem alloc]init];
    UIImage *normalImage1 = [[UIImage imageNamed:@"shouye"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIImage *selectedImage1 = [[UIImage imageNamed:@"shouye_select"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    item1.image = normalImage1;
    item1.selectedImage = selectedImage1;
    item1.title = @"首页";
    first.tabBarItem = item1;
    
    LessonViewController *lesson = [[LessonViewController alloc]init];
    UINavigationController *nav2 = [[UINavigationController alloc]initWithRootViewController:lesson];
    
     UITabBarItem *item2 = [[UITabBarItem alloc]init];
    UIImage *normalImage2 = [[UIImage imageNamed:@"课程"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIImage *selectedImage2 = [[UIImage imageNamed:@"kecheng_select"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    item2.image = normalImage2;
    item2.title = @"课程";
    item2.selectedImage = selectedImage2;
    lesson.tabBarItem = item2;
    
    
    PersonViewController *person = [[PersonViewController alloc]init];
    UINavigationController *nav3 = [[UINavigationController alloc]initWithRootViewController:person];
    UITabBarItem *item3 = [[UITabBarItem alloc]init];
    UIImage *normalImage3 = [[UIImage imageNamed:@"个人"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIImage *selectedImage3 = [[UIImage imageNamed:@"geren_select"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    item3.image = normalImage3;
    item3.title = @"个人";
    item3.selectedImage = selectedImage3;
    person.tabBarItem = item3;
    
    
    tabbar.viewControllers = @[nav1,nav2,nav3];
    UIWindow *keywindow = [[UIApplication sharedApplication] keyWindow];
    keywindow.rootViewController = tabbar;
}




@end
