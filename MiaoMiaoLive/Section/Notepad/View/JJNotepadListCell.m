//
//  JJNotepadListCell.m
//  MiaoMiaoLive
//
//  Created by 金晓浩 on 16/6/16.
//  Copyright © 2016年 XiaoHaoJin. All rights reserved.
//

#import "JJNotepadListCell.h"

@implementation JJNotepadListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        CellAddSubview(self.signImage);
        CellAddSubview(self.titleLabel);
        CellAddSubview(self.dateLabel);
        CellAddSubview(self.contentLabel);
        [self layout];
    }
    return self;
}

- (void)layout
{
    UIView *contentView = self.contentView;
    
    self.contentView.sd_layout
    .topSpaceToView(self, 0)
    .leftSpaceToView(self, 0)
    .bottomSpaceToView(self, 0)
    .rightSpaceToView(self, 0);
    
    _signImage.sd_layout
    .leftSpaceToView(contentView, 10)
    .topSpaceToView(contentView, 10)
    .widthIs(40)
    .heightIs(40);
    _signImage.layer.cornerRadius = 20;
    
    _titleLabel.sd_layout
    .topEqualToView(_signImage)
    .leftSpaceToView(_signImage,10)
    .rightSpaceToView(contentView,10)
    .heightIs(20);
    
    _dateLabel.sd_layout
    .topSpaceToView(_titleLabel, 5)
    .leftEqualToView(_titleLabel)
    .rightEqualToView(_titleLabel)
    .heightIs(15);
    
    _contentLabel.sd_layout
    .topSpaceToView(_signImage,15)
    .leftEqualToView(_signImage)
    .rightEqualToView(_titleLabel);
    
    
    [self setupAutoHeightWithBottomView:_contentLabel bottomMargin:10];
}

- (void)setDataModel:(JJEditContentModel *)dataModel
{
    _dataModel = dataModel;
    
    CGFloat red = arc4random()&255/255;
    CGFloat green = arc4random()&255/255;
    CGFloat blue = arc4random()&255/255;
    
    _signImage.backgroundColor = [UIColor colorWithRed:red green:green blue:blue alpha:1];
    _titleLabel.text = dataModel.title;
    _dateLabel.text = dataModel.dateTime;
    _contentLabel.text = dataModel.content;
}

- (UIImageView *)signImage
{
    if (!_signImage)
    {
        _signImage = [[UIImageView alloc] init];
        _signImage.layer.borderWidth = 1;
        _signImage.layer.borderColor = ViewBgColor.CGColor;
    }
    return _signImage;
}

- (UILabel *)titleLabel
{
    if (!_titleLabel)
    {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:15 weight:5];
        [_titleLabel setTextColor:[UIColor grayColor]];
    }
    return _titleLabel;
}

- (UILabel *)dateLabel
{
    if (!_dateLabel)
    {
        _dateLabel = [[UILabel alloc] init];
        _dateLabel.font = [UIFont systemFontOfSize:10];
        _dateLabel.textColor = [UIColor grayColor];
    }
    return _dateLabel;
}

- (UILabel *)contentLabel
{
    if (!_contentLabel)
    {
        _contentLabel = [[UILabel alloc] init];
        _contentLabel.backgroundColor = [UIColor colorWithHexString:@"eeeeee"];
        [_contentLabel setTextColor:[UIColor blackColor]];
        _contentLabel.font = [UIFont systemFontOfSize:12];
        _contentLabel.numberOfLines = 0;
    }
    return _contentLabel;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
