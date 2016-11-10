//
//  KYSCoreTextView.m
//  KYSCoreText
//
//  Created by 康永帅 on 16/6/19.
//  Copyright © 2016年 康永帅. All rights reserved.
//

#import "KYSCoreTextView.h"
#import "KYSCoreText.h"
#import "KYSCoreTextStorage.h"
#import "KYSMagnifiterView.h"
#import "KYSCoreTextUtils.h"
#import "UIImage+IndexAnchor.h"
#import "UIView+KYSCategory.h"
#import "KYSCoreTextImage.h"
#import "KYSCoreTextLink.h"
#import "KYSCoreTextTelephone.h"
#import "KYSSelectionArea.h"
#import "KYSGlintAnchor.h"

typedef enum KYSCoreTextState : NSInteger {
    KYSCoreTextStateNormal,
    KYSCoreTextStateMagnifying,
    KYSCoreTextStateSelected
}KYSCoreTextState;

@interface KYSCoreTextView()<UIGestureRecognizerDelegate,KYSGlintAnchorDataSource,KYSSelectionAreaDataSource>

@property (nonatomic,strong) KYSSelectionArea *selectionArea;
@property (nonatomic,assign) KYSCoreTextState state;
@property (nonatomic,strong) KYSGlintAnchor *glintAnchor;
@property (nonatomic,strong) KYSMagnifiterView *magnifierView;

@end

@implementation KYSCoreTextView

- (id)init {
    return [self initWithFrame:CGRectZero];
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self p_addGestureRecognizer];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self p_addGestureRecognizer];
    }
    return self;
}

- (void)drawRect:(CGRect)rect{
    [super drawRect:rect];
    
    if (self.coreTextData == nil) {
        return;
    }
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetTextMatrix(context, CGAffineTransformIdentity);
    CGContextTranslateCTM(context, 0, self.bounds.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    
    if (self.state == KYSCoreTextStateMagnifying || self.state == KYSCoreTextStateSelected) {
        [self p_drawSelectedAreaAndRefreshAnchor];
    }
    
    CTFrameDraw(self.coreTextData.coreTextFrame, context);
    
    CGAffineTransform transform = CGAffineTransformIdentity;
    transform = CGAffineTransformScale(transform, 1, -1);
    transform = CGAffineTransformTranslate(transform, 0, -self.height);
    
    for (KYSCoreTextImage * imageData in self.coreTextData.imageArray) {
        UIImage *image = [UIImage imageNamed:imageData.name];
        if (image) {
            CGRect rect = CGRectApplyAffineTransform(imageData.frame, transform);
            CGContextDrawImage(context, rect, image.CGImage);
        }
    }
}


#pragma mark - Get Set
- (void)setCoreTextData:(KYSCoreTextStorage *)coreTextData {
    _coreTextData = coreTextData;
    self.state = KYSCoreTextStateNormal;
}

- (void)setState:(KYSCoreTextState)state {
    if (_state == state) {
        return;
    }
    _state = state;
    if(_state == KYSCoreTextStateNormal){
        [self.selectionArea removeAnchor];
        [self p_removeGlintAnchor];
        [self p_removeMaginfierView];
        [self p_hideMenuController];
    }else if (_state == KYSCoreTextStateMagnifying){
        [self.selectionArea removeAnchor];
        [self p_hideMenuController];
    }else if (_state == KYSCoreTextStateSelected){
        [self p_removeGlintAnchor];
        [self.selectionArea addAnchorInView:self];
        if (!self.selectionArea.isTouchStartAnchor && !self.selectionArea.isTouchEndAnchor){
            [self p_removeMaginfierView];
            [self p_hideMenuController];
        }
    }
    [self setNeedsDisplay];
}

- (CGFloat)coreTextHeight{
    return self.coreTextData.height;
}

#pragma mark - UIGestureRecognizer
//添加手势
- (void)p_addGestureRecognizer{
    //添加单击手势
    UIGestureRecognizer *tap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
    [self addGestureRecognizer:tap];
    
    //添加双击手势
    UITapGestureRecognizer *doubleTap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTap:)];
    doubleTap.numberOfTapsRequired=2;
    [self addGestureRecognizer:doubleTap];
    
    //添加长按手势
    UIGestureRecognizer *longPress=[[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
    [self addGestureRecognizer:longPress];
    //添加拖动手势
    UIGestureRecognizer *pan=[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
    [self addGestureRecognizer:pan];
}

- (void)tap:(UIGestureRecognizer *)recognizer{
    CGPoint point = [recognizer locationInView:self];
    NSLog(@"tap point:%@",NSStringFromCGPoint(point));
    if (_state == KYSCoreTextStateNormal) {
        [self.coreTextData getTouchObjectInView:self atPoint:point block:^(id object) {
            NSLog(@"tap object: %@",object);
        }];
    } else {
        self.state = KYSCoreTextStateNormal;
    }
}

- (void)doubleTap:(UIGestureRecognizer *)recognizer{
    CGPoint point = [recognizer locationInView:self];
    CFIndex index = [KYSCoreTextUtils getTouchIndexInCTFrame:self.coreTextData.coreTextFrame view:self atPoint:point];
    if (index != -1 && index < self.coreTextData.attributedString.length) {
        NSLog(@"index: %ld",index);
        self.selectionArea.startIndex = index;
        self.selectionArea.endIndex = index + 1;
        //进入编辑状态
        self.state = KYSCoreTextStateSelected;
        [self p_showMenuController];
    }
}

- (void)longPress:(UILongPressGestureRecognizer *)recognizer {
    CGPoint point = [recognizer locationInView:self];
    NSLog(@" ");
    NSLog(@"state = %ld longPress point = %@", (long)recognizer.state,NSStringFromCGPoint(point));
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        NSLog(@"进入放大镜状态");
        //进入放大镜状态
        self.state = KYSCoreTextStateMagnifying;
        self.magnifierView.touchPoint = point;
        CFIndex index = [KYSCoreTextUtils getTouchIndexInCTFrame:self.coreTextData.coreTextFrame view:self atPoint:point];
        if (-1==index) {
            return;
        }
        CGPoint indexPoint=[self p_getGlintViewPointWithPoint:point index:index];
        if (-1.0==indexPoint.x||-1.0==indexPoint.y) {
            return;
        }
        self.glintAnchor.index=index;
        self.glintAnchor.center=indexPoint;
    }else if(recognizer.state == UIGestureRecognizerStateChanged){
        self.magnifierView.touchPoint = point;
        CFIndex index = [KYSCoreTextUtils getTouchIndexInCTFrame:self.coreTextData.coreTextFrame view:self atPoint:point];
        if (-1==index) {
            return;
        }
        CGPoint indexPoint=[self p_getGlintViewPointWithPoint:point index:index];
        if (-1.0==indexPoint.x||-1.0==indexPoint.y) {
            return;
        }
        self.glintAnchor.index=index;
        self.glintAnchor.center=indexPoint;
    }else {
        //self.state = KYSCoreTextStateNormal;
        [self p_removeMaginfierView];
    }
}

- (void)pan:(UIGestureRecognizer *)recognizer {
    if (self.state != KYSCoreTextStateSelected) {
        return;
    }
    CGPoint point = [recognizer locationInView:self];
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        //判断点击了是startAnchor还是endAnchor,并使其进入可移动状态
        NSLog(@"%@",self.selectionArea.endAnchor);
        //扩大点击范围
        if (CGRectContainsPoint(CGRectInset(self.selectionArea.startAnchor.frame, -20, 0), point)) {
            self.selectionArea.isTouchStartAnchor=YES;
            [self p_hideMenuController];
        } else if (CGRectContainsPoint(CGRectInset(self.selectionArea.endAnchor.frame, -20, 0), point)) {
            self.selectionArea.isTouchEndAnchor=YES;
            [self p_hideMenuController];
        }
    }else if(recognizer.state == UIGestureRecognizerStateChanged) {
        CFIndex index = [KYSCoreTextUtils getTouchIndexInCTFrame:self.coreTextData.coreTextFrame view:self atPoint:point];
        if (-1==index) {
            return;
        }
        if(self.selectionArea.isTouchStartAnchor && index<=self.selectionArea.endIndex){
            NSLog(@"change start position to %ld", index);
            CGPoint indexCenter = [self p_getAnchorViewCenterPointWithIndex:index];
            //小于一半才选中
            if (point.x<indexCenter.x) {
                self.selectionArea.startIndex = index;
                self.magnifierView.touchPoint = point;
                [self p_hideMenuController];
            }
        }else if(self.selectionArea.isTouchEndAnchor && index>=self.selectionArea.startIndex) {
            NSLog(@"change end position to %ld", index);
            CGPoint indexCenter = [self p_getAnchorViewCenterPointWithIndex:index];
            //超过一半才选中
            if (point.x>indexCenter.x) {
                self.selectionArea.endIndex = index;
                self.magnifierView.touchPoint = point;
                [self p_hideMenuController];
            }
        }
    }else{
        self.selectionArea.isTouchStartAnchor=NO;
        self.selectionArea.isTouchEndAnchor=NO;
        [self p_removeMaginfierView];
        [self p_showMenuController];
    }
    [self setNeedsDisplay];
}

#pragma mark - GlintAnchor
- (void)p_removeGlintAnchor{
    if (_glintAnchor) {
        [_glintAnchor endGlint];
        [_glintAnchor removeFromSuperview];
        _glintAnchor=nil;
    }
}

#pragma mark - KYSGlintAnchorDataSource
- (CTFrameRef)glintAnchorRelatedCTFrame{
    return self.coreTextData.coreTextFrame;
}

#pragma mark - KYSSelectionAreaDataSource
- (CTFrameRef)selectionAreaRelatedCTFrame{
    return self.coreTextData.coreTextFrame;
}

- (NSAttributedString *)selectionAreaRelatedAttributedString{
    return self.coreTextData.attributedString;
}

#pragma mark - MagnifiterView
- (void)p_removeMaginfierView {
    if (_magnifierView) {
        [_magnifierView removeFromSuperview];
        _magnifierView = nil;
    }
}

#pragma mark - MenuController
- (void)p_showMenuController {
    if ([self becomeFirstResponder]) {
        CGRect selectionRect = [self p_getRectForMenuController];
        UIMenuController *menuController = [UIMenuController sharedMenuController];
        [menuController setTargetRect:selectionRect inView:self];
        [menuController setMenuVisible:YES animated:YES];
    }
}

- (void)p_hideMenuController {
    if ([self resignFirstResponder]) {
        UIMenuController *menuController = [UIMenuController sharedMenuController];
        [menuController setMenuVisible:NO animated:YES];
    }
}

//不返回YES,MenuController不显示
- (BOOL)canBecomeFirstResponder {
    return YES;
}

//控制哪些命令显示在快捷菜单中
- (BOOL)canPerformAction:(SEL)action withSender:(id)sender {
    if ( action == @selector(copy:)||action == @selector(selectAll:)) {
        return YES;
    }else if(action == @selector(cut:)||action==@selector(select:)||action == @selector(paste:)){
        return NO;
    }
    return NO;
}

- (void)copy:(id)sender{
    NSLog(@"%@",sender);
    NSRange range=NSMakeRange(self.selectionArea.startIndex, self.selectionArea.endIndex-self.selectionArea.startIndex+1);
    NSString *selectedStr=[self.coreTextData.attributedString.string substringWithRange:range];
    NSLog(@"copy: %@",selectedStr);
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    [pasteboard setString:selectedStr];
    NSLog(@"pasteboard: %@",pasteboard.string);
}

- (void)selectAll:(id)sender{
    NSLog(@"%@",sender);
    
    self.selectionArea.startIndex=0;
    self.selectionArea.endIndex=self.coreTextData.attributedString.length-1;
    [self setNeedsDisplay];
    [self p_showMenuController];
}

#pragma mark - private
- (CGPoint)p_getGlintViewPointWithPoint:(CGPoint )point index:(NSInteger)index{
    //翻转坐标系
    CGAffineTransform transform =  CGAffineTransformMakeTranslation(0, self.bounds.size.height);
    transform = CGAffineTransformScale(transform, 1.f, -1.f);
    
    CTFrameRef textFrame = self.coreTextData.coreTextFrame;
    __block CGPoint indexCenter = CGPointMake(-1.0, -1.0);
    __weak typeof(self) wSelf=self;
    [KYSCoreTextUtils CTFrame:textFrame enumerateLinesUsingBlock:^(CTLineRef line, CGPoint lineOrigin, CFIndex lineIndex, BOOL *stop) {
        CFRange range = CTLineGetStringRange(line);
        if ([KYSCoreTextUtils isPosition:index inRange:range]) {
            
            CGPoint leftCenter=[KYSCoreTextUtils getLeftCenterPointFromCTLine:line
                                                                   lineOrigin:lineOrigin
                                                                      atIndex:index
                                                                    transform:&transform];
            
            //当前选中字符中间位置
            CGPoint center=[KYSCoreTextUtils getCenterPointFromCTLine:line
                                                           lineOrigin:lineOrigin
                                                                 text:wSelf.coreTextData.attributedString
                                                              atIndex:index
                                                            transform:&transform];
            
            CGPoint rightCenter = [KYSCoreTextUtils getRightCenterPointFromCTLine:line
                                                                       lineOrigin:lineOrigin
                                                                             text:wSelf.coreTextData.attributedString
                                                                          atIndex:index
                                                                        transform:&transform];
            
            indexCenter=point.x<center.x?leftCenter:rightCenter;
            *stop=YES;
        }
    }];
    return indexCenter;
}

- (CGPoint)p_getAnchorViewCenterPointWithIndex:(NSInteger )index{
    //翻转坐标系
    CGAffineTransform transform =  CGAffineTransformMakeTranslation(0, self.bounds.size.height);
    transform = CGAffineTransformScale(transform, 1.f, -1.f);
    CTFrameRef textFrame = self.coreTextData.coreTextFrame;
    __block CGPoint indexCenter = CGPointMake(-1, -1);
    __weak typeof(self) wSelf=self;
    [KYSCoreTextUtils CTFrame:textFrame enumerateLinesUsingBlock:^(CTLineRef line, CGPoint lineOrigin, CFIndex lineIndex, BOOL *stop) {
        CFRange range = CTLineGetStringRange(line);
        if ([KYSCoreTextUtils isPosition:index inRange:range]){
            //当前选中字符中间位置
            CGPoint center = [KYSCoreTextUtils getCenterPointFromCTLine:line
                                                             lineOrigin:lineOrigin
                                                                   text:wSelf.coreTextData.attributedString
                                                                atIndex:index
                                                              transform:&transform];
            indexCenter=center;
            *stop=YES;
        }
    }];
    return indexCenter;
}

- (CGRect)p_getRectForMenuController {
    if (self.selectionArea.startIndex < 0 || self.selectionArea.endIndex > self.coreTextData.attributedString.length) {
        return CGRectZero;
    }
    //翻转坐标系
    CGAffineTransform transform =  CGAffineTransformMakeTranslation(0, self.bounds.size.height);
    transform = CGAffineTransformScale(transform, 1.f, -1.f);
    
    CTFrameRef textFrame = self.coreTextData.coreTextFrame;
    __block CGRect resultRect = CGRectZero;
    __weak typeof(self) wSelf=self;
    [KYSCoreTextUtils CTFrame:textFrame enumerateLinesUsingBlock:^(CTLineRef line, CGPoint lineOrigin, CFIndex lineIndex, BOOL *stop) {
        CFRange range = CTLineGetStringRange(line);
        //start和end在一个line,则直接弄完break
        if ([KYSCoreTextUtils isPosition:self.selectionArea.startIndex inRange:range]
            && [KYSCoreTextUtils isPosition:wSelf.selectionArea.endIndex inRange:range]) {
            resultRect = [KYSCoreTextUtils getRectFromCTLine:line
                                                       lineOrigin:lineOrigin
                                                             text:wSelf.coreTextData.attributedString
                                                        fromIndex:wSelf.selectionArea.startIndex
                                                          toIndex:wSelf.selectionArea.endIndex
                                                        transform:&transform];
            NSLog(@"rectForMenuController lineRect：%@",NSStringFromCGRect(resultRect));
            *stop=YES;
            return;
        }
        // start和end不在一个line
        if ([KYSCoreTextUtils isPosition:wSelf.selectionArea.startIndex inRange:range]){
            resultRect=[KYSCoreTextUtils getRectFromCTLine:line
                                                lineOrigin:lineOrigin
                                                 fromIndex:wSelf.selectionArea.startIndex
                                                 transform:&transform];
        }
    }];
    return resultRect;
}

- (void)p_drawSelectedAreaAndRefreshAnchor{
    if (self.selectionArea.startIndex < 0
        ||self.selectionArea.endIndex>self.coreTextData.attributedString.length) {
        return;
    }
    
    //self.selectionArea.coreTextFrame=self.coreTextData.coreTextFrame;
    
    //绘制选中区域
    NSArray *areaRectArray=[self.selectionArea selectionLineRects];
    for (NSValue *value in areaRectArray) {
        //NSLog(@"11111:    %@",value);
        CGRect frame=[value CGRectValue];
        [self p_fillSelectionAreaWithFrame:frame];
    }
    
    //刷新Anchor位置
    //翻转坐标系,以点(0, self.bounds.size.height)为起始参照
    CGAffineTransform transform =  CGAffineTransformMakeTranslation(0, self.height);
    transform = CGAffineTransformScale(transform, 1.f, -1.f);
    //刷新center位置
    __weak typeof(self) wSelf=self;
    [self.selectionArea getCenterWithStartBlock:^(CGPoint startCencer) {
                                      wSelf.selectionArea.startAnchor.center=startCencer;
                                  } endBlock:^(CGPoint endCencer) {
                                      wSelf.selectionArea.endAnchor.center=endCencer;
                                  } transform:&transform];
}

//填充某一区域
- (void)p_fillSelectionAreaWithFrame:(CGRect)frame {
    UIColor *bgColor = RGB(204, 221, 236);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, bgColor.CGColor);
    CGContextFillRect(context, frame);
}

#pragma mark - lazy load
- (KYSSelectionArea *)selectionArea{
    if (!_selectionArea) {
        _selectionArea=[[KYSSelectionArea alloc] init];
        _selectionArea.dataSource=self;
    }
    return _selectionArea;
}

- (KYSGlintAnchor *)glintAnchor{
    if (!_glintAnchor) {
        _glintAnchor=[[KYSGlintAnchor alloc] init];
        _glintAnchor.dataSource=self;
        [_glintAnchor startGlint];
        [self addSubview:_glintAnchor];
    }
    return _glintAnchor;
}

- (KYSMagnifiterView *)magnifierView {
    if (!_magnifierView) {
        _magnifierView = [[KYSMagnifiterView alloc] init];
        _magnifierView.viewToMagnify = self;
        [self addSubview:_magnifierView];
    }
    return _magnifierView;
}

@end
