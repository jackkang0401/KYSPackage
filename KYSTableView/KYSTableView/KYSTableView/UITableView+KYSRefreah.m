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

- (BOOL)kys_isRefreshing{
    if ([self kys_isHeaderRefreshing]||[self kys_isFooterRefreshing]) {
        return YES;
    }
    return NO;
}

- (BOOL)kys_isHeaderRefreshing{
    if ([self.header isRefreshing]) {
        return YES;
    }
    return NO;
}

- (BOOL)kys_isFooterRefreshing{
    if ([self.footer isRefreshing]) {
        return YES;
    }
    return NO;
}

- (void)kys_pullDownRefreshingBlock:(KYSTableViewRefreshingBlock) block{
    if (block) {
        self.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            if (block) {
                block();
            }
        }];
    }else{
        self.header=nil;
    }
}

- (void)kys_pullUpRefreshingBlock:(KYSTableViewRefreshingBlock) block{
    if (block) {
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
