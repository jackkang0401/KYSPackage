//
//  KYSTableViewDataProvider.h
//  KYSTableView
//
//  Created by 康永帅 on 16/8/13.
//  Copyright © 2016年 Kang YongShuai. All rights reserved.
//

#import "UIKit/UIKit.h"

@class KYSSectionData;
@class KYSNumData;

@protocol KYSTableViewDataProviderDelegate <NSObject>

@required
//数据已更新
- (void)dataDidUpdate;

@end


//数据加载完成处理
typedef void(^KYSDataProviderAction)(NSMutableArray<KYSSectionData *> *);

//加载数据block
typedef void(^KYSDataProviderLoad)(KYSDataProviderAction);

//分页数据加载完成处理，加载失败，最后一个参数传入nil
typedef void(^KYSDataProviderPageAction)(NSInteger page,NSInteger totalPage,NSMutableArray<KYSSectionData *> *);

//加载分页数据数据block
typedef void(^KYSDataProviderLoadPageData)(NSInteger,KYSDataProviderPageAction);



@interface KYSTableViewDataProvider : NSObject

@property(nonatomic,copy)NSString *testStr;

@property(nonatomic,strong)NSMutableArray<KYSSectionData *> *sectionsArray;

@property(nonatomic,assign,readonly)BOOL isPageData;
@property(nonatomic,assign,readonly)NSInteger currentPage;
@property(nonatomic,assign,readonly)NSInteger totalPage;

- (instancetype)initWithTableView:(UITableView *)tableView
                         delegate:(id<KYSTableViewDataProviderDelegate>)delegate
                        loadBlock:(KYSDataProviderLoad) loadBlock;

- (instancetype)initWithTableView:(UITableView *)tableView
                         delegate:(id<KYSTableViewDataProviderDelegate>)delegate
               loadPageDataBlock:(KYSDataProviderLoadPageData) loadPageDataBlock;

#pragma mark - 加载数据
//开始加载数据(下拉)
- (void)loadData;

//下拉刷新
- (void)loadDataWithAnimation;


#pragma mark - 分页加载数据

//加载第第一页,会清空之前数据(下拉使用)
- (void)loadFirstPage;

//加载第一页数据，并传入第一页页码
- (void)loadFirstPageWithPage:(NSInteger)firstPageNum;

//加载第一页数据，传入第一页页码，是否启用下拉加载动画
- (void)loadFirstPageWithPage:(NSInteger)firstPageNum useAnimation:(BOOL)useAnimation;

//加载下一页(上拉加载)
- (void)loadNextPage;


#pragma mark - tableview data
- (NSInteger)numberOfSections;

//获取section数据
- (KYSSectionData *)sectionObjectAtSection:(NSInteger)section;

//获取对应indexPath的数据
- (KYSNumData *)objectAtIndexPath:(NSIndexPath *)indexPath;

@end
