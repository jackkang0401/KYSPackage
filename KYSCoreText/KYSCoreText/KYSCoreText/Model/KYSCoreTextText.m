//
//  KYSCoreTextText.m
//  KYSCoreText
//
//  Created by Liu Zhao on 16/6/20.
//  Copyright © 2016年 康永帅. All rights reserved.
//

#import "KYSCoreTextText.h"
#import "CoreText/CoreText.h"
#import "UIColor+StringToColor.h"

@interface KYSCoreTextText()

@property (nonatomic,copy) NSString *text;
@property (nonatomic,copy) NSString *fontName;
@property (nonatomic,assign) CGFloat fontSize;
@property (nonatomic,strong) UIColor *color;

@end

@implementation KYSCoreTextText

- (instancetype)initWithDic:(NSDictionary *)dic{
    self=[super init];
    if (self) {
        self.text = dic[KYSCoreTextContent];
        self.color = [UIColor colorFromString:dic[KYSCoreTextColor]];
        self.fontName= dic[KYSCoreTextFontName]?:[UIFont systemFontOfSize:12.0].fontName;
        self.fontSize = [dic[KYSCoreTextFontSize] floatValue];
    }
    return self;
}

- (NSDictionary *)attributesWithSharedDic:(NSMutableDictionary *)dic{
    
    if (!dic) {
        dic=[[NSMutableDictionary alloc] init];
    }else if([dic isMemberOfClass:[NSDictionary class]]){
        dic=[dic mutableCopy];
    }
    
    if (self.color) {
        dic[(id)kCTForegroundColorAttributeName] = (id)self.color.CGColor;
    }
    
    if (self.fontSize > 0) {
        CTFontRef fontRef = CTFontCreateWithName((CFStringRef)self.fontName, self.fontSize, NULL);
        dic[(id)kCTFontAttributeName] = (__bridge id)fontRef;
        CFRelease(fontRef);
    }
    return dic;
}

@end
