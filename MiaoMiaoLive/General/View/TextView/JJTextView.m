//
//  JJTextView.m
//  BaseTextView
//
//  Created by 金晓浩 on 16/6/17.
//  Copyright © 2016年 XiaoHaoJin. All rights reserved.
//

#import "JJTextView.h"

@implementation JJTextView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.delegate = self;
        [self addSubview:self.placeHolderLabel];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textViewTextDidChanged) name:UITextViewTextDidChangeNotification object:nil];
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:UITextViewTextDidChangeNotification];
}

- (void)layoutSubviews
{
    CGFloat placeHolderLabelY = 5;
    CGFloat placeHolderLabelX = 5;
    
    CGFloat placeHolderLabelWidth = self.frame.size.width - 2*placeHolderLabelX;
    //根据文字计算高度
    
    CGSize maxSize =CGSizeMake(placeHolderLabelWidth,MAXFLOAT);
    CGFloat placeHolderLabelHeight = [self.placeHolder
                                               boundingRectWithSize:maxSize
                                               options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin
                                               attributes:@{NSFontAttributeName : self.placeHolderLabel.font}
                                               context:nil].size.height;

    _placeHolderLabel.frame = CGRectMake(placeHolderLabelX, placeHolderLabelY, placeHolderLabelWidth, placeHolderLabelHeight);
    
}

- (void)textViewTextDidChanged
{
    self.placeHolderLabel.hidden = self.hasText;
}

- (void)setText:(NSString *)text
{
    [super setText:text];
    [self textViewTextDidChanged];
}

- (void)setAttributedText:(NSAttributedString *)attributedText
{
    [super setAttributedText:attributedText];
    [self textViewTextDidChanged];
}

- (void)setPlaceHolderColor:(UIColor *)placeHolderColor
{
    _placeHolderColor = placeHolderColor;
    self.placeHolderLabel.textColor = placeHolderColor;
}

- (void)setFont:(UIFont *)font
{
    [super setFont:font];
    self.placeHolderLabel.font = font;
    [self setNeedsLayout];
}

- (void)setPlaceHolder:(NSString *)placeHolder
{
    _placeHolder = placeHolder;
    self.placeHolderLabel.text = placeHolder;
    [self setNeedsLayout]; // 重新计算frame
}

// 移除键盘
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString*)text
{
    if ([text isEqualToString:@"\n"])
    {
        [self resignFirstResponder];
        return NO;
    }
    return YES;
}

- (UILabel *)placeHolderLabel
{
    if (!_placeHolderLabel)
    {
        _placeHolderLabel = [UILabel new];
        _placeHolderLabel.text = _placeHolder;
        _placeHolderLabel.textColor = [UIColor lightGrayColor];
        _placeHolderLabel.font = [UIFont systemFontOfSize:14];
        [_placeHolderLabel sizeToFit];
    }
    return _placeHolderLabel;
}

@end
