//
//  JJTextView.h
//  BaseTextView
//
//  Created by 金晓浩 on 16/6/17.
//  Copyright © 2016年 XiaoHaoJin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JJTextView : UITextView <UITextViewDelegate>

@property (nonatomic, strong) NSString *placeHolder;
@property (nonatomic, strong) UIColor *placeHolderColor;

@property (nonatomic, strong) UILabel *placeHolderLabel;


@end
