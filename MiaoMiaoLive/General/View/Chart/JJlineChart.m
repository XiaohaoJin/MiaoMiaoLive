//
//  JJlineChart.m
//  JJChart
//
//  Created by 金晓浩 on 16/6/11.
//  Copyright © 2016年 XiaoHaoJin. All rights reserved.
//

#import "JJlineChart.h"

@interface JJlineChart () <UIScrollViewDelegate>

@property (nonatomic, strong) UIView *yTitleView;
@property (nonatomic, strong) UIScrollView *xTitleView;
@property (nonatomic, strong) UIScrollView *containerView;
@property (nonatomic, assign) CGFloat maxValue;
@property (nonatomic, assign) CGFloat minValue;
@property (nonatomic, assign) CGFloat rowValue;
@property (nonatomic, assign) CGFloat rowHeight;

@end

@implementation JJlineChart

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.userInteractionEnabled = YES;
        
        _xTitleHeight = 30;
        _yTitleWidth = 30;
        _xLabelWidth = 30;
        _rowNum = 5;
        
        [self addSubview:self.xTitleView];
        [self addSubview:self.yTitleView];
        [self addSubview:self.containerView];
        
        [self configFrame];
     
    }
    return self;
}

- (void)configFrame
{
    CGSize size = self.bounds.size;
    self.yTitleView.frame = CGRectMake(0,
                                       0,
                                       _yTitleWidth,
                                       size.height - _xTitleHeight);
    self.containerView.frame = CGRectMake(_yTitleWidth,
                                          0,
                                          size.width - _yTitleWidth,
                                          size.height - _xTitleHeight);
    self.xTitleView.frame = CGRectMake(_yTitleWidth,
                                       size.height - _xTitleHeight,
                                       size.width - _yTitleWidth,
                                       _xTitleHeight);
}

- (void)setYTitleWidth:(CGFloat)yTitleWidth
{
    _yTitleWidth = yTitleWidth;
    [self configFrame];
}

- (void)refreshData
{
    for (UIView *itemView in self.xTitleView.subviews)
    {
        [itemView removeFromSuperview];
    }
    
    for (UIView *itemView in self.yTitleView.subviews)
    {
        [itemView removeFromSuperview];
    }
    
    for (UIView *itemView in self.containerView.subviews)
    {
        [itemView removeFromSuperview];
    }

    
    _xTitleView.contentSize = CGSizeMake(_xLabelWidth * _xTitleArray.count, 0);
    _containerView.contentSize = CGSizeMake(_xLabelWidth * _xTitleArray.count, 0);
    // 设置X轴 title
    [_xTitleArray enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UILabel *titleLabel = [UILabel new];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.frame = CGRectMake(idx * _xLabelWidth, 0, _xLabelWidth, _xTitleHeight);
        titleLabel.text = obj;
        titleLabel.font = [UIFont systemFontOfSize:12];
        DLog(@"obj == %@",obj);
        [_xTitleView addSubview:titleLabel];
    }];
    
    // 取出当前数据的最大值、最小值
    [self findMaxAndMin];
    
    // 设置y轴title
    _rowValue = (_maxValue - _minValue) / _rowNum;
    _rowHeight = self.containerView.bounds.size.height / _rowNum;
    for (int i = 0; i < _rowNum; i++)
    {
        UILabel *yTitleLabel = [UILabel new];
        yTitleLabel.textAlignment = NSTextAlignmentCenter;
        yTitleLabel.frame = CGRectMake(0,
                                       i * _rowHeight,
                                       _yTitleWidth,
                                       _rowHeight);
        yTitleLabel.text = [NSString stringWithFormat:@"%.0lf", _maxValue - (i * _rowValue)];
        yTitleLabel.font = [UIFont systemFontOfSize:12];
        [_yTitleView addSubview:yTitleLabel];
    }
    
    // 绘制线
    [self strokeChart];
}

#pragma mark - Chart

- (void)findMaxAndMin
{
    _maxValue = 0;
    _minValue = 99999999;
    for (NSArray *array in _valueArray)
    {
        for (NSString *str in array)
        {
            CGFloat value = [str floatValue];
            if (_maxValue < value)
            {
                _maxValue = value;
            }
            if (_minValue > value)
            {
                _minValue = value;
            }
        }
    }
}

- (void)strokeChart
{
    CGFloat containerViewHeight = self.containerView.bounds.size.height;
    
    for (int i = 0; i < _valueArray.count; i++)
    {
        NSArray *childArray = _valueArray[i];
        // ShapeLayer
        CAShapeLayer *_chartLine = [CAShapeLayer layer];
        _chartLine.lineCap = kCALineCapRound;
        _chartLine.lineJoin = kCALineJoinBevel;
        _chartLine.fillColor = [[UIColor clearColor] CGColor];
        _chartLine.lineWidth = 1.0;
        _chartLine.strokeEnd = 0.0;
        [self.containerView.layer addSublayer:_chartLine];
        
        UIBezierPath *progressLine = [UIBezierPath bezierPath];
        [progressLine setLineWidth:2.0];
        [progressLine setLineCapStyle:kCGLineCapRound];
        [progressLine setLineJoinStyle:kCGLineJoinRound];
        
        CGFloat xPosition = _xLabelWidth / 2.0;
        
        for (int j = 0; j < childArray.count; j++)
        {
            CGFloat value = [childArray[j] floatValue];
            CGFloat ratio = 1;
            if (_maxValue != 0)
            {
                ratio = 1 - value/_maxValue;
            }
            CGPoint point = CGPointMake(xPosition + j*_xLabelWidth,
                                        ((containerViewHeight - _rowHeight) * ratio) + _rowHeight/2.0);
            
            UIView * pointView = [UIView new];
            pointView.frame = CGRectMake(0, 0, 6, 6);
            pointView.center = point;
            if ([_colorArray[i] CGColor])
            {
                pointView.backgroundColor = _colorArray[i];
            }
            else
            {
                pointView.backgroundColor = [UIColor blackColor];
            }
            pointView.layer.cornerRadius = 3;
            [self.containerView addSubview:pointView];
            
            if (0 == j)
            {
                [progressLine moveToPoint:point];
            }
            else
            {
                [progressLine addLineToPoint:point];
            }
        }
        
        _chartLine.path = progressLine.CGPath;
        if ([_colorArray[i] CGColor])
        {
            _chartLine.strokeColor = [_colorArray[i] CGColor];
        }
        else
        {
            _chartLine.strokeColor = [[UIColor greenColor] CGColor];
        }
        
        CABasicAnimation *pathAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
        pathAnimation.duration = childArray.count*0.25;
        pathAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        pathAnimation.fromValue = [NSNumber numberWithFloat:0.0f];
        pathAnimation.toValue = [NSNumber numberWithFloat:1.0f];
        pathAnimation.autoreverses = NO;
        [_chartLine addAnimation:pathAnimation forKey:@"strokeEndAnimation"];
        _chartLine.strokeEnd = 1.0;
    }
}

#pragma mark - Delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat offsetX = scrollView.contentOffset.x;
    if (0 == scrollView.tag)
    {
        CGPoint containerViewPoint = _containerView.contentOffset;
        containerViewPoint.x = offsetX;
        _containerView.contentOffset = containerViewPoint;
    }
    else
    {
        CGPoint xTitleViewPoint = _xTitleView.contentOffset;
        xTitleViewPoint.x = offsetX;
        _xTitleView.contentOffset = xTitleViewPoint;
    }
}

#pragma mark - Lazy load

- (UIView *)yTitleView
{
    if (!_yTitleView)
    {
        _yTitleView = [UIView new];
    }
    return _yTitleView;
}

- (UIScrollView *)xTitleView
{
    if (!_xTitleView)
    {
        _xTitleView = [UIScrollView new];
        _xTitleView.delegate = self;
        _xTitleView.tag = 0;
    }
    return _xTitleView;
}

- (UIScrollView *)containerView
{
    if (!_containerView)
    {
        _containerView = [UIScrollView new];
        _containerView.delegate = self;
        _containerView.tag = 1;
        _containerView.layer.borderWidth = 1;
        _containerView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    }
    return _containerView;
}

@end
