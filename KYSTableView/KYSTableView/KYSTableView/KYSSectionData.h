//
//  KYSSectionData.h
//  KYSTableView
//
//  Created by Liu Zhao on 16/8/12.
//  Copyright © 2016年 Kang YongShuai. All rights reserved.
//

#import <Foundation/Foundation.h>

@class KYSNumData;

@interface KYSSectionData : NSObject

@property (nonatomic,strong) NSMutableArray *numsArray;

- (instancetype)initWithNumsArray:(NSMutableArray<KYSNumData *> *)numsArray;

@end
