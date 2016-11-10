//
//  KYSCoreTextView.h
//  KYSCoreText
//
//  Created by 康永帅 on 16/6/19.
//  Copyright © 2016年 康永帅. All rights reserved.
//

#import <UIKit/UIKit.h>

@class KYSCoreText;
@class KYSCoreTextStorage;

@interface KYSCoreTextView : UIView

@property(nonatomic,assign,readonly)CGFloat coreTextHeight;

@property (strong, nonatomic) KYSCoreTextStorage *coreTextData;

@end
