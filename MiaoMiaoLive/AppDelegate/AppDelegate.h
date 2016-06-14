//
//  AppDelegate.h
//  MiaoMiaoLive
//
//  Created by 金晓浩 on 16/5/28.
//  Copyright © 2016年 XiaoHaoJin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DVVTabBarController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, strong) DVVTabBarController *mainTabBarVC;

@property (nonatomic, copy) NSString * isFirstRunning;

@end

