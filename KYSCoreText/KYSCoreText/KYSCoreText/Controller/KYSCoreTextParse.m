//
//  KYSCoreTextParse.m
//  KYSCoreText
//
//  Created by Liu Zhao on 16/7/1.
//  Copyright © 2016年 康永帅. All rights reserved.
//

#import "KYSCoreTextParse.h"
#import "KYSCoreTextLink.h"
#import "KYSCoreTextImage.h"
#import "KYSCoreTextLineImage.h"
#import "KYSCoreTextTelephone.h"

@interface KYSCoreTextParse()

@property (nonatomic,strong) NSMutableAttributedString *text;
@property (nonatomic,strong) NSMutableArray *imageArray;
@property (nonatomic,strong) NSMutableArray *linkArray;
@property (nonatomic,strong) NSMutableArray *telephoneArray;

@end


@implementation KYSCoreTextParse

- (instancetype)initWithTemplateFile:(NSString *)path
                        attributeDic:(NSMutableDictionary *)attributeDic
                     imageLayoutType:(KYSCoreTextImageLayoutType)imageLayoutType{
    self=[super init];
    if (self) {
        [self p_createAttributedStringWithTemplateFile:path attributeDic:attributeDic imageLayoutType:imageLayoutType];
    }
    return self;
}


#pragma mark - private
- (void )p_createAttributedStringWithTemplateFile:(NSString *)path
                                     attributeDic:(NSMutableDictionary *)attributeDic
                                  imageLayoutType:(KYSCoreTextImageLayoutType)imageLayoutType{
    NSData *data = [NSData dataWithContentsOfFile:path];
    if (data) {
        NSArray *array = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
        if ([array isKindOfClass:[NSArray class]]) {
            for (NSDictionary *dic in array) {
                NSString *type = dic[KYSCoreTextType];
                if ([type isEqualToString:KYSCoreTextTypeText]) {
                    //生成数据模型
                    KYSCoreTextText *linkData = [[KYSCoreTextText alloc] initWithDic:dic];
                    //拼接文本
                    NSDictionary *attributes=[linkData attributesWithSharedDic:attributeDic];
                    NSAttributedString *linkStr=[[NSAttributedString alloc] initWithString:linkData.text attributes:attributes];
                    [self.text appendAttributedString:linkStr];
                } else if ([type isEqualToString:KYSCoreTextTypeImage]) {
                    if (KYSCoreTextImageLayoutTypeLine==imageLayoutType) {
                        KYSCoreTextLineImage *coreTextImage=[[KYSCoreTextLineImage alloc] initWithDic:dic];
                        coreTextImage.index=self.text.length;
                        [self.imageArray addObject:coreTextImage];
                        NSAttributedString *spaceString=[coreTextImage spaceString];
                        [self.text appendAttributedString:spaceString];
                    }else{
                        KYSCoreTextImage *coreTextImage=[[KYSCoreTextImage alloc] initWithDic:dic];
                        coreTextImage.index=self.text.length;
                        [self.imageArray addObject:coreTextImage];
                    }
                } else if ([type isEqualToString:KYSCoreTextTypeLink]) {
                    NSUInteger startPos = self.text.length;
                    //生成数据模型
                    KYSCoreTextLink *link = [[KYSCoreTextLink alloc] initWithDic:dic];
                    [self.linkArray addObject:link];
                    //拼接文本
                    NSDictionary *attributes=[link attributesWithSharedDic:attributeDic];
                    NSAttributedString *linkStr=[[NSAttributedString alloc] initWithString:link.text attributes:attributes];
                    [self.text appendAttributedString:linkStr];
                    //计算range
                    NSUInteger length = self.text.length - startPos;
                    NSRange linkRange = NSMakeRange(startPos, length);
                    link.range = linkRange;
                } else if ([type isEqualToString:KYSCoreTextTypeTelephone]){
                    NSUInteger startPos = self.text.length;
                    //生成数据模型
                    KYSCoreTextTelephone *telephone = [[KYSCoreTextTelephone alloc] initWithDic:dic];
                    [self.telephoneArray addObject:telephone];
                    //拼接文本
                    NSDictionary *attributes=[telephone attributesWithSharedDic:attributeDic];
                    NSAttributedString *linkStr=[[NSAttributedString alloc] initWithString:telephone.text attributes:attributes];
                    [self.text appendAttributedString:linkStr];
                    //计算range
                    NSUInteger length = self.text.length - startPos;
                    NSRange linkRange = NSMakeRange(startPos, length);
                    telephone.range = linkRange;
                }
            }
        }
    }
}

#pragma mark - data
- (NSMutableAttributedString *)text{
    if (!_text) {
        _text = [[NSMutableAttributedString alloc] init];
    }
    return _text;
}


- (NSMutableArray *)imageArray{
    if (!_imageArray) {
        _imageArray=[[NSMutableArray alloc] init];
    }
    return _imageArray;
}

- (NSMutableArray *)linkArray{
    if (!_linkArray) {
        _linkArray=[[NSMutableArray alloc] init];
    }
    return _linkArray;
}

- (NSMutableArray *)telephoneArray{
    if (!_telephoneArray) {
        _telephoneArray=[[NSMutableArray alloc] init];
    }
    return _telephoneArray;
}












@end
