//
//  AppDelegate.m
//  MiaoMiaoLive
//
//  Created by 金晓浩 on 16/5/28.
//  Copyright © 2016年 XiaoHaoJin. All rights reserved.
//

#import "AppDelegate.h"
#import "JJHomePageController.h"
#import "JJGameController.h"
#import "JJNotepadController.h"

@interface AppDelegate ()

@property (nonatomic, strong) JJHomePageController *homeVC;
@property (nonatomic, strong) JJGameController *gameVC;
@property (nonatomic, strong) JJNotepadController *notepadVC;

@property (nonatomic, strong) UINavigationController *homeNaviVC;
@property (nonatomic, strong) UINavigationController *gameNaviVC;
@property (nonatomic, strong) UINavigationController *notepadNaviVC;


@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    /** 科大讯飞 */
    NSString *initString = [[NSString alloc] initWithFormat:@"appid=%@",IFLY_APPID];
    [IFlySpeechUtility createUtility:initString];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    
    self.homeVC = [[JJHomePageController alloc] init];
    self.homeNaviVC = [[UINavigationController alloc] initWithRootViewController:self.homeVC];
    
    self.gameVC = [[JJGameController alloc] init];
    self.gameNaviVC= [[UINavigationController alloc] initWithRootViewController:self.gameVC];
    
    self.notepadVC = [[JJNotepadController alloc] init];
    self.notepadNaviVC = [[UINavigationController alloc] initWithRootViewController:self.notepadVC];
    
    
    self.mainTabBarVC = [[DVVTabBarController alloc] init];
    self.mainTabBarVC.viewControllers = @[ self.homeNaviVC, self.notepadNaviVC, self.gameNaviVC ];
    
    self.window.rootViewController = self.mainTabBarVC;
    [self.window makeKeyAndVisible];
    
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
