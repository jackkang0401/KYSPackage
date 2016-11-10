//
//  KYSTableViewCell.m
//  KYSTableView
//
//  Created by 康永帅 on 16/8/13.
//  Copyright © 2016年 Kang YongShuai. All rights reserved.
//

#import "KYSTableViewCell.h"
#import "KYSDataModel.h"

@interface KYSTableViewCell()

@property (weak, nonatomic) IBOutlet UILabel *kys_titleLabel;

@end

@implementation KYSTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.textstr=@"";
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - KYSTableViewCellProtocol
- (void)setCellDataWithObject:(KYSDataModel *)data{
    _kys_titleLabel.text=data.name;
    NSLog(@"%f",_kys_titleLabel.frame.size.height);
}


@end
