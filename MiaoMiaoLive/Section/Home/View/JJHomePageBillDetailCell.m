//
//  JJHomePageBillDetailCell.m
//  MiaoMiaoLive
//
//  Created by 金晓浩 on 16/6/3.
//  Copyright © 2016年 XiaoHaoJin. All rights reserved.
//

#import "JJHomePageBillDetailCell.h"

@interface JJHomePageBillDetailCell () <UITextFieldDelegate>

@end

@implementation JJHomePageBillDetailCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        [self.contentView addSubview:self.titleLabel];
        [self.contentView addSubview:self.detailText];
    }
    return self;
}


- (void)layoutSubviews
{
    self.titleLabel.frame = CGRectMake(10, 10, 100, 30);
    self.detailText.frame = CGRectMake(ScreenWidth-310, 10, 300, 30);
}

- (UILabel *)titleLabel
{
    if (!_titleLabel)
    {
        UILabel* label = [[UILabel alloc]init];
        label.textColor = [UIColor blackColor];
        label.font = [UIFont systemFontOfSize:14.0f];
        _titleLabel = label;
    }
    return _titleLabel;
}

- (UITextField *)detailText
{
    if (!_detailText)
    {
        _detailText = [UITextField new];
        _detailText.textAlignment = NSTextAlignmentRight;
        _detailText.enabled = NO;
        
    }
    return _detailText;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
