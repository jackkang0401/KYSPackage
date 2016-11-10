//
//  UIView+KYSCategory.h
//  KYSCoreText
//
//  Created by 康永帅 on 16/6/19.
//  Copyright © 2016年 康永帅. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (KYSCategory)

@property (nonatomic,assign) CGFloat minX;
@property (nonatomic,assign) CGFloat minY;
@property (nonatomic,assign) CGFloat maxX;
@property (nonatomic,assign) CGFloat maxY;
@property (nonatomic,assign) CGFloat width;
@property (nonatomic,assign) CGFloat height;
@property (nonatomic,assign) CGFloat centerX;
@property (nonatomic,assign) CGFloat centerY;
@property (nonatomic,assign) CGPoint origin;
@property (nonatomic,assign) CGSize  size;

- (CGPoint)convertPoint:(CGPoint)point toViewOrWindow:(UIView *)view;

- (CGPoint)convertPoint:(CGPoint)point fromViewOrWindow:(UIView *)view;

@end
