//
//  KYSDataModel.h
//  KYSTableView
//
//  Created by 康永帅 on 16/8/13.
//  Copyright © 2016年 Kang YongShuai. All rights reserved.
//

#import "KYSNumData.h"

@interface KYSDataModel : KYSNumData

@property(nonatomic,copy)NSString *name;
@property(nonatomic,assign)NSInteger age;

- (instancetype)initWithDictionary:(NSDictionary *)dic;

@end
