//
//  UITableView+KYSRefreah.h
//  KYSTableView
//
//  Created by Liu Zhao on 16/8/17.
//  Copyright © 2016年 Kang YongShuai. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^KYSTableViewRefreshingBlock)();

@interface UITableView (KYSRefreah)

- (BOOL)kys_isRefreshing;

- (BOOL)kys_isHeaderRefreshing;

- (BOOL)kys_isFooterRefreshing;

- (void)kys_pullDownRefreshingBlock:(KYSTableViewRefreshingBlock) block;

- (void)kys_pullUpRefreshingBlock:(KYSTableViewRefreshingBlock) block;

- (void)kys_startPullDownRefreshing;

- (void)kys_endPullDownRefreshing;

- (void)kys_startPullUpRefreshing;

- (void)kys_endPullUpRefreshing;

- (void)kys_didLoadLastPage;

@end
