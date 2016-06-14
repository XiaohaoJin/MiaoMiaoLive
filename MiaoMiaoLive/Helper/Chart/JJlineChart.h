//
//  JJlineChart.h
//  JJChart
//
//  Created by 金晓浩 on 16/6/11.
//  Copyright © 2016年 XiaoHaoJin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JJlineChart : UIView

@property (nonatomic, assign) CGFloat yTitleWidth;
@property (nonatomic, assign) CGFloat xTitleHeight;
// X轴Label的宽度
@property (nonatomic, assign) CGFloat xLabelWidth;
// 行数
@property (nonatomic, assign) NSUInteger rowNum;
// 横轴标题
@property (nonatomic, copy) NSArray<NSString *> *xTitleArray;
// 数值数组（多重）
@property (nonatomic, copy) NSArray<NSArray *> *valueArray;
// 颜色数组
@property (nonatomic, copy) NSArray<UIColor *> *colorArray;
// 默认的高度
@property (nonatomic, readonly, assign) CGFloat defaultHeight;


// 动画的方式加载线性图
- (void)refreshData;

@end
