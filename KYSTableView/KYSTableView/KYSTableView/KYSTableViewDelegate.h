//
//  KYSTableViewDelegate.h
//  KYSTableView
//
//  Created by 康永帅 on 16/8/15.
//  Copyright © 2016年 Kang YongShuai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KYSProtocol.h"

@class KYSTableViewDataProvider;

//定义传入 NSIndexPath 的block
typedef void(^KYSTableViewDelegateIndexPathBlock)(NSIndexPath *indexPath, id object);

@interface KYSTableViewDelegate : NSObject

@property(nonatomic,copy) KYSTableViewDelegateIndexPathBlock didSelectRowBlock;

- (instancetype)initWithTableView:(UITableView *)tableView
                         delegate:(id<KYSTableViewProtocal>)delegate
                     dataProvider:(KYSTableViewDataProvider *)provider;

@end
