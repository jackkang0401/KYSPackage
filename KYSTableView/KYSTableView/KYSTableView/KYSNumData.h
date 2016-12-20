//
//  KYSNumData.h
//  KYSTableView
//
//  Created by Liu Zhao on 16/8/12.
//  Copyright © 2016年 Kang YongShuai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KYSProtocol.h"

// 模型要继承他
@interface KYSNumData : NSObject<KYSNumDataPrococol>


// 未使用固定高度存放自动计算的高度
@property(nonatomic,assign)CGFloat cellRegularHeight;

// 是不是固定高度： YES要主动设置cellRegularHeight的高度，  NO cellRegularHeight值为自动计算高度
@property (nonatomic, assign)BOOL  isRegularHeight;

@end
