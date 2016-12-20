//
//  KYSTableViewDataSource.m
//  KYSTableView
//
//  Created by 康永帅 on 16/8/13.
//  Copyright © 2016年 Kang YongShuai. All rights reserved.
//

#import "KYSTableViewDataSource.h"

#import "KYSTableViewDataProvider.h"
#import "KYSSectionData.h"
#import "KYSNumData.h"
#import "KYSProtocol.h"

@interface KYSTableViewDataSource()<UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,weak)id<KYSTableViewProtocal> delegate;
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)KYSTableViewDataProvider *dataProvider;

@end

@implementation KYSTableViewDataSource

- (instancetype)initWithTableView:(UITableView *)tableView
                         delegate:(id<KYSTableViewProtocal>)delegate
                     dataProvider:(KYSTableViewDataProvider *)provider{
    self=[super init];
    if (self) {
        self.tableView=tableView;
        self.delegate=delegate;
        self.dataProvider=provider;
        tableView.dataSource=self;
    }
    return self;
}



#pragma mark - UITableViewDataSource
//required
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    KYSSectionData *sectionData =[self.dataProvider sectionObjectAtSection:section];
    if (sectionData) {
        NSLog(@"numberOfRowsInSection: %ld",sectionData.numsArray.count);
        return sectionData.numsArray.count;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //获取cell的Identifier
    NSString *cellIndentifier=[self p_cellIdentifierWithTableView:tableView indexPath:indexPath];
    //NSLog(@"%@",cellIndentifier);
    if (!cellIndentifier.length){
        NSLog(@"请实现KYSDataSourceDelegate的tableView:cellIndentifierForRowAtIndexPath:方法,并返回有效的identifier");
        return nil;
    }
    
    UITableViewCell<KYSTableViewCellProtocol>* cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifier];
    if (!cell) {
        //获取Cell类名
        NSString *cellName=[self p_cellNameWithTableView:tableView indexPath:indexPath];
        if (!cellName.length){
            NSLog(@"请实现KYSDataSourceDelegate的tableView:cellNameForRowAtIndexPath:方法,并返回有效的name");
            return nil;
        }
        //初始化cell
        Class cellClass=NSClassFromString(cellName);
        if (!cellClass) {
            NSLog(@"请检查代理传入的类名是否正确");
            return nil;
        }
        cell = [[cellClass alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifier];
    }
    //设置cell页面数据
    KYSNumData *numData=[self.dataProvider objectAtIndexPath:indexPath];
    [cell setCellDataWithObject:numData];
    return cell;
}

//optional
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    //NSLog(@"numberOfSectionsInTableView: %ld",[self.dataProvider numberOfSections]);
    return [self.dataProvider numberOfSections];
}

#pragma mark - private
// p_ 表示私有方法
- (NSString *)p_cellIdentifierWithTableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath{
    if (self.delegate&&[self.delegate respondsToSelector:@selector(tableView:cellIndentifierForRowAtIndexPath:)]) {
        return [self.delegate tableView:tableView cellIndentifierForRowAtIndexPath:indexPath];
    }
    return nil;
}

- (NSString *)p_cellNameWithTableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath{
    if (self.delegate&&[self.delegate respondsToSelector:@selector(tableView:cellNameForRowAtIndexPath:)]) {
        return [self.delegate tableView:tableView cellNameForRowAtIndexPath:indexPath];
    }
    return nil;
}

@end
