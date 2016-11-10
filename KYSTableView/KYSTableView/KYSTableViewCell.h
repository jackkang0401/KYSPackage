//
//  KYSTableViewCell.h
//  KYSTableView
//
//  Created by 康永帅 on 16/8/13.
//  Copyright © 2016年 Kang YongShuai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KYSProtocol.h"

@interface KYSTableViewCell : UITableViewCell<KYSTableViewCellProtocol>

@property(nonatomic,strong)NSString *textstr;

@end
