//
//  JJHomePageCell.m
//  MiaoMiaoLive
//
//  Created by 金晓浩 on 16/5/29.
//  Copyright © 2016年 XiaoHaoJin. All rights reserved.
//

#import "JJHomePageCell.h"

@implementation JJHomePageCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self.contentView addSubview:self.nameLabel];
        [self.contentView addSubview:self.typeImg];
        [self.contentView addSubview:self.moneyLabel];
        [self.contentView addSubview:self.lineView];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    _typeImg.frame = CGRectMake(10, 0, 20, 30);
    _nameLabel.frame = CGRectMake(45, 0, 100, 30);
    _moneyLabel.frame = CGRectMake(ScreenWidth - 100, 0, 90, 30);
    _lineView.frame = CGRectMake(10, 0, ScreenWidth - 20, 1);
}


- (UILabel *)nameLabel
{
    if (!_nameLabel)
    {
        UILabel* label = [[UILabel alloc]init];
        label.textColor = [UIColor blackColor];
        label.font = [UIFont systemFontOfSize:14.0f];
        
        _nameLabel = label;
    }
    return _nameLabel;
}

- (UILabel *)moneyLabel
{
    if (!_moneyLabel)
    {
        UILabel* label = [[UILabel alloc]init];
        label.textColor = [UIColor blackColor];
        label.font = [UIFont systemFontOfSize:14.0f];
        label.textAlignment = NSTextAlignmentRight;
        _moneyLabel = label;
    }
    return _moneyLabel;
}

- (UIImageView *)typeImg
{
    if (!_typeImg)
    {
        UIImageView* imageView = [[UIImageView alloc]init];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        _typeImg = imageView;
    }
    return _typeImg;
}

- (UIView *)lineView
{
    if (!_lineView)
    {
        _lineView = [UIView new];
        _lineView.backgroundColor = [UIColor colorWithHexString:@"eeeeee"];
    }
    return _lineView;
}


- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
