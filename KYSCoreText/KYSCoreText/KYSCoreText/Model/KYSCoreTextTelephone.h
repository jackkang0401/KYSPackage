//
//  KYSCoreTextTelephone.h
//  KYSCoreText
//
//  Created by Liu Zhao on 16/6/21.
//  Copyright © 2016年 康永帅. All rights reserved.
//

#import "KYSCoreTextText.h"
#import <CoreText/CoreText.h>

@interface KYSCoreTextTelephone : KYSCoreTextText

@property (nonatomic,assign) NSRange range;

// 检测点击位置是否在电话上
+ (KYSCoreTextTelephone *)getTouchTelephoneInCTFrame:(CTFrameRef) frame
                                      telephoneArray:(NSArray *) telephoneArray
                                                view:(UIView *) view
                                             atPoint:(CGPoint) point;

@end
