//
//  PersonViewController.m
//  ITclassroom
//
//  Created by motion on 16/2/22.
//  Copyright (c) 2016年 duanchuanfen. All rights reserved.
//

#import "PersonViewController.h"
#import "EditInfoViewController.h"
@interface PersonViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView *tableView;
@end

@implementation PersonViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = YES;
    _tableView = [[UITableView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    _tableView.delegate =self;
    _tableView.dataSource = self;
    _tableView.scrollEnabled = NO;
    [self.view addSubview:_tableView];

    UIImageView *headView =[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 120)];
    headView.image = [UIImage imageNamed:@"navigationBarbackground"];
    
    
    UIButton *iconBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 100, 100)];
    iconBtn.center = CGPointMake(self.view.center.x, headView.frame.size.height/2);
    iconBtn.backgroundColor = [UIColor redColor];
    iconBtn.layer.cornerRadius = 50;
    [headView addSubview:iconBtn];
    [iconBtn addTarget:self action:@selector(pressIconBtn) forControlEvents:(UIControlEventTouchUpInside)];
    _tableView.tableHeaderView = headView;
}


-(void)pressIconBtn{
    



}




-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 2;
    }
    return 3;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:@"UITableViewCell"];
    }
    if (indexPath.section == 0&&indexPath.row == 0) {
        cell.textLabel.text  = @"编辑资料";
        cell.imageView.image = [UIImage imageNamed:@"bianjiziliao"];
    }
    if (indexPath.section == 0&& indexPath.row == 1) {
        cell.textLabel.text = @"我的课程";
        cell.imageView.image = [UIImage imageNamed:@"wodekecheng"];
    }
    if (indexPath.section == 1&& indexPath.row == 0) {
        cell.textLabel.text = @"意见反馈";
        cell.imageView.image = [UIImage imageNamed:@"yijiandankui"];
    }
    if (indexPath.section == 1&& indexPath.row == 1) {
        cell.textLabel.text = @"用户协议";
        cell.imageView.image = [UIImage imageNamed:@"yonghuxieyi"];
    }
    if (indexPath.section == 1&& indexPath.row == 2) {
        cell.textLabel.text = @"关于";
        cell.imageView.image = [UIImage imageNamed:@"guanyu"];
    }
    cell.textLabel.font = [UIFont boldSystemFontOfSize:20];
    
    
    return cell;
}


-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 0;
    }
    
    return 44;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 0) {
        return 0;
    }
    return 60;
}


-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (section == 0) {
        return nil;
    }
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44)];
    
    
    UIButton *button = [UIButton buttonWithType:(UIButtonTypeSystem)];
    button.frame = CGRectMake(10, 20, self.view.frame.size.width-20, 40);
    [button addTarget:self action:@selector(pressExit) forControlEvents:(UIControlEventTouchUpInside)];
    [button setBackgroundImage:[UIImage imageNamed:@"tuichuBtn"] forState:(UIControlStateNormal)];
    button.titleLabel.font = [UIFont boldSystemFontOfSize:20];
    [view addSubview:button];
    
    return view;
    
}


-(void)pressExit{
    
    exit(0);

}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    EditInfoViewController *edit = [[EditInfoViewController alloc]init];
    [self.navigationController pushViewController:edit animated:YES];
    
}

@end
