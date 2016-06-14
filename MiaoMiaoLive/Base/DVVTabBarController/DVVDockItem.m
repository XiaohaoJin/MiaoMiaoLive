//
//  DVVDockItem.m
//  DVVTabBarController
//
//  Created by 大威 on 15/12/4.
//  Copyright © 2015年 DaWei. All rights reserved.
//

#import "DVVDockItem.h"

// 文字的高度比例
static CGFloat kTitleRatio = 0.f;
static CGFloat kImageViewMargin = 8;

@implementation DVVDockItem

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initialProperty];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initialProperty];
    }
    return self;
}

- (void)initialProperty {
    
    // 文字居中
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    
    // 文字大小
    self.titleLabel.font = [UIFont systemFontOfSize:10];
    
    // 图片的内容模式
    self.imageView.contentMode = UIViewContentModeScaleToFill;
}

#pragma mark 覆盖父类在highlighted时的所有操作
- (void)setHighlighted:(BOOL)highlighted {
    //    [super setHighlighted:highlighted];
}

#pragma mark 调整内部ImageView的frame
- (CGRect)imageRectForContentRect:(CGRect)contentRect {
    CGFloat imageX = 0;
    CGFloat imageY = kImageViewMargin;
    CGFloat imageWidth = contentRect.size.width;
    CGFloat imageHeight = contentRect.size.height * ( 1 - kTitleRatio ) - kImageViewMargin*2;
    return CGRectMake(imageX, imageY, imageWidth, imageHeight);
}

#pragma mark 调整内部UILabel的frame
- (CGRect)titleRectForContentRect:(CGRect)contentRect {
    CGFloat titleX = 0;
    CGFloat titleHeight = contentRect.size.height * kTitleRatio;
    CGFloat titleY = contentRect.size.height - titleHeight - 3;
    CGFloat titleWidth = contentRect.size.width;
    return CGRectMake(titleX, titleY, titleWidth, titleHeight);
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
