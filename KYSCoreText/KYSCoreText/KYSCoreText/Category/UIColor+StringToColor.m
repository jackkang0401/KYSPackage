//
//  UIColor+StringToColor.m
//  KYSCoreText
//
//  Created by 康永帅 on 16/6/19.
//  Copyright © 2016年 康永帅. All rights reserved.
//

#import "UIColor+StringToColor.h"
#import "KYSCoreText.h"

@implementation UIColor (StringToColor)

//默认黑色
+ (UIColor *)colorFromString:(NSString *)name {
    if (!name.length) {
        return [UIColor blackColor];
    }
    static NSDictionary *colorDic=nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        colorDic=@{KYSCoreTextBlackColor:[UIColor blackColor],
                   KYSCoreTextDarkGrayColor:[UIColor darkGrayColor],
                   KYSCoreTextLightGrayColor:[UIColor lightGrayColor],
                   KYSCoreTextWhiteColor:[UIColor whiteColor],
                   KYSCoreTextGrayColor:[UIColor grayColor],
                   KYSCoreTextRedColor:[UIColor redColor],
                   KYSCoreTextGreenColor:[UIColor greenColor],
                   KYSCoreTextBlueColor:[UIColor blueColor],
                   KYSCoreTextCyanColor:[UIColor cyanColor],
                   KYSCoreTextYellowColor:[UIColor yellowColor],
                   KYSCoreTextMagentaColor:[UIColor magentaColor],
                   KYSCoreTextOrangeColor:[UIColor orangeColor],
                   KYSCoreTextPurpleColor:[UIColor purpleColor],
                   KYSCoreTextBrownColor:[UIColor brownColor],
                   KYSCoreTextClearColor:[UIColor clearColor]};
    });
    
    //如果在字典里找到直接返回
    UIColor *color=colorDic[name];
    if (color) {
        return color;
    }
    //逗号 竖线 空格
    NSCharacterSet *characterSet = [NSCharacterSet characterSetWithCharactersInString:@",| "];
    NSArray *rgbArray=[name componentsSeparatedByCharactersInSet:characterSet];
    //R G B alpha
    if (3<=rgbArray.count && 4>=rgbArray.count) {
        return [UIColor colorWithRed:[rgbArray[0] floatValue]/255.0
                               green:[rgbArray[1] floatValue]/255.0
                                blue:[rgbArray[2] floatValue]/255.0
                               alpha:4==rgbArray.count?[rgbArray[3] floatValue]:1];
    }
    return [UIColor blackColor];
}

@end
