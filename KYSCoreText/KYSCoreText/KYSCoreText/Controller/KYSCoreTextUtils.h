//
//  KYSCoreTextUtils.h
//  KYSCoreText
//
//  Created by 康永帅 on 16/6/19.
//  Copyright © 2016年 康永帅. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CoreText/CoreText.h"

@class KYSCoreTextStorage;
@class KYSCoreTextLink;

typedef void (^KYSLineCallbcakBlock)(CTLineRef line, CGPoint lineOrigin, CFIndex lineIndex, BOOL *lineStop);
typedef void (^KYSRunCallbcakBlock)(CTLineRef line, CGPoint lineOrigin, CFIndex lineIndex, CTRunRef run, CFIndex runIndex, BOOL *runStop);

@interface KYSCoreTextUtils : NSObject

+ (BOOL)isPosition:(NSInteger)position inRange:(CFRange)range;

//获取文本高度
+ (CGFloat)getLineTextHeightWithCTFrame:(CTFrameRef)frame atIndex:(NSInteger)index;

//获取行高
+ (CGFloat)getLineHeightWithCTFrame:(CTFrameRef)frame atIndex:(NSInteger)index;

//获取指定index的坐标
+ (CGPoint)getOriginPointFromCTLine:(CTLineRef) line
                         lineOrigin:(CGPoint) lineOrigin
                            atIndex:(NSInteger) index
                          transform:(const CGAffineTransform *) transform;

//获取指定index左侧中间位置的坐标
+ (CGPoint)getLeftCenterPointFromCTLine:(CTLineRef) line
                             lineOrigin:(CGPoint) lineOrigin
                                atIndex:(NSInteger) index
                              transform:(const CGAffineTransform *) transform;

//获取指定index中间位置的坐标
+ (CGPoint)getCenterPointFromCTLine:(CTLineRef) line
                         lineOrigin:(CGPoint) lineOrigin
                               text:(NSAttributedString *)text
                            atIndex:(NSInteger) index
                          transform:(const CGAffineTransform *) transform;

//获取指定index右侧中间位置的坐标
+ (CGPoint)getRightCenterPointFromCTLine:(CTLineRef) line
                              lineOrigin:(CGPoint) lineOrigin
                                    text:(NSAttributedString *)text
                                 atIndex:(NSInteger) index
                               transform:(const CGAffineTransform *) transform;

//fromIndex 到 toIndex
+ (CGRect)getRectFromCTLine:(CTLineRef) line
                 lineOrigin:(CGPoint) lineOrigin
                       text:(NSAttributedString *)text
                  fromIndex:(NSInteger) fromIndex
                    toIndex:(NSInteger) toIndex
                  transform:(const CGAffineTransform *) transform;

//fromIndex 到 行末
+ (CGRect)getRectFromCTLine:(CTLineRef) line
                  lineOrigin:(CGPoint) lineOrigin
                   fromIndex:(NSInteger) fromIndex
                   transform:(const CGAffineTransform *) transform;

//行头 到 toIndex
+ (CGRect)getRectFromCTLine:(CTLineRef) line
                 lineOrigin:(CGPoint) lineOrigin
                       text:(NSAttributedString *)text
                    toIndex:(NSInteger) toIndex
                  transform:(const CGAffineTransform *) transform;

//CTLine 的 Rect
+ (CGRect)getRectFromCTLine:(CTLineRef) line
                 lineOrigin:(CGPoint) lineOrigin
                  transform:(const CGAffineTransform *) transform;

//获取CTFrame中文本的高度
+ (NSInteger)getTextHeightWithCTFrame:(CTFrameRef )textFrame;

+ (void)CTFrame:(CTFrameRef)frame enumerateLinesUsingBlock:(KYSLineCallbcakBlock)block;

+ (void)CTFrame:(CTFrameRef)frame enumerateLinesBlock:(KYSLineCallbcakBlock)lineBlock runsBlock:(KYSRunCallbcakBlock)runBlock;

//获取对应index字符的frame
+ (CGRect)CTFrame:(CTFrameRef)frame characterIndex:(NSUInteger)index;

//将点击的位置转换成字符串的偏移量，如果没有找到，则返回-1
+ (CFIndex)getTouchIndexInCTFrame:(CTFrameRef)frame
                             view:(UIView *)view
                          atPoint:(CGPoint)point;

//获取指定index字符的宽度
+ (CGFloat)getWidthOfText:(NSAttributedString *)atttibuteStr atIndex:(NSInteger )index mode:(NSLineBreakMode)lineBreakMode;

@end
