//
//  KYSCoreTextLineImage.m
//  KYSCoreText
//
//  Created by Liu Zhao on 16/6/30.
//  Copyright © 2016年 康永帅. All rights reserved.
//

#import "KYSCoreTextLineImage.h"
#import "KYSCoreText.h"

@interface KYSCoreTextLineImage()

@property(nonatomic,strong)NSDictionary *dic;

@end


@implementation KYSCoreTextLineImage

- (instancetype)initWithDic:(NSDictionary *)dic{
    self=[super initWithDic:dic];
    if (self) {
        NSLog(@"%@",dic);
        self.dic=@{KYSCoreTextWidth:dic[KYSCoreTextWidth],
                   KYSCoreTextHeight:dic[KYSCoreTextHeight]};
    }
    return self;
}

static CGFloat widthCallback(void* ref){
    return [[(__bridge NSDictionary*)ref objectForKey:KYSCoreTextWidth] floatValue];
}

static CGFloat ascentCallback(void *ref){
    return [[(__bridge NSDictionary*)ref objectForKey:KYSCoreTextHeight] floatValue];
}

static CGFloat descentCallback(void *ref){
    return 0;
}

//生成占位字符串
- (NSAttributedString *)spaceString{
//    //用局部变量会崩溃，估计是内部不是强引用，这块内存被释放了
//    NSDictionary *dic=@{KYSCoreTextWidth:[[NSNumber alloc] initWithFloat:self.size.width],
//                        KYSCoreTextHeight:[[NSNumber alloc] initWithFloat:self.size.height]};
    
    CTRunDelegateCallbacks callbacks;
    memset(&callbacks, 0, sizeof(CTRunDelegateCallbacks));
    callbacks.version = kCTRunDelegateVersion1;
    callbacks.getAscent = ascentCallback;
    callbacks.getDescent = descentCallback;
    callbacks.getWidth = widthCallback;
    CTRunDelegateRef delegate = CTRunDelegateCreate(&callbacks, (__bridge void *)(self.dic));
    
    //使用0xFFFC作为空白的占位符
    unichar objectReplacementChar = 0xFFFC;
    NSString *content = [NSString stringWithCharacters:&objectReplacementChar length:1];
    NSMutableAttributedString * space = [[NSMutableAttributedString alloc] initWithString:content];
    CFAttributedStringSetAttribute((CFMutableAttributedStringRef)space,
                                   CFRangeMake(0, 1),
                                   kCTRunDelegateAttributeName,
                                   delegate);
    
    CFRelease(delegate);
    return space;
}


@end
