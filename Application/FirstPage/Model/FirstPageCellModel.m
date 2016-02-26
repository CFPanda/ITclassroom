//
//  FirstPageCellModel.m
//  Codingke
//
//  Created by motion on 16/1/16.
//  Copyright (c) 2016年 duanchuanfen. All rights reserved.
//

#import "FirstPageCellModel.h"

@implementation FirstPageCellModel

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
