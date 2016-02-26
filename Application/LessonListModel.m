//
//  LessonListModel.m
//  ITclassroom
//
//  Created by motion on 16/2/24.
//  Copyright (c) 2016年 duanchuanfen. All rights reserved.
//

#import "LessonListModel.h"

@implementation LessonListModel
-(void)setValue:(id)value forKey:(NSString *)key{
    if([key isEqualToString:@"id"]){
        _ID = value;
    }else{
        [super setValue:value forKey:key];
    }
}

-(void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
    
}
@end
