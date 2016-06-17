//
//  JJNotepadEditView.h
//  MiaoMiaoLive
//
//  Created by 金晓浩 on 16/6/15.
//  Copyright © 2016年 XiaoHaoJin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JJTextView.h"
typedef void(^JJNotepadEditSaveBlock)(NSString * title, NSString * content, NSString *date);
@interface JJNotepadEditView : UIView <UITextFieldDelegate>


//填写文章标题
@property (nonatomic, strong) UITextField *titleText;
//填写文章内容
@property (nonatomic, strong) JJTextView *contentText;
//保存文章的按钮
@property (nonatomic, strong) UIButton *saveButton;

@property (nonatomic, copy) JJNotepadEditSaveBlock saveBlock;

- (void)setSaveBlock:(JJNotepadEditSaveBlock)saveBlock;

@end
