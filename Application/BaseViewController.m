//
//  BaseViewController.m
//  ITclassroom
//
//  Created by motion on 16/2/22.
//  Copyright (c) 2016年 duanchuanfen. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

#pragma mark - 网络请求数据
-(void)requestWithUrlString:(NSString *)urlString WithPrama:(NSDictionary *)prama{
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager POST:urlString parameters:prama success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (responseObject != nil) {
            NSDictionary *info = [NSJSONSerialization JSONObjectWithData:responseObject options:(NSJSONReadingMutableLeaves) error:nil];
            [self requestSuccessWithInfo:info];
        }else{
            [self requestFailedWithError:@"没有数据..."];
        }
        
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [self requestFailedWithError:error.localizedDescription];
    
    }];

}

#pragma mark -请求成功

-(void)requestSuccessWithInfo:(NSDictionary *)info{
   
}

#pragma mark -请求失败
-(void)requestFailedWithError:(NSString *)error{
    
}

#pragma mark -弹出警告框
-(void)showAlertWithTitle:(NSString *)title{
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:title preferredStyle:(UIAlertControllerStyleAlert)];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleCancel) handler:^(UIAlertAction *action) {
        [alert dismissViewControllerAnimated:YES completion:nil];
    } ];
    [alert addAction:action];
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark -显示数据已经到最低了
-(void)showFinishLabel{
     self.finishLabel = [[UILabel alloc]initWithFrame:CGRectMake((self.view.frame.size.width-250)/2, 580, 250, 30)];
     self.finishLabel.text = @"亲~已经是全部数据啦!";
     self.finishLabel.font = [UIFont boldSystemFontOfSize:20];
     self.finishLabel.textAlignment = NSTextAlignmentCenter;
     self.finishLabel.layer.cornerRadius = 15;
     self.finishLabel.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.8];
     self.finishLabel.clipsToBounds = YES;
     self.finishLabel.textColor = [UIColor whiteColor];
     [self.view addSubview: self.finishLabel];
     self.finishLabel =  self.finishLabel;
     self.finishLabel.hidden = YES;
}


@end
