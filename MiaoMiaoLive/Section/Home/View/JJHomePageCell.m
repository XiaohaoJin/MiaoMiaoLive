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
        [self.contentView addSubview:self.nameLabel];
        [self.contentView addSubview:self.typeImg];
        [self.contentView addSubview:self.moneyLabel];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    _typeImg.frame = CGRectMake(10, 0, 20, 30);
    _nameLabel.frame = CGRectMake(45, 0, 100, 30);
    _moneyLabel.frame = CGRectMake(ScreenWidth - 100, 0, 90, 30);
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



- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
