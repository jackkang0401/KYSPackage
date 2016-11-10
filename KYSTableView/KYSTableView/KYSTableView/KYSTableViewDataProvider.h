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
//分页数据加载完成处理
typedef void(^KYSDataProviderPageAction)(NSInteger currentPage,NSInteger totalPage,NSMutableArray<KYSSectionData *> *);
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

//开始加载数据(下拉)
- (void)loadData;

//下拉刷新
- (void)loadDataWithAnimation;

//处理分页
//加载第第一页,会清空之前数据(下拉使用)
- (void)loadFirstPage;

- (void)loadFirstPageWithAnimation;

//加载下一页(上拉使用)
- (void)loadNextPage;


- (NSInteger)numberOfSections;

//获取section数据
- (KYSSectionData *)sectionObjectAtSection:(NSInteger)section;

//获取对应indexPath的数据
- (KYSNumData *)objectAtIndexPath:(NSIndexPath *)indexPath;

@end
