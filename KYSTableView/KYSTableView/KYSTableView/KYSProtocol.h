//
//  KYSProtocol.h
//  KYSTableView
//
//  Created by Liu Zhao on 16/8/12.
//  Copyright © 2016年 Kang YongShuai. All rights reserved.
//

#import <UIKit/UIKit.h>

@class KYSNumData;

#ifndef KYSProtocol_h
#define KYSProtocol_h



#pragma mark - KYSNumDataPrococol
@protocol KYSNumDataPrococol <NSObject>

@required

//未使用固定高度存放自动计算的高度
@property(nonatomic,assign)CGFloat cellHeight;
//将字典转换成模型
+ (KYSNumData *)transformWithDictionary:(NSDictionary *)dic;

@end



#pragma mark - KYSTableViewCellProtocol
//对应cell实现此协议
@protocol KYSTableViewCellProtocol <NSObject>

@required
//设置cell数据
- (void)setCellDataWithObject:(KYSNumData *)data;

@end



#pragma mark - KYSTableViewProtocal
@protocol KYSTableViewProtocal <NSObject>

@required
//返回使用到的cell的identifier
- (NSString *)tableView:(UITableView *)tableView cellIndentifierForRowAtIndexPath:(NSIndexPath *)indexPath;

@optional
//如果在storyboard里的TableView布局Cell无需实现此方法，否则必须实现
- (NSString *)tableView:(UITableView *)tableView cellNameForRowAtIndexPath:(NSIndexPath *)indexPath;
//下拉刷新
- (NSString *)pullDownActionInTableView:(UITableView *)tableView;
//上拉刷新
- (NSString *)pullUpActionInTableView:(UITableView *)tableView;

@end

#endif /* KYSProtocol_h */
