    //
//  KYSSectionData.m
//  KYSTableView
//
//  Created by Liu Zhao on 16/8/12.
//  Copyright © 2016年 Kang YongShuai. All rights reserved.
//

#import "KYSSectionData.h"
#import "KYSNumData.h"

@implementation KYSSectionData

- (instancetype)init {
    return [self initWithNumsArray:nil];
}

- (instancetype)initWithNumsArray:(NSMutableArray<KYSNumData *> *)numsArray {
    self = [super init];
    if (self) {
        self.numsArray=[NSMutableArray arrayWithArray:numsArray];
    }
    return self;
}

@end
