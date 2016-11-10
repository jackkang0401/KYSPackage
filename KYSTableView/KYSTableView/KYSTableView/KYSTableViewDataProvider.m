//
//  KYSTableViewDataProvider.m
//  KYSTableView
//
//  Created by 康永帅 on 16/8/13.
//  Copyright © 2016年 Kang YongShuai. All rights reserved.
//

#import "KYSTableViewDataProvider.h"
#import "KYSSectionData.h"
#import "KYSNumData.h"
#import "UITableView+KYSRefreah.h"

@interface KYSTableViewDataProvider()

@property(nonatomic,weak)id<KYSTableViewDataProviderDelegate> delegate;
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,copy)KYSDataProviderLoad loadBlock;
@property(nonatomic,copy)KYSDataProviderLoadPageData loadPageDataBlock;
@property(nonatomic,assign)BOOL isPageData;
@property(nonatomic,assign)NSInteger currentPage;
@property(nonatomic,assign)NSInteger totalPage;
@property(nonatomic,assign)BOOL isLoading;//标识是否有获取数据的任务
@property(nonatomic,strong)dispatch_queue_t syncQueue;

@end


@implementation KYSTableViewDataProvider{
    BOOL _isLoading;
}

@synthesize isLoading = _isLoading;//不写这个，不能同事在setter和getter方法里访问 _isLoading,why？what happen？

- (instancetype)initWithTableView:(UITableView *)tableView
                         delegate:(id<KYSTableViewDataProviderDelegate>)delegate
                        loadBlock:(KYSDataProviderLoad) loadBlock{
    self=[super init];
    if (self) {
        self.syncQueue=dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        self.delegate=delegate;
        self.tableView=tableView;
        self.loadBlock=loadBlock;
    }
    return self;
}

//加载分页数据
- (instancetype)initWithTableView:(UITableView *)tableView
                         delegate:(id<KYSTableViewDataProviderDelegate>)delegate
                loadPageDataBlock:(KYSDataProviderLoadPageData) loadPageDataBlock{
    self=[super init];
    if (self) {
        self.syncQueue=dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        self.delegate=delegate;
        self.tableView=tableView;
        self.loadPageDataBlock=loadPageDataBlock;
        self.currentPage=-1;
        self.totalPage=0;
    }
    return self;
}

- (void)loadData{
    if (self.isLoading) {
        NSLog(@"有正在刷新的内容");
        return;
    }
    if (self.loadBlock) {
        __weak typeof (self) weakSelf=self;
        KYSDataProviderAction action=^(NSMutableArray<KYSSectionData *> * sectionsArray){
            typeof (weakSelf) strongSelf=weakSelf;
            //NSLog(@"action: %@",sectionsArray);
            [strongSelf.sectionsArray removeAllObjects];
            [strongSelf.sectionsArray addObjectsFromArray:sectionsArray];
            if (strongSelf.delegate&&[strongSelf.delegate respondsToSelector:@selector(dataDidUpdate)]) {
                [strongSelf.delegate dataDidUpdate];
            }
            //停止下拉动画
            [strongSelf p_endPullDownRefreshAnimation];
            strongSelf.isLoading=NO;
        };
        
        self.isLoading=YES;
        //开始加载数据
        self.loadBlock(action);
    }
}

//下拉刷新
- (void)loadDataWithAnimation{
    [self.tableView kys_startPullDownRefreshing];
}

//处理分页
//加载第第一页(下拉使用)
- (void)loadFirstPage{
    self.currentPage=-1;
    self.totalPage=0;
    [self p_loadPageDataNeedCleanOldData:YES];
}

- (void)loadFirstPageWithAnimation{
    [self.tableView kys_startPullDownRefreshing];
}

//加载下一页(上拉使用)
- (void)loadNextPage{
    [self p_loadPageDataNeedCleanOldData:NO];
}

- (void)p_loadPageDataNeedCleanOldData:(BOOL)needClean{
    
    NSLog(@"112233445666:%d",self.isLoading);
    
    if (self.isLoading) {
        NSLog(@"有正在刷新的内容");
        return;
    }
    if (self.currentPage>=self.totalPage) {
        NSLog(@"已经加载全部数据");
        return;
    }
    if (self.loadPageDataBlock) {
        __weak typeof (self) weakSelf=self;
        KYSDataProviderPageAction action=^(NSInteger currentPage,NSInteger totalPage,NSMutableArray<KYSSectionData *> * sectionsArray){
            NSLog(@"action: %ld",(long)currentPage);
            typeof (weakSelf) strongSelf=weakSelf;
            //NSLog(@"action: %@",sectionsArray);
            strongSelf.currentPage=currentPage;//更新当前页
            strongSelf.totalPage=totalPage;
            if (needClean) {
                [strongSelf.sectionsArray removeAllObjects];
            }
            [strongSelf.sectionsArray addObjectsFromArray:sectionsArray];
            if (strongSelf.delegate&&[strongSelf.delegate respondsToSelector:@selector(dataDidUpdate)]) {
                [strongSelf.delegate dataDidUpdate];
            }
            if (currentPage<totalPage) {
                //不是最后一页，还有数据
                [strongSelf p_endPullUpRefreshAnimation];
            }else{
                //没有更多数据
                [strongSelf p_didLoadLastPage];
            }
            //结束下拉动画
            [strongSelf p_endPullDownRefreshAnimation];
            strongSelf.currentPage=currentPage;
            strongSelf.isLoading=NO;
        };
        self.isLoading=YES;
        //如果不是第0页 +1
        self.loadPageDataBlock(self.currentPage+1,action);
    }
}

- (NSInteger)numberOfSections{
    return [self.sectionsArray count];
}

- (KYSSectionData *)sectionObjectAtSection:(NSInteger)section{
    if (self.sectionsArray.count>section) {
        return self.sectionsArray[section];
    }
    return nil;
}

- (KYSNumData *)objectAtIndexPath:(NSIndexPath *)indexPath{
    if (self.sectionsArray.count>indexPath.section) {
        KYSSectionData *sectionData=self.sectionsArray[indexPath.section];
        if (sectionData.numsArray.count>indexPath.row) {
            return sectionData.numsArray[indexPath.row];
        }
    }
    return nil;
}

//线程安全
- (BOOL)isLoading{
    __block BOOL loading=NO;
    dispatch_sync(self.syncQueue, ^{
        loading=_isLoading;
    });
    return loading;
}

- (void)setIsLoading:(BOOL)isLoading{
    dispatch_barrier_async(self.syncQueue, ^{
        _isLoading=isLoading;
    });
}


#pragma mark - lazy load
- (NSMutableArray<KYSSectionData *> *)sectionsArray{
    if (!_sectionsArray) {
        _sectionsArray=[[NSMutableArray<KYSSectionData *> alloc] init];
    }
    return _sectionsArray;
}

#pragma mark - private 上下、下拉刷新动画
//开始下拉刷新动画
- (void)p_needStartPullDownRefreshAnimation:(BOOL)flag{
    if (!flag) {
        return;
    }
    if (self.tableView&&[self.tableView respondsToSelector:@selector(kys_pullDownRefreshEnable)]) {
        BOOL enable=[self.tableView kys_pullDownRefreshEnable];
        if (enable) {
            [self.tableView kys_startPullDownRefreshing];
        }
    }
}

//结束下拉刷新动画
- (void)p_endPullDownRefreshAnimation{
    if (self.tableView&&[self.tableView respondsToSelector:@selector(kys_pullDownRefreshEnable)]) {
        BOOL enable=[self.tableView kys_pullDownRefreshEnable];
        if (enable) {
            [self.tableView kys_endPullDownRefreshing];
        }
    }
}

//开始上拉刷新动画
- (void)p_needStartPullUpRefreshAnimation:(BOOL)flag{
    if (!flag) {
        return;
    }
    
    if (self.tableView&&[self.tableView respondsToSelector:@selector(kys_pullUpRefreshEnable)]) {
        BOOL enable=[self.tableView kys_pullUpRefreshEnable];
        if (enable) {
            [self.tableView kys_startPullUpRefreshing];
        }
    }
}

//结束上拉刷新动画
- (void)p_endPullUpRefreshAnimation{
    if (self.tableView&&[self.tableView respondsToSelector:@selector(kys_pullUpRefreshEnable)]) {
        BOOL enable=[self.tableView kys_pullUpRefreshEnable];
        if (enable) {
            [self.tableView kys_endPullUpRefreshing];
        }
    }
}

//没有更多数据
- (void)p_didLoadLastPage{
    if (self.tableView&&[self.tableView respondsToSelector:@selector(kys_pullUpRefreshEnable)]) {
        BOOL enable=[self.tableView kys_pullUpRefreshEnable];
        if (enable) {
            [self.tableView kys_didLoadLastPage];
        }
    }
}


@end
