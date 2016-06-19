//
//  UINavigationBar+JJNavigationBar.m
//  MiaoMiaoLive
//
//  Created by 金晓浩 on 16/6/19.
//  Copyright © 2016年 XiaoHaoJin. All rights reserved.
//

#import "UINavigationBar+JJNavigationBar.h"

@implementation UINavigationBar (JJNavigationBar)

+ (void)load {
    
    UINavigationBar *bar = [UINavigationBar appearance];
    
    //      [bar setShadowImage:[UIImage imageWithColor:[UIColor blackColor] size:CGSizeMake(ScreenWidth, 2)]];
    //    bar.shadowImage = [[UIImage alloc] init];
    
    // 返回按钮的图片
    [bar setBackIndicatorImage:[UIImage imageNamed:@"ic_back"]];
    [bar setBackIndicatorTransitionMaskImage:[UIImage imageNamed:@"ic_back"]];
    
    // 背景色
    [bar setBarTintColor:RGB(81, 194, 211)];
    // 返回按钮颜色
    [bar setTintColor:[UIColor whiteColor]];
    
    // 标题字体颜色
    [bar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:[UIFont italicSystemFontOfSize:17]}];
    
    UIBarButtonItem *item = [UIBarButtonItem appearance];
    [item setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:[UIFont boldSystemFontOfSize:16]} forState:UIControlStateNormal];
    //    UIView*label = [[UIView alloc] initWithFrame:CGRectMake(0, 44, ScreenWidth, 0.5)];
    
    //    [bar setBarTintColor:[UIColor blackColor]];
    [bar setTintColor:[UIColor blackColor]];
    //    [bar setBackgroundImage:[UIImage imageWithView:label]];
    
}

@end
