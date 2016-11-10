//
//  KYSGlintAnchor.m
//  KYSCoreText
//
//  Created by Liu Zhao on 16/6/27.
//  Copyright © 2016年 康永帅. All rights reserved.
//

#import "KYSGlintAnchor.h"
#import "KYSCoreTextUtils.h"
#import "KYSCoreText.h"

@interface KYSGlintAnchor()

@property(nonatomic,assign)BOOL needEndGlint;

@end


@implementation KYSGlintAnchor

- (id)init {
    return [self initWithFrame:CGRectZero];
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.needEndGlint=NO;
        self.backgroundColor=RGB(28, 107, 222);
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.needEndGlint=NO;
        self.backgroundColor=RGB(28, 107, 222);
    }
    return self;
}

- (void)setIndex:(NSInteger)index{
    if (_index==index) {
        return;
    }
    _index=index;
    
    if ([_dataSource respondsToSelector:@selector(glintAnchorRelatedCTFrame)]) {
        CTFrameRef textFrame=[_dataSource glintAnchorRelatedCTFrame];
        if (textFrame) {
            CGFloat height=[KYSCoreTextUtils getLineTextHeightWithCTFrame:textFrame atIndex:index];
            [self refreshAnchorWithHeight:height];
        }
    }
}

- (void)startGlint{
    __weak typeof(self) wSelf=self;
    [UIView animateWithDuration:0.5 animations:^{
        wSelf.alpha=0.0;
    } completion:^(BOOL finished) {
        if (wSelf.needEndGlint) {
            wSelf.alpha=1.0;
            return;
        }
        [UIView animateWithDuration:0.5 animations:^{
            wSelf.alpha=1.0;
        } completion:^(BOOL finished) {
            if (wSelf.needEndGlint) {
                wSelf.alpha=1.0;
            }else{
                [wSelf startGlint];
            }
        }];
    }];
}

- (void)endGlint{
    self.needEndGlint=YES;
}

- (void)refreshAnchorWithHeight:(CGFloat)height{
    CGFloat width = height/10;
    width=width<1.0?1.0:width>4.0?4.0:width;
    self.frame=CGRectMake(0, 0, width, height);
}


@end
