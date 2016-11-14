//
//  UITableView+KYSRefreah.m
//  KYSTableView
//
//  Created by Liu Zhao on 16/8/17.
//  Copyright © 2016年 Kang YongShuai. All rights reserved.
//

#import "UITableView+KYSRefreah.h"
#import <MJRefresh/MJRefresh.h>

@implementation UITableView (KYSRefreah)

#pragma mark - refresh

- (BOOL)kys_pullDownRefreshEnable{
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}

- (void)kys_pullDownRefreshEnable:(BOOL)enable
                  refreshingBlock:(KYSTableViewRefreshingBlock) block{
    objc_setAssociatedObject(self, @selector(kys_pullDownRefreshEnable), @(enable), OBJC_ASSOCIATION_RETAIN);
    if (enable) {
        self.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            if (block) {
                block();
            }
        }];
    }else{
        self.header=nil;
    }
}

- (BOOL)kys_pullUpRefreshEnable{
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}

- (void)kys_pullUpRefreshEnable:(BOOL)enable
                refreshingBlock:(KYSTableViewRefreshingBlock) block{
    objc_setAssociatedObject(self, @selector(kys_pullUpRefreshEnable), @(enable), OBJC_ASSOCIATION_RETAIN);
    if (enable) {
        self.footer = [MJRefreshAutoStateFooter footerWithRefreshingBlock:^{
            if (block) {
                block();
            }
        }];
    
    }else{
        self.footer=nil;
    }
}

- (void)kys_startPullDownRefreshing {
    if (self.header&&![self.header isRefreshing]) {
        //调用此方法会触发刷新block
        [self.header beginRefreshing];
    }
}

- (void)kys_endPullDownRefreshing {
    if (self.header&&[self.header isRefreshing]) {
        [self.header endRefreshing];
    }
}

- (void)kys_startPullUpRefreshing {
    if (self.footer&&[self.footer isRefreshing]) {
        //调用此方法会触发刷新block
        [self.footer beginRefreshing];
    }
}

- (void)kys_endPullUpRefreshing {
    if (self.footer) {
        [self.footer resetNoMoreData];
        if([self.footer isRefreshing]){
            [self.footer endRefreshing];
        }
    }
}

- (void)kys_didLoadLastPage {
    [self.footer endRefreshingWithNoMoreData];
}

@end
