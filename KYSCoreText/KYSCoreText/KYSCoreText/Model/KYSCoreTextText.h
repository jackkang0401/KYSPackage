//
//  KYSCoreTextText.h
//  KYSCoreText
//
//  Created by Liu Zhao on 16/6/20.
//  Copyright © 2016年 康永帅. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KYSCoreTextText : NSObject

@property (nonatomic,copy,readonly) NSString *text;
@property (nonatomic,copy,readonly) NSString *fontName;
@property (nonatomic,assign,readonly) CGFloat fontSize;
@property (nonatomic,strong,readonly) UIColor *color;

- (instancetype)initWithDic:(NSDictionary *)dic;

- (NSDictionary *)attributesWithSharedDic:(NSMutableDictionary *)dic;

@end
