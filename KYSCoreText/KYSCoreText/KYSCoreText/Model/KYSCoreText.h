//
//  KYSCoreText.h
//  KYSCoreText
//
//  Created by 康永帅 on 16/6/19.
//  Copyright © 2016年 康永帅. All rights reserved.
//

#import <Foundation/Foundation.h>

#define RGB(R, G, B) [UIColor colorWithRed:(R)/255.0 green:(G)/255.0 blue:(B)/255.0 alpha:1.0]
#define KYS_CORETEXT_MAX_HEIGHT 1000

typedef NS_ENUM(NSInteger, KYSCoreTextImageLayoutType) {
    KYSCoreTextImageLayoutTypeAuto = 0,//默认
    KYSCoreTextImageLayoutTypeAssign = 1,
    KYSCoreTextImageLayoutTypeLine = 2
};

#pragma mark - TYPE
extern NSString *const KYSCoreTextType;
extern NSString *const KYSCoreTextTypeText;
extern NSString *const KYSCoreTextTypeImage;
extern NSString *const KYSCoreTextTypeLink;
extern NSString *const KYSCoreTextTypeTelephone;


#pragma mark - KEY
extern NSString *const KYSCoreTextContent;
extern NSString *const KYSCoreTextColor;
extern NSString *const KYSCoreTextFontName;
extern NSString *const KYSCoreTextFontSize;
extern NSString *const KYSCoreTextURL;

extern NSString *const KYSCoreTextImageLayout;
extern NSString *const KYSCoreTextImageLayoutAuto;   //图片与多行文字并列（默认）
extern NSString *const KYSCoreTextImageLayoutAssign; //指定图片位置
extern NSString *const KYSCoreTextImageLayoutLine;   //图片与文字在同一行

extern NSString *const KYSCoreTextImageName;
extern NSString *const KYSCoreTextX;
extern NSString *const KYSCoreTextY;
extern NSString *const KYSCoreTextWidth;
extern NSString *const KYSCoreTextHeight;


#pragma mark - Color
extern NSString *const KYSCoreTextRGBColor;

extern NSString *const KYSCoreTextBlackColor;
extern NSString *const KYSCoreTextDarkGrayColor;
extern NSString *const KYSCoreTextLightGrayColor;
extern NSString *const KYSCoreTextWhiteColor;
extern NSString *const KYSCoreTextGrayColor;
extern NSString *const KYSCoreTextRedColor;
extern NSString *const KYSCoreTextGreenColor;
extern NSString *const KYSCoreTextBlueColor;
extern NSString *const KYSCoreTextCyanColor;
extern NSString *const KYSCoreTextYellowColor;
extern NSString *const KYSCoreTextMagentaColor;
extern NSString *const KYSCoreTextOrangeColor;
extern NSString *const KYSCoreTextPurpleColor;
extern NSString *const KYSCoreTextBrownColor;
extern NSString *const KYSCoreTextClearColor;


