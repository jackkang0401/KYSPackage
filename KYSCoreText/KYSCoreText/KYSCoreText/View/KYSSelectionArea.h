//
//  KYSSelectionArea.h
//  KYSCoreText
//
//  Created by Liu Zhao on 16/6/28.
//  Copyright © 2016年 康永帅. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CoreText/CoreText.h"

@protocol KYSSelectionAreaDataSource <NSObject>

- (CTFrameRef)selectionAreaRelatedCTFrame;
- (NSAttributedString *)selectionAreaRelatedAttributedString;

@end

@interface KYSSelectionArea : NSObject

@property (nonatomic,weak) id<KYSSelectionAreaDataSource> dataSource;
@property (nonatomic,assign) NSInteger startIndex;
@property (nonatomic,assign) NSInteger endIndex;

@property (nonatomic,assign) BOOL isTouchStartAnchor;
@property (nonatomic,assign) BOOL isTouchEndAnchor;

@property (nonatomic,strong,readonly) UIImageView *startAnchor;
@property (nonatomic,strong,readonly) UIImageView *endAnchor;

- (void)addAnchorInView:(UIView *)view;

- (void)removeAnchor;

- (void)refreshAnchorWithStartHeight:(CGFloat)startHeight;

- (void)refreshAnchorWithEndHeight:(CGFloat)endHeight;

- (void)refreshAnchorWithStartHeight:(CGFloat)startHeight endHeight:(CGFloat)endHeight;

- (NSArray *)selectionLineRects;

- (void)getCenterWithStartBlock:(void(^)(CGPoint startCencer)) startBlock
                       endBlock:(void(^)(CGPoint endCencer)) endBlock
                      transform:(const CGAffineTransform *) transform;

@end
