//
//  JJHomeClassifyCollectionCell.m
//  MiaoMiaoLiveShow
//
//  Created by 金晓浩 on 16/5/28.
//  Copyright © 2016年 XiaoHaoJin. All rights reserved.
//

#import "JJHomeClassifyCollectionCell.h"

@implementation JJHomeClassifyCollectionCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self.contentView addSubview:self.imageView];
        [self.contentView addSubview:self.titleLabel];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    _imageView.frame = CGRectMake(0, 0, self.frame.size.width , self.frame.size.height-30);
    _titleLabel.frame = CGRectMake(0, self.frame.size.height - 20, self.frame.size.width, 20);
}

- (UIImageView *)imageView
{
    if (!_imageView)
    {
        UIImageView *imageView = [[UIImageView alloc]init];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.backgroundColor = [UIColor greenColor];
        
        _imageView = imageView;
    }
    return _imageView;
}

- (UILabel *)titleLabel
{
    if (!_titleLabel)
    {
        UILabel* label = [[UILabel alloc]init];
        label.textColor = [UIColor blackColor];
        label.font = [UIFont systemFontOfSize:14.0f];
        label.textAlignment = NSTextAlignmentCenter;
        
        label.text = @"dddd";
        
        _titleLabel = label;
    }
    return _titleLabel;
}



@end
