//
//  KYSCoreTextLink.h
//  KYSCoreText
//
//  Created by 康永帅 on 16/6/19.
//  Copyright © 2016年 康永帅. All rights reserved.
//

#import "KYSCoreTextText.h"
#import <CoreText/CoreText.h>

@interface KYSCoreTextLink : KYSCoreTextText

@property (nonatomic,copy,readonly) NSString *url;
@property (nonatomic,assign) NSRange range;

- (instancetype)initWithDic:(NSDictionary *)dic;

// 检测点击位置是否在链接上
+ (KYSCoreTextLink *)getTouchLinkInCTFrame:(CTFrameRef) frame
                                 linkArray:(NSArray *) linkArray
                                      view:(UIView *) view
                                   atPoint:(CGPoint) point;

@end
