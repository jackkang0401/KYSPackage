//
//  KYSCoreTextStorage.h
//  KYSCoreText
//
//  Created by 康永帅 on 16/6/19.
//  Copyright © 2016年 康永帅. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CoreText/CoreText.h"
#import "KYSCoreText.h"


@class KYSCoreTextStorage;
@class KYSCoreTextImage;

@interface KYSCoreTextStorage : NSObject

@property (nonatomic,assign) CGFloat width;
@property (nonatomic,assign,readonly) CGFloat height;
@property (nonatomic,assign) CGFloat fontSize;
@property (nonatomic,assign) CGFloat lineSpace;
@property (nonatomic,strong) UIColor *textColor;


@property (nonatomic,strong,readonly) NSAttributedString *attributedString;
@property (nonatomic,assign,readonly) CTFrameRef coreTextFrame;
@property (nonatomic,assign,readonly) KYSCoreTextImageLayoutType imageLayoutType;
@property (nonatomic,strong,readonly) NSArray *imageArray;
@property (nonatomic,strong,readonly) NSArray *linkArray;
@property (nonatomic,strong,readonly) NSArray *telephoneArray;

- (instancetype)initWithImageLayoutType:(KYSCoreTextImageLayoutType)imageLayoutType;

- (void)parseTemplateWithFilePath:(NSString *)filePath width:(CGFloat)width;

- (NSMutableDictionary *)sharedAttributes;

- (void)getTouchObjectInView:(UIView *) view atPoint:(CGPoint) point block:(void(^)(id object))block;

@end
