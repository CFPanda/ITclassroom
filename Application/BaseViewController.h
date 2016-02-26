//
//  BaseViewController.h
//  ITclassroom
//
//  Created by motion on 16/2/22.
//  Copyright (c) 2016年 duanchuanfen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AFNetworking.h"
@interface BaseViewController : UIViewController<UIAlertViewDelegate>
@property(nonatomic,strong)UILabel *finishLabel;


-(void)requestWithUrlString:(NSString *)urlString WithPrama:(NSDictionary *)prama;
-(void)requestSuccessWithInfo:(NSDictionary *)info;
-(void)requestFailedWithError:(NSString *)error;



-(void)showAlertWithTitle:(NSString *)title;

-(void)showFinishLabel;


@end
