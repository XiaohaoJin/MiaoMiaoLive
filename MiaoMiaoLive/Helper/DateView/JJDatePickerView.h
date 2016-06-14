//
//  JJDateView.h
//  MiaoMiaoLive
//
//  Created by 金晓浩 on 16/6/12.
//  Copyright © 2016年 XiaoHaoJin. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^JJDatePickerViewDidSelectedBlock)(NSString *yearString, NSString *monthStrig, NSString *dayString);

@interface JJDatePickerView : UIView

@property (nonatomic, strong) UIButton *cancelButton;
@property (nonatomic, strong) UIButton *doneButton;
@property (nonatomic, strong) UILabel *titleLabel;

+ (void)showFromView:(UIView *)superView
               title:(NSString *)title
    didSelectedBlock:(JJDatePickerViewDidSelectedBlock)didSelectedBlock;



@end