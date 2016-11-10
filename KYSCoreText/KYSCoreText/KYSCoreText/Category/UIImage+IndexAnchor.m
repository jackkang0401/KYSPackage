//
//  UIImage+IndexAnchor.m
//  KYSCoreText
//
//  Created by 康永帅 on 16/6/19.
//  Copyright © 2016年 康永帅. All rights reserved.
//

#import "UIImage+IndexAnchor.h"

@implementation UIImage (IndexAnchor)

+ (UIImage *)imageWithFontHeight:(CGFloat)height diameter:(CGFloat)diameter color:(UIColor *)color isTop:(BOOL)top{
    
    NSInteger radius=diameter/2;
    //图片放大2倍
    CGRect rect = CGRectMake(0,0,diameter*2,(height+diameter*2)*2);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextAddEllipseInRect(context,CGRectMake(0, top?0:(height+diameter)*2, diameter*2, diameter*2));
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextFillPath(context);
    [color set];
    CGContextSetLineWidth(context, radius*2);
    CGContextMoveToPoint(context, radius*2, diameter*2);
    CGContextAddLineToPoint(context, radius*2, (height+diameter)*2);
    CGContextStrokePath(context);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

@end
