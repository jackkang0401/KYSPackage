//
//  KYSTableViewDelegate.m
//  KYSTableView
//
//  Created by 康永帅 on 16/8/15.
//  Copyright © 2016年 Kang YongShuai. All rights reserved.
//

#import "KYSTableViewDelegate.h"
#import "KYSTableViewDataProvider.h"
#import <UITableView_FDTemplateLayoutCell/UITableView+FDTemplateLayoutCell.h>
#import "KYSNumData.h"
#import "UITableView+KYSRefreah.h"

@interface KYSTableViewDelegate()<UITableViewDelegate>

@property(nonatomic,weak)id<KYSTableViewProtocal> delegate;
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)KYSTableViewDataProvider *dataProvider;

@end

@implementation KYSTableViewDelegate


- (instancetype)initWithTableView:(UITableView *)tableView
                         delegate:(id<KYSTableViewProtocal>)delegate
                     dataProvider:(KYSTableViewDataProvider *)provider{
    self=[super init];
    if (self) {
        self.tableView=tableView;
        self.delegate=delegate;
        self.dataProvider=provider;
        tableView.delegate=self;
    }
    return self;
}

- (void)dealloc{
    self.didSelectRowBlock=nil;
}


#pragma mark - UITableViewDelegate
//public implement
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([tableView kys_isRefreshing]) {
        NSLog(@"正在刷新,不进行选中回调");
        return;
    }
    if (self.didSelectRowBlock) {
        id object=[self.dataProvider objectAtIndexPath:indexPath];
        self.didSelectRowBlock(indexPath,object);
    }
}

//peivate imolement
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //NSLog(@"tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath");
    //获取cell的Identifier
    NSString *cellIndentifier=[self p_cellIdentifierWithTableView:tableView indexPath:indexPath];
    //NSLog(@"%@",cellIndentifier);
    if (!cellIndentifier.length){
        NSLog(@"请实现KYSDataSourceDelegate的tableView:cellIndentifierForRowAtIndexPath:方法,并返回有效的identifier");
        return 0;
    }
    
    KYSNumData *baseModal = [self.dataProvider objectAtIndexPath:indexPath];
    //未使用固定高度
    if (NO == baseModal.isRegularHeight) {
        baseModal.cellRegularHeight=[tableView fd_heightForCellWithIdentifier:cellIndentifier cacheByIndexPath:indexPath configuration:^(UITableViewCell<KYSTableViewCellProtocol> *cell) {
            [cell setCellDataWithObject:baseModal];
        }];
    }
    return baseModal.cellRegularHeight;
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
