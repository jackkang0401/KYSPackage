//
//  KYSNumData.m
//  KYSTableView
//
//  Created by Liu Zhao on 16/8/12.
//  Copyright © 2016年 Kang YongShuai. All rights reserved.
//

#import "KYSNumData.h"

@implementation KYSNumData


#pragma mark - KYSNumDataPrococol
//子类需要复写
+ (KYSNumData *)transformWithDictionary:(NSDictionary *)dic{
    @throw [NSException exceptionWithName:@"数据模型"
                                   reason:@"子类需要复写此方法"
                                 userInfo:nil];
}

@end
