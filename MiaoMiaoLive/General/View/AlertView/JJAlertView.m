//
//  JXHAlertView.m
//  MagMode
//
//  Created by 金晓浩 on 16/4/1.
//  Copyright © 2016年 XiaoHaoJin. All rights reserved.
//

#import "JJAlertView.h"


@interface JJAlertView () <UIAlertViewDelegate>

@property (nonatomic, copy) JJAlertViewCompletion completion;

@end

@implementation JJAlertView


#pragma mark - init

+ (void)showAlertWithTitle:(NSString *)title
                   message:(NSString *)message
         cancelButtonTitle:(NSString *)cancelButtonTitle
         otherButtonTitles:(NSArray *)otherButtonTitles
                completion:(JJAlertViewCompletion)completion{
    if ([UIAlertController class]) {
        __block UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title
                                                                                         message:message
                                                                                  preferredStyle:UIAlertControllerStyleAlert];
        
        void (^alertActionHandler)(UIAlertAction *) = [^(UIAlertAction *action){
            // This block intentionally retains alertController, and releases it afterwards.
            if (completion) {
                NSUInteger index = [alertController.actions indexOfObject:action];
                completion(index - 1);
            }
            alertController = nil;
        } copy];
        
        [alertController addAction:[UIAlertAction actionWithTitle:cancelButtonTitle
                                                            style:UIAlertActionStyleCancel
                                                          handler:alertActionHandler]];
        
        for (NSString *buttonTitle in otherButtonTitles) {
            [alertController addAction:[UIAlertAction actionWithTitle:buttonTitle
                                                                style:UIAlertActionStyleDefault
                                                              handler:alertActionHandler]];
        }
        
        UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
        UIViewController *viewController = keyWindow.rootViewController;
        [viewController presentViewController:alertController animated:YES completion:nil];
    } else {
        __block JJAlertView *jjAlertView = [[self alloc] init];
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title
                                                            message:message
                                                           delegate:nil
                                                  cancelButtonTitle:cancelButtonTitle
                                                  otherButtonTitles:nil];
        
        for (NSString *buttonTitle in otherButtonTitles) {
            [alertView addButtonWithTitle:buttonTitle];
        }
        
        jjAlertView.completion = ^(NSUInteger index) {
            if (completion) {
                completion(index);
            }
            
            jjAlertView = nil;
        };
        
        alertView.delegate = jjAlertView;
        [alertView show];
    }
}


#pragma mark - UIAlertView delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (self.completion) {
        self.completion(buttonIndex - alertView.firstOtherButtonIndex);
    }
}
@end