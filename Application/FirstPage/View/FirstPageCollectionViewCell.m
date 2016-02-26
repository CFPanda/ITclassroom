//
//  FirstPageCollectionViewCell.m
//  Codingke
//
//  Created by motion on 16/1/16.
//  Copyright (c) 2016年 duanchuanfen. All rights reserved.
//

#import "FirstPageCollectionViewCell.h"

@implementation FirstPageCollectionViewCell

//重写init方法
-(instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        
        [self createUI];
    
    }
    return self;
}

//创建自定义cell的控件
-(void)createUI{
    //图片
    _largePicture = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height-20)];
    _largePicture.backgroundColor = [UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:0.5];
    [self.contentView addSubview:_largePicture];
   
    //活动指示器
    _coverView = [[UIView alloc]initWithFrame:_largePicture.frame];
    
    UIActivityIndicatorView *activeView = [[UIActivityIndicatorView alloc]initWithFrame:_coverView.bounds];
    [_coverView addSubview:activeView];
    [activeView startAnimating];
    [self.contentView addSubview:_coverView];
    
    //灰色长条视图
    _grayView = [[UILabel alloc]initWithFrame:CGRectMake(0, self.frame.size.height-50, self.frame.size.width, 30)];
    _grayView.backgroundColor = [UIColor grayColor];
    _grayView.alpha = 0.3;
    [self.contentView addSubview:_grayView];
    
    //点击量Label
    _hitNum = [[UILabel alloc]initWithFrame:CGRectMake(5, self.frame.size.height-45, 70, 20)];
    _hitNum.font = [UIFont systemFontOfSize:12];
    _hitNum.textAlignment = NSTextAlignmentLeft;

    
    //课时Label
    _lessonNum = [[UILabel alloc]initWithFrame:CGRectMake(self.frame.size.width-60, self.frame.size.height-45, 50, 20)];
    _lessonNum.font = [UIFont systemFontOfSize:12];
    _lessonNum.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:_lessonNum];
    [self.contentView addSubview:_hitNum];
    
    //标题label
    _title = [[UILabel alloc]initWithFrame:CGRectMake(0,self.frame.size.height-20,self.frame.size.width, 20)];
    _title.font = [UIFont systemFontOfSize:12];
    [self.contentView addSubview:_title];
    
    
    
}

@end
