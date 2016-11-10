//
//  KYSCoreTextStorage.m
//  KYSCoreText
//
//  Created by 康永帅 on 16/6/19.
//  Copyright © 2016年 康永帅. All rights reserved.
//

#import "KYSCoreTextStorage.h"
#import "KYSCoreTextLink.h"
#import "KYSCoreTextImage.h"
#import "KYSCoreTextLineImage.h"
#import "KYSCoreTextUtils.h"
#import "KYSCoreTextTelephone.h"

#import "KYSCoreTextParse.h"

@interface KYSCoreTextStorage()

@property (nonatomic,strong) NSAttributedString *attributedString;
@property (nonatomic,assign) CTFrameRef coreTextFrame;
@property (nonatomic,assign) CGFloat height;
@property (nonatomic,assign) KYSCoreTextImageLayoutType imageLayoutType;
@property (nonatomic,strong) NSArray *imageArray;
@property (nonatomic,strong) NSArray *linkArray;
@property (nonatomic,strong) NSArray *telephoneArray;
@property (nonatomic,strong) KYSCoreTextParse *coreTextParse;

@end

@implementation KYSCoreTextStorage



- (instancetype)init {
    return [self initWithImageLayoutType:KYSCoreTextImageLayoutTypeAuto];
}

- (instancetype)initWithImageLayoutType:(KYSCoreTextImageLayoutType)imageLayoutType {
    self = [super init];
    if (self) {
        self.width = 0.0f;
        self.fontSize = 16.0f;
        self.lineSpace = 0.0f;
        self.textColor = [UIColor darkGrayColor];
        self.imageLayoutType = imageLayoutType;
    }
    return self;
}

- (void)setCoreTextFrame:(CTFrameRef)coreTextFrame {
    if (_coreTextFrame != coreTextFrame) {
        if (_coreTextFrame != nil) {
            CFRelease(_coreTextFrame);
        }
        CFRetain(coreTextFrame);
        _coreTextFrame = coreTextFrame;
    }
}

- (void)dealloc {
    if (_coreTextFrame != nil) {
        CFRelease(_coreTextFrame);
        _coreTextFrame = nil;
    }
}

- (void)parseTemplateWithFilePath:(NSString *)filePath width:(CGFloat)width{
    
    KYSCoreTextParse *parseData=[[KYSCoreTextParse alloc] initWithTemplateFile:filePath
                                                                  attributeDic:[self sharedAttributes]
                                                               imageLayoutType:self.imageLayoutType];
    
    self.width=width;
    self.coreTextParse=parseData;
    
    NSLog(@"imageArray: %@",parseData.imageArray);
    
    NSInteger height=0;
    NSMutableArray *pathsArray = [[NSMutableArray alloc] init];
    
    if (KYSCoreTextImageLayoutTypeLine==self.imageLayoutType) {
        //计算图片位置
        height = [self p_getCTFrameHeightAndCalculateLineImageFrame];
    }else{
        //计算图片位置并返回加入图片后的文本高度
        height=[self p_getCTFrameHeightAndCalculateImageFrame];
        NSLog(@"height: %ld",(long)height);
        //生成新的pathsArray
        for (KYSCoreTextImage *coreTextImage in parseData.imageArray) {
            CGAffineTransform transform = CGAffineTransformIdentity;
            transform = CGAffineTransformScale(transform, 1, -1);
            transform = CGAffineTransformTranslate(transform, 0, -height);
            
            NSLog(@"image point: %@",NSStringFromCGRect(coreTextImage.frame));
            CGPathRef clipPath = CGPathCreateWithRect(coreTextImage.frame, &transform);
            //        NSDictionary *clippingPathDictionary = @{(__bridge NSString *)kCTFramePathClippingPathAttributeName:(__bridge id)(clipPath)};
            //        [pathsArray addObject:clippingPathDictionary];
            [pathsArray addObject:(__bridge id)(clipPath)];
            CFRelease(clipPath);
        }
    }
    
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)parseData.text);
    CTFrameRef frame=[self p_createFrameWithFramesetter:framesetter height:height clippingPathArray:pathsArray];
    
    // 保存CTFrameRef实例与计算好的缓制高度
    self.coreTextFrame = frame;
    self.height = height;
    self.attributedString = parseData.text;
    self.imageArray=[parseData.imageArray copy];//转化成不可变数组
    self.linkArray=[parseData.linkArray copy];
    self.telephoneArray=[parseData.telephoneArray copy];
    
    // 释放内存
    CFRelease(frame);
    CFRelease(framesetter);
}


- (NSMutableDictionary *)sharedAttributes{
    CTFontRef fontRef = CTFontCreateWithName((CFStringRef)@"ArialMT", self.fontSize, NULL);
    CGFloat lineSpacing = self.lineSpace;
    const CFIndex kNumberOfSettings = 3;
    CTParagraphStyleSetting theSettings[kNumberOfSettings] = {
        { kCTParagraphStyleSpecifierLineSpacingAdjustment, sizeof(CGFloat), &lineSpacing },
        { kCTParagraphStyleSpecifierMaximumLineSpacing, sizeof(CGFloat), &lineSpacing },
        { kCTParagraphStyleSpecifierMinimumLineSpacing, sizeof(CGFloat), &lineSpacing }
    };
    
    CTParagraphStyleRef theParagraphRef = CTParagraphStyleCreate(theSettings, kNumberOfSettings);
    NSMutableDictionary * dict = [NSMutableDictionary dictionary];
    dict[(id)kCTForegroundColorAttributeName] = (id)self.textColor.CGColor;
    dict[(id)kCTFontAttributeName] = (__bridge id)fontRef;
    dict[(id)kCTParagraphStyleAttributeName] = (__bridge id)theParagraphRef;
    
    CFRelease(theParagraphRef);
    CFRelease(fontRef);
    return dict;
}

- (void)getTouchObjectInView:(UIView *) view atPoint:(CGPoint) point block:(void(^)(id object))block{
    //检索图片
    KYSCoreTextImage *image=[KYSCoreTextImage getTouchImageInCTFrame:self.coreTextFrame
                                                          imageArray:self.imageArray
                                                                view:view
                                                             atPoint:point];
    if (image) {
        block(image);
        return;
    }
    //检索链接
    KYSCoreTextLink *link = [KYSCoreTextLink getTouchLinkInCTFrame:self.coreTextFrame
                                                         linkArray:self.linkArray
                                                              view:view
                                                           atPoint:point];
    if (link) {
        block(link);
        return;
    }
    //检索电话
    KYSCoreTextTelephone *telephpne=[KYSCoreTextTelephone getTouchTelephoneInCTFrame:self.coreTextFrame
                                                                      telephoneArray:self.telephoneArray
                                                                                view:view
                                                                             atPoint:point];
    if (telephpne) {
        block(telephpne);
        return;
    }
    block(nil);
}

#pragma mark - private

- (CFDictionaryRef )p_getClippingPathsDictionaryWithPathArray:(NSArray *)pathsArray{
    
    if (!pathsArray) {
        NSLog(@"pathsArray is nil");
        pathsArray=@[];
    }
    
    int eFillRule = kCTFramePathFillEvenOdd;
    CFNumberRef fillRule = CFNumberCreate(NULL, kCFNumberNSIntegerType, &eFillRule);
    int eProgression = kCTFrameProgressionTopToBottom;
    CFNumberRef progression = CFNumberCreate(NULL, kCFNumberNSIntegerType, &eProgression);
    
    CFStringRef keys[]={kCTFrameClippingPathsAttributeName,
                        kCTFramePathFillRuleAttributeName,
                        kCTFrameProgressionAttributeName,
                        //kCTFramePathWidthAttributeName//有它算不出高度了
    };
    
    CFTypeRef values[]={(__bridge CFTypeRef)(pathsArray),
                        fillRule,
                        progression,
                        //frameWidth
    };
    
    CFDictionaryRef clippingPathsDictionary = CFDictionaryCreate(NULL,
                                                                 (const void **)&keys,
                                                                 (const void **)&values,
                                                                 sizeof(keys)/sizeof(keys[0]),
                                                                 &kCFTypeDictionaryKeyCallBacks,
                                                                 &kCFTypeDictionaryValueCallBacks);
    
    return clippingPathsDictionary;
}

//创建CTFrame
- (CTFrameRef)p_createFrameWithFramesetter:(CTFramesetterRef)framesetter
                                    height:(CGFloat)height
                         clippingPathArray:(NSMutableArray *)pathsArray{
    
    CFDictionaryRef clippingDic=[self p_getClippingPathsDictionaryWithPathArray:pathsArray];
    
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRect(path, NULL, CGRectMake(0, 0, self.width, height));
    CTFrameRef frame = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, 0), path, clippingDic);
    
    CFRelease(path);
    CFRelease(clippingDic);
    return frame;
}

/*
 KYSCoreTextImageLayoutTypeAuto = 0,//默认
 KYSCoreTextImageLayoutTypeAssign = 1
 
 计算图片位置，返回文本高度
 */
- (NSInteger)p_getCTFrameHeightAndCalculateImageFrame{
    NSAttributedString *content=self.coreTextParse.text;
    NSArray *imageArray=self.coreTextParse.imageArray;
    if (!content.length) {
        NSLog(@"content is nil or length=0");
        return -1;
    }
    
    //1.创建CTFramesetterRef实例
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)content);
    
    //2.计算没图片时文本高度
    NSLog(@"width: %f",self.width);
    
    //坐标转换 CoreText->UIKit
    CGAffineTransform transform = CGAffineTransformIdentity;
    transform = CGAffineTransformScale(transform, 1, -1);
    transform = CGAffineTransformTranslate(transform, 0, -KYS_CORETEXT_MAX_HEIGHT);
    
    CTFrameRef frame=nil;
    NSMutableArray *pathsArray = [[NSMutableArray alloc] init];
    if(KYSCoreTextImageLayoutTypeAssign==self.imageLayoutType){
        for (KYSCoreTextImage *coreTextImage in imageArray) {
            NSLog(@"image point: %@",NSStringFromCGRect(coreTextImage.frame));
            CGPathRef clipPath = CGPathCreateWithRect(coreTextImage.frame, &transform);
            [pathsArray addObject:(__bridge id)(clipPath)];
            CFRelease(clipPath);
        }
        frame=[self p_createFrameWithFramesetter:framesetter height:KYS_CORETEXT_MAX_HEIGHT clippingPathArray:pathsArray];
    }else{
        //默认 KYSCoreTextImageLayoutTypeAuto
        frame=[self p_createFrameWithFramesetter:framesetter height:KYS_CORETEXT_MAX_HEIGHT clippingPathArray:pathsArray];
        //一张一张的计算
        for (KYSCoreTextImage *coreTextImage in imageArray) {
            NSInteger height = [KYSCoreTextUtils getTextHeightWithCTFrame:frame];
            NSLog(@"height: %ld",(long)height);
            //获取image.index对应的origin
            CGRect characterFrame = [KYSCoreTextUtils CTFrame:frame characterIndex:coreTextImage.index];
            CFRelease(frame);
            CGRect rect = CGRectApplyAffineTransform(characterFrame, transform);
            
            NSLog(@"image point1: %@",NSStringFromCGRect(coreTextImage.frame));
            //调整X轴坐标，避免超出X轴
            if ((rect.origin.x+coreTextImage.size.width)>self.width) {
                CGFloat x=self.width-(coreTextImage.size.width+10);
                //防止图片宽度大于视图宽度
                rect.origin.x=x<0?0:x;
            }
            
            //保存图片坐标
            coreTextImage.origin=rect.origin;
            NSLog(@"image point2: %@",NSStringFromCGRect(coreTextImage.frame));
            CGPathRef clipPath = CGPathCreateWithRect(coreTextImage.frame, &transform);
            [pathsArray addObject:(__bridge id)(clipPath)];
            CFRelease(clipPath);
            
            frame=[self p_createFrameWithFramesetter:framesetter height:KYS_CORETEXT_MAX_HEIGHT clippingPathArray:pathsArray];
        }
    }
    NSInteger height = [KYSCoreTextUtils getTextHeightWithCTFrame:frame];
    CFRelease(frame);
    CFRelease(framesetter);
    return height;
}

/*
 KYSCoreTextImageLayoutTypeLine = 2
 计算图片位置
 */
- (NSInteger)p_getCTFrameHeightAndCalculateLineImageFrame{
    
    NSAttributedString *content=self.coreTextParse.text;
    NSArray *imageArray=self.coreTextParse.imageArray;
    if (!content.length) {
        NSLog(@"content is nil or length=0");
        return -1;
    }
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)content);
    //另2种计算布局方式，不能用这种方式计算
    CGSize size = CGSizeMake(self.width, CGFLOAT_MAX);
    CGSize coreTextSize = CTFramesetterSuggestFrameSizeWithConstraints(framesetter, CFRangeMake(0,0), nil, size, nil);
    CGFloat height = coreTextSize.height;
    
    //坐标转换
    CGAffineTransform transform = CGAffineTransformIdentity;
    transform = CGAffineTransformScale(transform, 1, -1);
    transform = CGAffineTransformTranslate(transform, 0, -height);
    
    CTFrameRef frame=[self p_createFrameWithFramesetter:framesetter height:height clippingPathArray:nil];
    
    NSArray *lines = (NSArray *)CTFrameGetLines(frame);
    NSUInteger lineCount = [lines count];
    CGPoint lineOrigins[lineCount];
    CTFrameGetLineOrigins(frame, CFRangeMake(0, 0), lineOrigins);
    
    __block int imageIndex = 0;
    __block KYSCoreTextLineImage *coreTextImage = imageArray[imageIndex];
    [KYSCoreTextUtils CTFrame:frame enumerateLinesBlock:^(CTLineRef line, CGPoint lineOrigin, CFIndex lineIndex, BOOL *lineStop) {
        if (!coreTextImage) {
            *lineStop=YES;
        }
    } runsBlock:^(CTLineRef line, CGPoint lineOrigin, CFIndex lineIndex, CTRunRef run, CFIndex runIndex, BOOL *runStop) {
        NSDictionary *runAttributes = (NSDictionary *)CTRunGetAttributes(run);
        CTRunDelegateRef delegate = (__bridge CTRunDelegateRef)[runAttributes valueForKey:(id)kCTRunDelegateAttributeName];
        if (!delegate) {
            return;
        }
        
        NSDictionary * metaDic = CTRunDelegateGetRefCon(delegate);
        if (![metaDic isKindOfClass:[NSDictionary class]]) {
            return;
        }
        
        CGFloat xOffset,width,ascent,descent;
        width = CTRunGetTypographicBounds(run, CFRangeMake(0, 0), &ascent, &descent, NULL);
        xOffset = CTLineGetOffsetForStringIndex(line, CTRunGetStringRange(run).location, NULL);
        CGRect runBounds=CGRectMake(lineOrigin.x + xOffset, lineOrigin.y - descent, width, ascent + descent);
        
        CGPathRef pathRef = CTFrameGetPath(frame);
        CGRect colRect = CGPathGetBoundingBox(pathRef);
        
        CGRect delegateBounds = CGRectOffset(runBounds, colRect.origin.x, colRect.origin.y);
        
        CGRect rect = CGRectApplyAffineTransform(delegateBounds, transform);
        //NSLog(@"%@",NSStringFromCGRect(delegateBounds));
        
        //转换UIKit成坐标系
        coreTextImage.origin = rect.origin;
        //NSLog(@"%@",NSStringFromCGPoint(coreTextImage.origin));
        imageIndex++;
        if (imageIndex == imageArray.count) {
            coreTextImage = nil;
            *runStop=YES;
        } else {
            coreTextImage = imageArray[imageIndex];
        }
    }];
    return height;
}



@end
