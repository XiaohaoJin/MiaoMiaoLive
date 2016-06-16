//
//  JJNotepadEditView.h
//  MiaoMiaoLive
//
//  Created by 金晓浩 on 16/6/15.
//  Copyright © 2016年 XiaoHaoJin. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^JJNotepadEditSaveBlock)(NSString * title, NSString * content, NSString *date);
@interface JJNotepadEditView : UIView <UITextFieldDelegate>


//填写文章标题
@property (nonatomic, strong) UITextField *titleText;
//填写文章内容
@property (nonatomic, strong) UITextView *contentText;
//保存文章的按钮
@property (nonatomic, strong) UIButton *saveButton;

//保存时的动画
@property (nonatomic, strong) NSTimer *tmrSave;
//进度条（保存时显示）
@property (nonatomic, strong) UIProgressView *pgsv;
//加载指示器（保存时显示）
@property (nonatomic, strong) UIActivityIndicatorView *aitv;
//提示窗体
@property (nonatomic, strong) UIAlertView *altv;

@property (nonatomic, copy) JJNotepadEditSaveBlock saveBlock;

- (void)setSaveBlock:(JJNotepadEditSaveBlock)saveBlock;

@end
