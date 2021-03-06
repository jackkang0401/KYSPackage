//
//  KYSTableViewDataSource.h
//  KYSTableView
//
//  Created by 康永帅 on 16/8/13.
//  Copyright © 2016年 Kang YongShuai. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "KYSProtocol.h"

@class KYSTableViewDataProvider;

@interface KYSTableViewDataSource : NSObject



- (instancetype)initWithTableView:(UITableView *)tableView
                         delegate:(id<KYSTableViewProtocal>)delegate
                     dataProvider:(KYSTableViewDataProvider *)provider;

@end
