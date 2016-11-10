//
//  KYSCoreTextTelephone.m
//  KYSCoreText
//
//  Created by Liu Zhao on 16/6/21.
//  Copyright © 2016年 康永帅. All rights reserved.
//

#import "KYSCoreTextTelephone.h"
#import "KYSCoreText.h"
#import "KYSCoreTextUtils.h"

@implementation KYSCoreTextTelephone

- (instancetype)initWithDic:(NSDictionary *)dic{
    self=[super initWithDic:dic];
    if (self) {
        
    }
    return self;
}

// 检测点击位置是否在电话上
+ (KYSCoreTextTelephone *)getTouchTelephoneInCTFrame:(CTFrameRef) frame
                                      telephoneArray:(NSArray *) telephoneArray
                                                view:(UIView *) view
                                             atPoint:(CGPoint) point{
    CFIndex index = [KYSCoreTextUtils getTouchIndexInCTFrame:frame view:view atPoint:point];
    NSLog(@"index: %ld",index);
    if (index>=0) {
        for (KYSCoreTextTelephone *telephone in telephoneArray) {
            if (NSLocationInRange(index, telephone.range)) {
                return telephone;
            }
        }
    }
    return nil;
}

@end
