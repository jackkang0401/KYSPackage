//
//  KYSCoreTextImage.m
//  KYSCoreText
//
//  Created by 康永帅 on 16/6/19.
//  Copyright © 2016年 康永帅. All rights reserved.
//

#import "KYSCoreTextImage.h"
#import "KYSCoreText.h"

@interface KYSCoreTextImage()

@property (nonatomic,copy) NSString *name;
@property (nonatomic,assign) CGSize size;

@end

@implementation KYSCoreTextImage

- (instancetype)initWithDic:(NSDictionary *)dic{
    self=[super init];
    if (self) {
        self.name=dic[KYSCoreTextImageName];
        self.origin=CGPointMake([dic[KYSCoreTextX] floatValue], [dic[KYSCoreTextY] floatValue]);
        self.size=CGSizeMake([dic[KYSCoreTextWidth] floatValue], [dic[KYSCoreTextHeight] floatValue]);
    }
    return self;
}

- (CGRect)frame{
    return CGRectMake(_origin.x, _origin.y, _size.width, _size.height);
}

// 检测是否点击了某个图片
+ (KYSCoreTextImage *)getTouchImageInCTFrame:(CTFrameRef) frame
                                  imageArray:(NSArray *) imageArray
                                        view:(UIView *) view
                                     atPoint:(CGPoint) point{
    for (KYSCoreTextImage * coreTextImage in imageArray){
        CGRect rect = coreTextImage.frame;
        if (CGRectContainsPoint(rect, point)) {
            NSLog(@"image: %@",coreTextImage);
            return coreTextImage;
        }
    }
    return nil;
}

@end
