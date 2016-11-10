//
//  KYSCoreTextUtils.m
//  KYSCoreText
//
//  Created by 康永帅 on 16/6/19.
//  Copyright © 2016年 康永帅. All rights reserved.
//

#import "KYSCoreTextUtils.h"
#import "KYSCoreTextLink.h"
#import "KYSCoreTextStorage.h"

@implementation KYSCoreTextUtils

+ (BOOL)isPosition:(NSInteger)position inRange:(CFRange)range {
    if (position >= range.location && position < range.location + range.length) {
        return YES;
    } else {
        return NO;
    }
}

//获取文本高度
+ (CGFloat)getLineTextHeightWithCTFrame:(CTFrameRef)frame atIndex:(NSInteger)index{
    __block CGFloat height=-1;
    //遍历CTFrame
    __weak typeof(self) wSelf=self;
    [self CTFrame:frame enumerateLinesUsingBlock:^(CTLineRef line, CGPoint lineOrigin, CFIndex lineIndex, BOOL *lineStop) {
        CFRange range = CTLineGetStringRange(line);
        if ([wSelf isPosition:index inRange:range]) {
            CGFloat ascent = 0.0f, descent = 0.0f, leading = 0.0f;
            CTLineGetTypographicBounds(line, &ascent, &descent, &leading);
            height=ascent+descent;
        }
    }];
    return height;
}

//获取行高
+ (CGFloat)getLineHeightWithCTFrame:(CTFrameRef)frame atIndex:(NSInteger)index{
    __block CGFloat height=-1;
    //遍历CTFrame
    __weak typeof(self) wSelf=self;
    [self CTFrame:frame enumerateLinesUsingBlock:^(CTLineRef line, CGPoint lineOrigin, CFIndex lineIndex, BOOL *lineStop) {
        CFRange range = CTLineGetStringRange(line);
        if ([wSelf isPosition:index inRange:range]) {
            CGFloat ascent = 0.0f, descent = 0.0f, leading = 0.0f;
            CTLineGetTypographicBounds(line, &ascent, &descent, &leading);
            height=ascent+descent+leading;
        }
    }];
    return height;
}


//获取指定index的坐标
+ (CGPoint)getOriginPointFromCTLine:(CTLineRef) line
                         lineOrigin:(CGPoint) lineOrigin
                            atIndex:(NSInteger) index
                          transform:(const CGAffineTransform *) transform{
    //NSLog(@"lineOrigin: %@",NSStringFromCGPoint(lineOrigin));
    
    CGFloat ascent, descent, leading, offset;
    offset = CTLineGetOffsetForStringIndex(line, index, NULL);
    CTLineGetTypographicBounds(line, &ascent, &descent, &leading);
    
    //NSLog(@"%f",offset);
    
    //为什么要这样调整坐标？ -5 +11
    CGPoint origin = CGPointMake(lineOrigin.x + offset, lineOrigin.y + ascent);
    //NSLog(@"坐标转换 %@",NSStringFromCGPoint(origin));
    
    //坐标转换
    if(transform){
        //NSLog(@"transform");
        origin = CGPointApplyAffineTransform(origin, *transform);
    }
    return origin;
}

//获取指定index左侧中间位置的坐标
+ (CGPoint)getLeftCenterPointFromCTLine:(CTLineRef) line
                             lineOrigin:(CGPoint) lineOrigin
                                atIndex:(NSInteger) index
                              transform:(const CGAffineTransform *) transform{
    //NSLog(@"lineOrigin: %@",NSStringFromCGPoint(lineOrigin));
    
    CGFloat ascent, descent, leading, offset;
    //如果index超出一行的字符长度则反回最大长度结束位置的偏移量
    offset = CTLineGetOffsetForStringIndex(line, index, NULL);
    CTLineGetTypographicBounds(line, &ascent, &descent, &leading);
    
    //NSLog(@"%f",offset);
    
    //lineOrigin.y-descent + (ascent+descent)/2
    CGPoint center = CGPointMake(lineOrigin.x + offset, lineOrigin.y+ascent/2-descent/2);
    //NSLog(@"坐标转换 %@",NSStringFromCGPoint(center));
    
    //坐标转换
    if(transform){
        //NSLog(@"transform");
        center = CGPointApplyAffineTransform(center, *transform);
    }
    return center;
}

//获取指定index中间位置的坐标
+ (CGPoint)getCenterPointFromCTLine:(CTLineRef) line
                         lineOrigin:(CGPoint) lineOrigin
                               text:(NSAttributedString *)text
                            atIndex:(NSInteger) index
                          transform:(const CGAffineTransform *) transform{
    //NSLog(@"lineOrigin: %@",NSStringFromCGPoint(lineOrigin));
    
    CGFloat ascent, descent, leading, offset;
    //如果index超出一行的字符长度则反回最大长度结束位置的偏移量
    offset = CTLineGetOffsetForStringIndex(line, index, NULL);
    CTLineGetTypographicBounds(line, &ascent, &descent, &leading);
    
//    CGFloat nextAscent, nextDescent, nextLeading, nextOffset;
//    nextOffset = CTLineGetOffsetForStringIndex(line, index+1, NULL);
//    CTLineGetTypographicBounds(line, &nextAscent, &nextDescent, &nextLeading);
    CGFloat width = [self getWidthOfText:text atIndex:index mode:NSLineBreakByWordWrapping];
    
    
    //lineOrigin.y-descent + (ascent+descent)/2
    CGPoint center = CGPointMake(lineOrigin.x+offset+(width)/2,lineOrigin.y+ascent/2-descent/2);
    //NSLog(@"坐标转换 %@",NSStringFromCGPoint(center));
    
    //坐标转换
    if(transform){
        //NSLog(@"transform");
        center = CGPointApplyAffineTransform(center, *transform);
    }
    return center;
}

//获取指定index右侧中间位置的坐标
+ (CGPoint)getRightCenterPointFromCTLine:(CTLineRef) line
                              lineOrigin:(CGPoint) lineOrigin
                                    text:(NSAttributedString *)text
                                 atIndex:(NSInteger) index
                               transform:(const CGAffineTransform *) transform{
    CGFloat ascent, descent, leading, offset;
    //如果index超出一行的字符长度则反回最大长度结束位置的偏移量
    offset = CTLineGetOffsetForStringIndex(line, index, NULL);
    CTLineGetTypographicBounds(line, &ascent, &descent, &leading);
    
    CGFloat width = [self getWidthOfText:text atIndex:index mode:NSLineBreakByWordWrapping];
    
    CGPoint center = CGPointMake(lineOrigin.x+offset+width,lineOrigin.y+ascent/2-descent/2);
    //NSLog(@"坐标转换 %@",NSStringFromCGPoint(center));
    
    //坐标转换
    if(transform){
        //NSLog(@"transform");
        center = CGPointApplyAffineTransform(center, *transform);
    }
    return center;
}

//fromIndex 到 toIndex
+ (CGRect)getRectFromCTLine:(CTLineRef) line
                  lineOrigin:(CGPoint) lineOrigin
                       text:(NSAttributedString *)text
                   fromIndex:(NSInteger) fromIndex
                     toIndex:(NSInteger) toIndex
                   transform:(const CGAffineTransform *) transform{
    //NSLog(@"lineOrigin: %@",NSStringFromCGPoint(lineOrigin));
    
    CGFloat ascent, descent, leading, fromOffset, toOffset;
    
    fromOffset = CTLineGetOffsetForStringIndex(line, fromIndex, NULL);
    
    toOffset = CTLineGetOffsetForStringIndex(line, toIndex, NULL);
    
    CGFloat width = [self getWidthOfText:text atIndex:toIndex mode:NSLineBreakByWordWrapping];
    
    CTLineGetTypographicBounds(line, &ascent, &descent, &leading);
    CGRect areaRect = CGRectMake(lineOrigin.x+fromOffset, lineOrigin.y-descent, toOffset-fromOffset+width, ascent+descent);
    //NSLog(@"frame转换 %@",NSStringFromCGRect(areaRect));
    
    if (transform) {
        //NSLog(@"transform");
        areaRect=CGRectApplyAffineTransform(areaRect, *transform);
    }
    return areaRect;
}

//fromIndex 到 行末
+ (CGRect)getRectFromCTLine:(CTLineRef) line
                  lineOrigin:(CGPoint) lineOrigin
                   fromIndex:(NSInteger) fromIndex
                   transform:(const CGAffineTransform *) transform{
    //NSLog(@"lineOrigin: %@",NSStringFromCGPoint(lineOrigin));
    
    CGFloat ascent, descent, leading, width, offset;
    offset = CTLineGetOffsetForStringIndex(line, fromIndex, NULL);
    
    width = CTLineGetTypographicBounds(line, &ascent, &descent, &leading);
    
    CGRect areaRect = CGRectMake(lineOrigin.x+offset, lineOrigin.y-descent, width-offset, ascent+descent);
    
    if (transform) {
        //NSLog(@"transform");
        areaRect=CGRectApplyAffineTransform(areaRect, *transform);
    }
    return areaRect;
}

//行头 到 toIndex
+ (CGRect)getRectFromCTLine:(CTLineRef) line
                 lineOrigin:(CGPoint) lineOrigin
                       text:(NSAttributedString *)text
                    toIndex:(NSInteger) toIndex
                  transform:(const CGAffineTransform *) transform{
    //NSLog(@"lineOrigin: %@",NSStringFromCGPoint(lineOrigin));
    
    CGFloat ascent, descent, leading, offset;
    
    offset = CTLineGetOffsetForStringIndex(line, toIndex, NULL);
    
    CTLineGetTypographicBounds(line, &ascent, &descent, &leading);
    
    CGFloat width = [self getWidthOfText:text atIndex:toIndex mode:NSLineBreakByWordWrapping];
    
    CGRect areaRect = CGRectMake(lineOrigin.x, lineOrigin.y-descent, offset+width, ascent+descent);
    //NSLog(@"frame转换 %@",NSStringFromCGRect(areaRect));
    
    if (transform) {
        //NSLog(@"transform");
        areaRect=CGRectApplyAffineTransform(areaRect, *transform);
    }
    return areaRect;
}

//获取指定 CTLine 的 Rect
+ (CGRect)getRectFromCTLine:(CTLineRef) line
                 lineOrigin:(CGPoint) lineOrigin
                  transform:(const CGAffineTransform *) transform{
    //NSLog(@"lineOrigin: %@",NSStringFromCGPoint(lineOrigin));
    
    CGFloat ascent, descent, leading, width;
    width = CTLineGetTypographicBounds(line, &ascent, &descent, &leading);
    CGRect areaRect = CGRectMake(lineOrigin.x, lineOrigin.y-descent, width, ascent + descent);
    
    if (transform) {
        //NSLog(@"transform");
        areaRect=CGRectApplyAffineTransform(areaRect, *transform);
    }
    return areaRect;
}


//获取CTFrame中文本的高度
+ (NSInteger)getTextHeightWithCTFrame:(CTFrameRef )textFrame
{
    NSArray *linesArray = (NSArray *) CTFrameGetLines(textFrame);
    if (!linesArray.count) {
        return 0;
    }
    
    CGPoint origins[[linesArray count]];
    CTFrameGetLineOrigins(textFrame, CFRangeMake(0, 0), origins);
    CGFloat line_y = origins[[linesArray count]-1].y;  //最后一行line的原点y坐标
    
    CGFloat ascent,descent,leading;
    CTLineRef line = (__bridge CTLineRef) [linesArray objectAtIndex:[linesArray count]-1];
    
    CTLineGetTypographicBounds(line, &ascent, &descent, &leading);
    
    return ceilf(KYS_CORETEXT_MAX_HEIGHT - line_y + descent);
}

//遍历CTFrame的每一行
+ (void)CTFrame:(CTFrameRef)frame enumerateLinesUsingBlock:(KYSLineCallbcakBlock)block{

    CFArrayRef lines = CTFrameGetLines(frame);
    if (!lines) {
        return ;
    }
    BOOL stop=NO;
    CFIndex count = CFArrayGetCount(lines);
    // 获得每一行的origin坐标
    CGPoint origins[count];
    CTFrameGetLineOrigins(frame, CFRangeMake(0,0), origins);
    //NSLog(@"3333333333         %ld",count);
    for (int i = 0; i < count; i++) {
        CGPoint lineOrigin = origins[i];
        CTLineRef line = CFArrayGetValueAtIndex(lines, i);
        //执行block
        block(line,lineOrigin,i,&stop);
        if (stop) {
            break;
        }
    }
}

//遍历CTLine 及 CTRun
+ (void)CTFrame:(CTFrameRef)frame enumerateLinesBlock:(KYSLineCallbcakBlock)lineBlock runsBlock:(KYSRunCallbcakBlock)runBlock{
    //遍历CTLine
    [self CTFrame:frame enumerateLinesUsingBlock:^(CTLineRef line, CGPoint lineOrigin, CFIndex lineIndex, BOOL *lineStop) {
        //执行 CTLine 回调
        lineBlock(line,lineOrigin,lineIndex,lineStop);
        if (*lineStop) {
            return;
        }
        //遍历 CTRun
        CFArrayRef runs = CTLineGetGlyphRuns(line);
        if (!runs) {
            return;
        }
        BOOL runStop=NO;
        CFIndex runCount = CFArrayGetCount(runs);
        for (int j=0; j<runCount; j++) {
            CTRunRef run = CFArrayGetValueAtIndex(runs, j);
            runBlock(line,lineOrigin,lineIndex,run,j,&runStop);
            if (runStop) {
                break;
            }
        }
    }];
}

+ (CGRect)CTFrame:(CTFrameRef)frame characterIndex:(NSUInteger)index{
    
    if (!frame) {
        return CGRectZero;
    }
    
    __block CGRect characterFrame=CGRectZero;
    __weak typeof(self) wSelf=self;
    [self CTFrame:frame enumerateLinesUsingBlock:^(CTLineRef line, CGPoint lineOrigin, CFIndex lineIndex, BOOL *stop) {
        CFRange range = CTLineGetStringRange(line);
        //NSLog(@"%ld -> %ld",range.location,range.location+range.length);
        // 如果index在line中，则记录当前为起始行
        if ([wSelf isPosition:index inRange:range]) {
            CGFloat ascent, descent, leading, width, offset;
            offset = CTLineGetOffsetForStringIndex(line, index, NULL);
            width = CTLineGetTypographicBounds(line, &ascent, &descent, &leading);
            CGRect lineRect = CGRectMake(lineOrigin.x + offset, lineOrigin.y - descent, width - offset, ascent + descent);
            characterFrame=lineRect;
            
            *stop=YES;
        }
    }];
    return characterFrame;
}

//将点击的位置转换成字符串的偏移量，如果没有找到，则返回-1
+ (CFIndex)getTouchIndexInCTFrame:(CTFrameRef)frame view:(UIView *)view atPoint:(CGPoint)point{
    if (!frame) {
        return -1;
    }
    CTFrameRef textFrame = frame;
    // 翻转坐标系
    CGAffineTransform transform =  CGAffineTransformMakeTranslation(0, view.bounds.size.height);
    transform = CGAffineTransformScale(transform, 1.f, -1.f);
    
    __block CFIndex index=-1;
    //__weak typeof(self) wSelf=self;
    [self CTFrame:textFrame enumerateLinesUsingBlock:^(CTLineRef line, CGPoint lineOrigin, CFIndex lineIndex, BOOL *stop) {
        // 获得每一行的CGRect信息
        CGFloat ascent = 0.0f, descent = 0.0f, leading = 0.0f;
        CGFloat width = (CGFloat)CTLineGetTypographicBounds(line, &ascent, &descent, &leading);
        CGRect flippedRect = CGRectMake(lineOrigin.x, lineOrigin.y-descent, width, ascent+descent);
        //NSLog(@"flippedRect: %@",NSStringFromCGRect(flippedRect));
        CGRect rect = CGRectApplyAffineTransform(flippedRect, transform);
        //NSLog(@"rect: %@",NSStringFromCGRect(rect));
        if (CGRectContainsPoint(rect, point)) {
            //NSLog(@"line: %@",line);
            // 将点击的坐标转换成相对于当前行的坐标
            CGPoint relativePoint = CGPointMake(point.x-CGRectGetMinX(rect),point.y-CGRectGetMinY(rect));
            
            //获得当前点击坐标对应的字符串偏移,这种方式不准 why？
            //index = CTLineGetStringIndexForPosition(line, relativePoint);
            //这个方法算的准
            CFRange range = CTLineGetStringRange(line);
            for(CFIndex i=range.location;i<(range.location+range.length);i++){
                if ((i+1)==(range.location+range.length)) {
                    //最后一个字符
                    CGFloat x=CTLineGetOffsetForStringIndex(line, i, NULL);
                    if(relativePoint.x>x){
                        index=i;
                    }
                }else{
                    //不是最后一个字符
                    CGFloat x0=CTLineGetOffsetForStringIndex(line, i, NULL);
                    CGFloat x1=CTLineGetOffsetForStringIndex(line, i+1, NULL);
                    if(relativePoint.x>=x0 && relativePoint.x<x1){
                        index=i;
                    }
                    
                }
            }
        }
    }];
    return index;
}

//获取指定index字符的宽度
+ (CGFloat)getWidthOfText:(NSAttributedString *)atttibuteStr atIndex:(NSInteger )index mode:(NSLineBreakMode)lineBreakMode{
    if (!atttibuteStr.length || index>=atttibuteStr.length) {
        return 0;
    }
    NSDictionary *attDic = [atttibuteStr attributesAtIndex:index effectiveRange:NULL];
    NSLog(@"%@: %@",NSFontAttributeName,attDic[NSFontAttributeName]);
    UIFont *font = attDic[NSFontAttributeName];
    
    if (!font){
        font = [UIFont systemFontOfSize:15.0];
    }
    
    //NSLineBreakMode lineBreakMode = NSLineBreakByWordWrapping
    NSString *indexStr=[atttibuteStr attributedSubstringFromRange:NSMakeRange(index, 1)].string;
    
    if ([self respondsToSelector:@selector(boundingRectWithSize:options:attributes:context:)]) {
        NSMutableDictionary *attr = [NSMutableDictionary new];
        attr[NSFontAttributeName] = font;
        if (lineBreakMode != NSLineBreakByWordWrapping) {
            NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle new];
            paragraphStyle.lineBreakMode = lineBreakMode;
            attr[NSParagraphStyleAttributeName] = paragraphStyle;
        }
        CGRect rect = [indexStr boundingRectWithSize:CGSizeMake(HUGE, HUGE)
                                             options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                          attributes:attr
                                             context:nil];
        return rect.size.width;
    } else {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        return [indexStr sizeWithFont:font constrainedToSize:CGSizeMake(HUGE, HUGE) lineBreakMode:lineBreakMode].width;
#pragma clang diagnostic pop
    }
    
    return 0;
}



@end
