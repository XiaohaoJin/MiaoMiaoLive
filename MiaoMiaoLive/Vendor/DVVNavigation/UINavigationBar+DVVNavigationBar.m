//
//  UINavigationBar+DVVNavigationBar.m
//  MiaoMiaoRadio
//
//  Created by 大威 on 16/5/11.
//  Copyright © 2016年 iosdawei. All rights reserved.
//

#import "UINavigationBar+DVVNavigationBar.h"

@implementation UINavigationBar (DVVNavigationBar)

+ (void)load
{
    UINavigationBar *bar = [UINavigationBar appearance];
    
//    // 去掉透明效果
//    [bar setTranslucent:NO];
    
//    // 设置默认返回按钮的图片 (因为在 UIViewController+DVVMethodSwizzling 中已经添加了返回按钮，所以这里就不添加了)
//    [bar setBackIndicatorImage:[UIImage imageNamed:@"ic_navi_back"]];
//    [bar setBackIndicatorTransitionMaskImage:[UIImage imageNamed:@"ic_navi_back"]];
    
//    // 背景色
//    [bar setBarTintColor:NaviBgColor];
//    [bar setBackgroundColor:NaviBgColor];
    
//    // 背景图片
//    [bar setBackgroundImage:[UIImage imageNamed:@"img_navi_bgImage"] forBarMetrics:UIBarMetricsDefault];
    
    // 返回按钮颜色
    [bar setTintColor:[UIColor blackColor]];
    
    // 标题字体颜色
    [bar setTitleTextAttributes:@{ NSForegroundColorAttributeName:NaviFgColor,
                                   NSFontAttributeName:NaviTitleFont }];
    
    // Item字体颜色
    UIBarButtonItem *item = [UIBarButtonItem appearance];
    [item setTitleTextAttributes:@{ NSForegroundColorAttributeName:NaviFgColor,
                                    NSFontAttributeName:NaviItemFont } forState:UIControlStateNormal];
}

@end
