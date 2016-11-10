//
//  KYSDataModel.m
//  KYSTableView
//
//  Created by 康永帅 on 16/8/13.
//  Copyright © 2016年 Kang YongShuai. All rights reserved.
//

#import "KYSDataModel.h"

@implementation KYSDataModel

- (instancetype)initWithDictionary:(NSDictionary *)dic{
    self=[super init];
    if (self) {
        if (dic) {
            self.name=dic[@"name"];
            self.age=[dic[@"age"] integerValue];
        }
    }
    return self;
}


#pragma mark - KYSNumDataPrococol
+ (KYSNumData *)transformWithDictionary:(NSDictionary *)dic{
    return [[KYSDataModel alloc] initWithDictionary:dic];
}

@end
