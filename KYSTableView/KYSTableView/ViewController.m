//
//  ViewController.m
//  KYSTableView
//
//  Created by Liu Zhao on 16/8/12.
//  Copyright © 2016年 Kang YongShuai. All rights reserved.
//

#import "ViewController.h"
#import "KYSTableViewDataProvider.h"
#import "KYSTableViewDataSource.h"
#import "KYSTableViewDelegate.h"
#import "KYSSectionData.h"
#import "KYSDataModel.h"
#import "UITableView+KYSRefreah.h"


@interface ViewController ()<KYSTableViewDataProviderDelegate,KYSTableViewProtocal>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic,strong)KYSTableViewDataProvider *dataProvider;
@property (nonatomic,strong)KYSTableViewDataSource *dataSource;
@property (nonatomic,strong)KYSTableViewDelegate *delegate;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
//    //处理不带分页的下载
//    //__weak typeof (self) weakSelf=self;
//    _dataProvider=[[KYSTableViewDataProvider alloc] initWithTableView:self.tableView
//                                                             delegate:self
//                                                            loadBlock:^(KYSDataProviderAction action) {
//        NSLog(@"开始加载数据");
//        //加载数据
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            NSDictionary *results=@{@"object":@[@{@"name":@"《孙子兵法》又称《孙武兵法》、《吴孙子兵法》、《孙子兵书》《孙武兵书》等，是中国现存最早的兵书，也是世界上最早的军事著作，被誉为“兵学圣典”。处处表现了道家与兵家的哲学。共有六千字左右，一共十三篇。\n《孙子兵法》是中国古代军事文化遗产中的璀璨瑰宝，优秀传统文化的重要组成部分，其内容博大精深，思想精邃富赡，逻辑缜密严谨，是古代军事思想精华的集中体现。作者为春秋时祖籍齐国乐安的吴国将军孙武。",@"age":@"86"},
//                                                @{@"name":@"KYS",@"age":@"86"},
//                                                @{@"name":@"KYS",@"age":@"86"}]};
//
//            //解析过程感觉还是可以抽出来
//            NSMutableArray<KYSNumData *> *numsArray=[NSMutableArray new];
//            for (NSDictionary *dic in results[@"object"]) {
//                [numsArray  addObject:[KYSDataModel transformWithDictionary:dic]];
//            }
//        
//            KYSSectionData *section=[[KYSSectionData alloc] initWithNumsArray:numsArray];
//            action([@[section] mutableCopy]);
//            
//        });
//    }];
    
    //分页加载
    //__weak typeof (self) weakSelf=self;
    _dataProvider=[[KYSTableViewDataProvider alloc] initWithTableView:self.tableView
                                                             delegate:self
                                                            loadPageDataBlock:^(NSInteger currentPage,KYSDataProviderPageAction action) {
                                                                
            NSLog(@"开始加载数据");
            //加载数据
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                NSDictionary *results=@{@"object":@[@{@"name":@"《孙子兵法》又称《孙武兵法》、《吴孙子兵法》、《孙子兵书》《孙武兵书》等，是中国现存最早的兵书，也是世界上最早的军事著作，被誉为“兵学圣典”。处处表现了道家与兵家的哲学。共有六千字左右，一共十三篇。\n《孙子兵法》是中国古代军事文化遗产中的璀璨瑰宝，优秀传统文化的重要组成部分，其内容博大精深，思想精邃富赡，逻辑缜密严谨，是古代军事思想精华的集中体现。作者为春秋时祖籍齐国乐安的吴国将军孙武。",@"age":@"86"},
                                                    @{@"name":@"KYS",@"age":@"86"},
                                                    @{@"name":@"KYS",@"age":@"86"}]};
                                                                    
                //解析过程感觉还是可以抽出来
                NSMutableArray<KYSNumData *> *numsArray=[NSMutableArray new];
                for (NSDictionary *dic in results[@"object"]) {
                    [numsArray  addObject:[KYSDataModel transformWithDictionary:dic]];
                }
                                                                    
                KYSSectionData *section=[[KYSSectionData alloc] initWithNumsArray:numsArray];
                action(currentPage,3,[@[section] mutableCopy]);
            });
        }];
    
    _dataSource=[[KYSTableViewDataSource alloc] initWithTableView:self.tableView delegate:self dataProvider:_dataProvider];
    
    _delegate=[[KYSTableViewDelegate alloc] initWithTableView:self.tableView delegate:self dataProvider:_dataProvider];
    
    
    __weak typeof (self) weakSelf=self;
    [_tableView  kys_pullDownRefreshEnable:YES refreshingBlock:^{
        NSLog(@"下拉刷新");
        typeof(weakSelf) strongSelf=weakSelf;
        [strongSelf.dataProvider loadFirstPage];
    }];
    [_tableView kys_pullUpRefreshEnable:YES refreshingBlock:^{
        NSLog(@"上拉刷新");
        typeof(weakSelf) strongSelf=weakSelf;
        [strongSelf.dataProvider loadNextPage];
    }];
    
    [_dataProvider loadFirstPageWithPage:0];
}

#pragma mark - KYSTableViewDataProviderDelegate
- (void)dataDidUpdate{
    NSLog(@"dateDidUpdate 数据更新");
    [self.tableView reloadData];
}

#pragma mark - KYSTableViewDataSourceDelegate
- (NSString *)tableView:(UITableView *)tableView cellIndentifierForRowAtIndexPath:(NSIndexPath *)indexPath{
    return @"KYSTableViewCell";
}

- (NSString *)tableView:(UITableView *)tableView cellNameForRowAtIndexPath:(NSIndexPath *)indexPath{
    return @"KYSTableViewCell";
}










@end
