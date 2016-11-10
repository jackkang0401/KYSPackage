//
//  KYSCoreTextLink.m
//  KYSCoreText
//
//  Created by 康永帅 on 16/6/19.
//  Copyright © 2016年 康永帅. All rights reserved.
//

#import "KYSCoreTextLink.h"
#import "KYSCoreText.h"
#import "KYSCoreTextUtils.h"
#import "UIColor+StringToColor.h"

@interface KYSCoreTextLink()

@property (nonatomic,copy) NSString *url;

@end

@implementation KYSCoreTextLink

- (instancetype)initWithDic:(NSDictionary *)dic{
    self=[super initWithDic:dic];
    if (self) {
        self.url = dic[KYSCoreTextURL];
    }
    return self;
}

// 检测点击位置是否在链接上
+ (KYSCoreTextLink *)getTouchLinkInCTFrame:(CTFrameRef) frame
                                 linkArray:(NSArray *) linkArray
                                      view:(UIView *) view
                                   atPoint:(CGPoint) point{
    CFIndex index = [KYSCoreTextUtils getTouchIndexInCTFrame:frame view:view atPoint:point];
    NSLog(@"index: %ld",index);
    if (index>=0) {
        for (KYSCoreTextLink *link in linkArray) {
            if (NSLocationInRange(index, link.range)) {
                return link;
            }
        }
    }
    return nil;
}

@end
