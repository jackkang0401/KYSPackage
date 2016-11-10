//
//  KYSCoreTextImage.h
//  KYSCoreText
//
//  Created by 康永帅 on 16/6/19.
//  Copyright © 2016年 康永帅. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <CoreText/CoreText.h>

@interface KYSCoreTextImage : NSObject

@property (nonatomic,copy,readonly) NSString *name;
@property (nonatomic,assign,readonly) CGSize size;

@property (nonatomic,assign) NSUInteger index;//标记图片在哪个字符后
@property (nonatomic,assign) CGPoint origin;
@property (nonatomic,assign,readonly) CGRect frame;

- (instancetype)initWithDic:(NSDictionary *)dic;

// 检测是否点击了某个图片
+ (KYSCoreTextImage *)getTouchImageInCTFrame:(CTFrameRef) frame
                                  imageArray:(NSArray *) imageArray
                                        view:(UIView *) view
                                     atPoint:(CGPoint) point;

@end
