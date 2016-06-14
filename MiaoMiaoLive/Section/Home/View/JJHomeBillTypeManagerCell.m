//
//  JJHomeBillTypeManagerCell.m
//  MiaoMiaoLive
//
//  Created by 金晓浩 on 16/5/29.
//  Copyright © 2016年 XiaoHaoJin. All rights reserved.
//

#import "JJHomeBillTypeManagerCell.h"

@interface JJHomeBillTypeManagerCell () <UIGestureRecognizerDelegate>

@end

@implementation JJHomeBillTypeManagerCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self.contentView addSubview:self.iconImg];
        [self.contentView addSubview:self.titleLabel];
        [self.contentView addSubview:self.deleButton];
        
        UILongPressGestureRecognizer * longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressedAction:)];
            longPress.delegate = self;
        [self addGestureRecognizer:longPress];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    CGSize size = self.frame.size;
    _iconImg.frame = CGRectMake(5, 5, size.width-10, size.height - 30);
    _titleLabel.frame = CGRectMake(0, size.height-20, size.width, 20);
    _deleButton.frame = CGRectMake(0, 0, 20, 20);
   
}

- (void)deleteDataCell
{
    
    if (_deleteBlock)
    {
        _deleteBlock(self);
    }
}

// 取消晃动
-(void)cancelWobble
{
    self.wobble = NO;
    // 晃动动画
    [self animationView];
}

// 长按
-(void)longPressedAction:(UILongPressGestureRecognizer *)sender
{
    if (sender.state == UIGestureRecognizerStateBegan)
    {
        if (_wobbleBlock)
        {
            _wobbleBlock(self.wobble);
        }
       
    }
}

- (void)beginWobble
{
    self.wobble = YES;
    [self animationView];
}


// 晃动动画
-(void)animationView
{
    //摇摆
    if (self.wobble)
    {
        self.transform = CGAffineTransformMakeRotation(-0.1);
        
        [UIView animateWithDuration:0.08
                              delay:0.0
                            options:UIViewAnimationOptionRepeat|UIViewAnimationOptionAutoreverse|UIViewAnimationOptionAllowUserInteraction|UIViewAnimationOptionCurveLinear
                         animations:^{
                             self.transform = CGAffineTransformMakeRotation(0.1);
                             
                             self.deleButton.hidden = NO;
                             
                         }
                         completion:nil];
    }
    else
    {
        
        [UIView animateWithDuration:0.25
                              delay:0.0
                            options:UIViewAnimationOptionAllowUserInteraction|UIViewAnimationOptionBeginFromCurrentState|UIViewAnimationOptionCurveEaseOut
                         animations:^{
                             self.transform = CGAffineTransformIdentity;
                             self.deleButton.hidden = YES;
                             
                         }
                         completion:nil];
    }
}


- (void)currentSelectedDataAction
{
    if (_showSelectedBlock)
    {
        _showSelectedBlock(self);
    }
}


- (UIImageView *)iconImg
{
    if (!_iconImg)
    {
        UIImageView *imageView = [[UIImageView alloc]init];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        imageView.userInteractionEnabled = YES;
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(currentSelectedDataAction)];
        [imageView addGestureRecognizer:tap];
        
        _iconImg = imageView;
    }
    return _iconImg;
}

- (UILabel *)titleLabel
{
    if (!_titleLabel)
    {
        UILabel* label = [[UILabel alloc]init];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = [UIColor blackColor];
        label.font = [UIFont systemFontOfSize:14.0f];
        label.textAlignment = NSTextAlignmentCenter;
        
        _titleLabel = label;
    }
    return _titleLabel;
}

- (UIButton *)deleButton
{
    if (!_deleButton)
    {
        UIButton *button = [[UIButton alloc]init];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        button.hidden = YES;
        [button addTarget:self action:@selector(deleteDataCell) forControlEvents:UIControlEventTouchUpInside];
        [button setImage:[UIImage imageNamed:@"ic_close_icon"] forState:UIControlStateNormal];
        _deleButton = button;
    }
    return _deleButton;
}



@end
