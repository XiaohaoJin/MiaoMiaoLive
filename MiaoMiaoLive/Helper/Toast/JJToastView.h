//
//  JJToastView.h
//  MiaoMiaoLive
//
//  Created by 金晓浩 on 16/6/5.
//  Copyright © 2016年 XiaoHaoJin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JJToastView : UIView

@property (nonatomic, copy) NSString *toastType;
+ (void)showMessage:(NSString *)message;
+ (void)showMessage:(NSString *)message view:(UIView *)superView;

@end
