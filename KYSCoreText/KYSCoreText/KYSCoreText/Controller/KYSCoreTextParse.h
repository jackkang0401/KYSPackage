//
//  KYSCoreTextParse.h
//  KYSCoreText
//
//  Created by Liu Zhao on 16/7/1.
//  Copyright © 2016年 康永帅. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KYSCoreText.h"

@interface KYSCoreTextParse : NSObject

@property (nonatomic,strong,readonly) NSMutableAttributedString *text;
@property (nonatomic,strong,readonly) NSMutableArray *imageArray;
@property (nonatomic,strong,readonly) NSMutableArray *linkArray;
@property (nonatomic,strong,readonly) NSMutableArray *telephoneArray;


- (instancetype)initWithTemplateFile:(NSString *)path
                        attributeDic:(NSMutableDictionary *)attributeDic
                     imageLayoutType:(KYSCoreTextImageLayoutType)imageLayoutType;

@end
