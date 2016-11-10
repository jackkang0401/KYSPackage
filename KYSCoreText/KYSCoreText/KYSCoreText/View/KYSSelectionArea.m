//
//  KYSSelectionArea.m
//  KYSCoreText
//
//  Created by Liu Zhao on 16/6/28.
//  Copyright © 2016年 康永帅. All rights reserved.
//

#import "KYSSelectionArea.h"
#import "KYSCoreTextUtils.h"
#import "UIImage+IndexAnchor.h"
#import "KYSCoreText.h"

@interface KYSSelectionArea()

@property (nonatomic,strong) UIImageView *startAnchor;
@property (nonatomic,strong) UIImageView *endAnchor;

@end

@implementation KYSSelectionArea

- (void)setStartIndex:(NSInteger)startIndex{
    if (_startIndex==startIndex) {
        return;
    }
    _startIndex=startIndex;
    
    if ([_dataSource respondsToSelector:@selector(selectionAreaRelatedCTFrame)]) {
        CTFrameRef textFrame=[_dataSource selectionAreaRelatedCTFrame];
        if (textFrame) {
            CGFloat startHeight=[KYSCoreTextUtils getLineTextHeightWithCTFrame:textFrame atIndex:startIndex];
            [self refreshAnchorWithStartHeight:startHeight];
        }
    }
}

- (void)setEndIndex:(NSInteger)endIndex{
    if (_endIndex==endIndex) {
        return;
    }
    _endIndex=endIndex;
    if ([_dataSource respondsToSelector:@selector(selectionAreaRelatedCTFrame)]) {
        CTFrameRef textFrame=[_dataSource selectionAreaRelatedCTFrame];
        if (textFrame) {
            CGFloat endHeight=[KYSCoreTextUtils getLineTextHeightWithCTFrame:textFrame atIndex:endIndex];
            [self refreshAnchorWithEndHeight:endHeight];
        }
    }
}


- (UIImageView *)startAnchor{
    if (!_startAnchor) {
        _startAnchor = [[UIImageView alloc] init];
        _startAnchor.backgroundColor=[UIColor clearColor];
    }
    return _startAnchor;
}

- (UIImageView *)endAnchor{
    if (!_endAnchor) {
        _endAnchor = [[UIImageView alloc] init];
        _endAnchor.backgroundColor=[UIColor clearColor];
    }
    return _endAnchor;
}

- (void)addAnchorInView:(UIView *)view {
    [view addSubview:self.startAnchor];
    [view addSubview:self.endAnchor];
}

- (void)removeAnchor {
    _startIndex = -1;
    _endIndex = -1;
    //self.coreTextFrame = nil;
    [self.startAnchor removeFromSuperview];
    [self.endAnchor removeFromSuperview];
}

- (void)refreshAnchorWithStartHeight:(CGFloat)startHeight{
    //刷新startAnchor
    CGFloat diameter = startHeight/4;
    diameter=diameter<3?3:diameter;
    UIImage *image=[UIImage imageWithFontHeight:startHeight diameter:diameter color:RGB(28, 107, 222) isTop:YES];
    self.startAnchor.image=image;
    self.startAnchor.frame = CGRectMake(0, 0, diameter, diameter*2+startHeight);
}

- (void)refreshAnchorWithEndHeight:(CGFloat)endHeight{
    //刷新endAnchor
    CGFloat diameter = endHeight/4;
    diameter=diameter<3?3:diameter;
    UIImage *image=[UIImage imageWithFontHeight:endHeight diameter:diameter color:RGB(28, 107, 222) isTop:NO];
    self.endAnchor.image=image;
    self.endAnchor.frame = CGRectMake(0, 0, diameter, diameter*2+endHeight);
}


- (void)refreshAnchorWithStartHeight:(CGFloat)startHeight endHeight:(CGFloat)endHeight{
    NSLog(@"refreshAnchor: %ld, %ld",(long)self.startIndex,(long)self.endIndex);
    [self refreshAnchorWithStartHeight:startHeight];
    [self refreshAnchorWithEndHeight:endHeight];
}

- (NSArray *)selectionLineRects{
    //通过代理取参数
    if (![_dataSource respondsToSelector:@selector(selectionAreaRelatedCTFrame)]
        ||![_dataSource respondsToSelector:@selector(selectionAreaRelatedAttributedString)]) {
        return @[];
    }
    CTFrameRef textFrame=[_dataSource selectionAreaRelatedCTFrame];
    NSAttributedString *text=[_dataSource selectionAreaRelatedAttributedString];
    if (!textFrame || !text.length) {
        return @[];
    }
    
    __block NSMutableArray *mArray=[@[] mutableCopy];
    __weak typeof(self) wSelf=self;
    [KYSCoreTextUtils CTFrame:textFrame enumerateLinesUsingBlock:^(CTLineRef line, CGPoint lineOrigin, CFIndex lineIndex, BOOL *stop) {
        CFRange range = CTLineGetStringRange(line);
        //在同一行
        if ([KYSCoreTextUtils isPosition:wSelf.startIndex inRange:range]
            && [KYSCoreTextUtils isPosition:wSelf.endIndex inRange:range]){
            CGRect areaRect = [KYSCoreTextUtils getRectFromCTLine:line
                                                       lineOrigin:lineOrigin
                                                             text:text
                                                        fromIndex:wSelf.startIndex
                                                          toIndex:wSelf.endIndex
                                                        transform:NULL];
            NSLog(@"drawSelectionArea lineRect：%@",NSStringFromCGRect(areaRect));
            [mArray addObject:[NSValue valueWithCGRect:areaRect]];
            *stop=YES;
            return;
        }
        
        //不在同一行
        if ([KYSCoreTextUtils isPosition:wSelf.startIndex inRange:range]) {
            CGRect lineRect=[KYSCoreTextUtils getRectFromCTLine:line lineOrigin:lineOrigin fromIndex:wSelf.startIndex transform:NULL];
            [mArray addObject:[NSValue valueWithCGRect:lineRect]];
        }else if (wSelf.startIndex<range.location && wSelf.endIndex >= range.location+range.length) {
            CGRect lineRect=[KYSCoreTextUtils getRectFromCTLine:line lineOrigin:lineOrigin transform:NULL];
            [mArray addObject:[NSValue valueWithCGRect:lineRect]];
        }else if (wSelf.startIndex<range.location && [KYSCoreTextUtils isPosition:wSelf.endIndex inRange:range]) {
            CGRect lineRect = [KYSCoreTextUtils getRectFromCTLine:line lineOrigin:lineOrigin text:text toIndex:wSelf.endIndex transform:NULL];
            [mArray addObject:[NSValue valueWithCGRect:lineRect]];
            *stop=YES;
            return;
        }
    }];
    return [mArray copy];
}

- (void)getCenterWithStartBlock:(void(^)(CGPoint startCencer)) startBlock
                       endBlock:(void(^)(CGPoint endCencer)) endBlock
                      transform:(const CGAffineTransform *) transform{
    
    //通过代理取参数
    if (![_dataSource respondsToSelector:@selector(selectionAreaRelatedCTFrame)]
        ||![_dataSource respondsToSelector:@selector(selectionAreaRelatedAttributedString)]) {
        return;
    }
    CTFrameRef textFrame=[_dataSource selectionAreaRelatedCTFrame];
    NSAttributedString *text=[_dataSource selectionAreaRelatedAttributedString];
    if (!textFrame || !text.length) {
        return;
    }
    
    __weak typeof(self) wSelf=self;
    [KYSCoreTextUtils CTFrame:textFrame enumerateLinesUsingBlock:^(CTLineRef line, CGPoint lineOrigin, CFIndex lineIndex, BOOL *stop) {
        CFRange range = CTLineGetStringRange(line);
        if ([KYSCoreTextUtils isPosition:wSelf.startIndex inRange:range]) {
            //当前选中字符左侧
            CGPoint center = [KYSCoreTextUtils getLeftCenterPointFromCTLine:line
                                                                 lineOrigin:lineOrigin
                                                                    atIndex:wSelf.startIndex
                                                                  transform:transform];
            startBlock(center);
            //wSelf.startAnchor.center=center;
        }
        if ([KYSCoreTextUtils isPosition:wSelf.endIndex inRange:range]) {
            //当前选中字符右侧
            CGPoint center = [KYSCoreTextUtils getRightCenterPointFromCTLine:line
                                                                  lineOrigin:lineOrigin
                                                                        text:text
                                                                     atIndex:wSelf.endIndex
                                                                   transform:transform];
            endBlock(center);
            //wSelf.endAnchor.center=center;
            *stop=YES;
        }
    }];
}

@end
