//
//  JXHAlertView.h
//  MagMode
//
//  Created by 金晓浩 on 16/4/1.
//  Copyright © 2016年 XiaoHaoJin. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^JJAlertViewCompletion)(NSUInteger selectedOtherButtonIndex);

@interface JJAlertView : NSObject
+ (void)showAlertWithTitle:(NSString *)title
                   message:(NSString *)message
         cancelButtonTitle:(NSString *)cancelButtonTitle
         otherButtonTitles:(NSArray *)otherButtonTitles
                completion:(JJAlertViewCompletion)completion;
@end
