//
//  JJSideController.h
//  MiaoMiaoLiveShow
//
//  Created by 金晓浩 on 16/5/28.
//  Copyright © 2016年 XiaoHaoJin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JJSideController : UIViewController

+ (instancetype)shareSideController;

+ (void)showJJSideFromWindow:(UIWindow *)window;

+ (void)hideJJSideRemoveSupView;
@end
