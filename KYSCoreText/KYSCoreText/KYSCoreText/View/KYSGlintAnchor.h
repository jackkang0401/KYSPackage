//
//  KYSGlintAnchor.h
//  KYSCoreText
//
//  Created by Liu Zhao on 16/6/27.
//  Copyright © 2016年 康永帅. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CoreText/CoreText.h"

@protocol KYSGlintAnchorDataSource <NSObject>

//@optional
- (CTFrameRef)glintAnchorRelatedCTFrame;

@end


@interface KYSGlintAnchor : UIView

@property(nonatomic,weak)id<KYSGlintAnchorDataSource> dataSource;

@property (nonatomic,assign) NSInteger index;
@property (nonatomic,assign) BOOL isTouch;

- (void)startGlint;

- (void)endGlint;

- (void)refreshAnchorWithHeight:(CGFloat)height;

@end
