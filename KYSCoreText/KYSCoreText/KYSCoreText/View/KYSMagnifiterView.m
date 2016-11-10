//
//  KYSMagnifiterView.m
//  KYSCoreText
//
//  Created by 康永帅 on 16/6/19.
//  Copyright © 2016年 康永帅. All rights reserved.
//

#import "KYSMagnifiterView.h"
#import "UIView+KYSCategory.h"

@implementation KYSMagnifiterView

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:CGRectMake(0, 0, 80, 80)]) {
        // make the circle-shape outline with a nice border.
        self.layer.borderColor = [[UIColor lightGrayColor] CGColor];
        self.layer.borderWidth = 1;
        self.layer.cornerRadius = 40;
        self.layer.masksToBounds = YES;
    }
    return self;
}

- (void)setTouchPoint:(CGPoint)touchPoint {
    // superView's point
    _touchPoint = touchPoint;
    // update the position of the magnifier (to just above what's being magnified)
    self.center = CGPointMake(touchPoint.x, touchPoint.y - 70);
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {
    // here we're just doing some transforms on the view we're magnifying,
    // and rendering that view directly into this view,
    // rather than the previous method of copying an image.
    
    UIWindow *window=[UIApplication sharedApplication].keyWindow;
    CGPoint windowPoint = [_viewToMagnify convertPoint:_touchPoint toViewOrWindow:window];
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(context, self.width * 0.5, self.height * 0.5);
    CGContextScaleCTM(context, 1.5, 1.5);
    CGContextTranslateCTM(context, -1 * (windowPoint.x), -1 * (windowPoint.y));
    [window.layer renderInContext:context];
}

@end
