//
//  JJSideController.m
//  MiaoMiaoLiveShow
//
//  Created by 金晓浩 on 16/5/28.
//  Copyright © 2016年 XiaoHaoJin. All rights reserved.
//

#import "JJSideController.h"

#define ContentViewRect  CGRectMake(20 - ScreenWidth, 0, ScreenWidth - 80, ScreenHeight)
#define ContentViewChangeRect  CGRectMake(0, 0, ScreenWidth - 80, ScreenHeight)

@interface JJSideController ()

@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UIView *backgroundHideView;

@end

@implementation JJSideController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.backgroundHideView];
    _backgroundHideView.alpha = 0;
    [self.view addSubview:self.contentView];
}

+ (instancetype)shareSideController {
    static JJSideController *sideVC = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sideVC = [[JJSideController alloc] init];
    });
    return sideVC;
}


+ (void)showJJSideFromWindow:(UIWindow *)window {
    JJSideController * sideVC = [self shareSideController];
    [window addSubview:sideVC.view];

   [UIView animateWithDuration:2 animations:^{
       sideVC.contentView.frame = ContentViewChangeRect;
       sideVC.backgroundHideView.alpha = 0.5;
   } completion:^(BOOL finished) {
       
   }];
}

- (void)hideJJSideRemoveSupView {
   
    [UIView animateWithDuration:2 animations:^{
        self.backgroundHideView.alpha = 0;
        self.contentView.frame = ContentViewRect;
    } completion:^(BOOL finished) {
//        [self.view removeFromSuperview];
    }];
    
}

//- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
//    [self hideJJSideRemoveSupView];
//}

- (UIView *)contentView
{
    if (!_contentView) {
        _contentView = [UIView new];
        _contentView.backgroundColor = [UIColor yellowColor];
        _contentView.frame = ContentViewRect;
    }
    return _contentView;
}

- (UIView *)backgroundHideView
{
    if (!_backgroundHideView) {
        _backgroundHideView = [UIView new];
        _backgroundHideView.frame = self.view.frame;
        _backgroundHideView.backgroundColor = [UIColor blackColor];
        _backgroundHideView.alpha = 0.7;
        
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideJJSideRemoveSupView)];
        [_backgroundHideView addGestureRecognizer:tap];

    }
    return _backgroundHideView;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
