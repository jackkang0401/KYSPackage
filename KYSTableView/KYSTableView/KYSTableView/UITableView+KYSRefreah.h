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

//标记是否添加下拉刷新
@property(nonatomic,assign,readonly)BOOL kys_pullDownRefreshEnable;
//标记是否添加上拉刷新
@property(nonatomic,assign,readonly)BOOL kys_pullUpRefreshEnable;

- (void)kys_pullDownRefreshEnable:(BOOL)enable
                  refreshingBlock:(KYSTableViewRefreshingBlock) block;

- (void)kys_pullUpRefreshEnable:(BOOL)enable
                refreshingBlock:(KYSTableViewRefreshingBlock) block;

- (void)kys_startPullDownRefreshing;

- (void)kys_endPullDownRefreshing;

- (void)kys_startPullUpRefreshing;

- (void)kys_endPullUpRefreshing;

- (void)kys_didLoadLastPage;

@end
