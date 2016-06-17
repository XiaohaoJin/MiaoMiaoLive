//
//  JJNotepadEditView.m
//  MiaoMiaoLive
//
//  Created by 金晓浩 on 16/6/15.
//  Copyright © 2016年 XiaoHaoJin. All rights reserved.
//

#import "JJNotepadEditView.h"

@implementation JJNotepadEditView

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.userInteractionEnabled = YES;
        ViewAddSubview(self.titleText);
        ViewAddSubview(self.contentText);
        ViewAddSubview(self.saveButton);
        [self configFrame];
    }
    return self;
}

- (void)configFrame
{
    _titleText.sd_layout.topSpaceToView(self, 20).leftSpaceToView(self, 10).rightSpaceToView(self, 10).heightIs(30);
    
    _contentText.sd_layout.topSpaceToView(self.titleText, 10).bottomSpaceToView(self, 40).leftEqualToView(_titleText).rightEqualToView(_titleText);
    _saveButton.sd_layout.topSpaceToView(_contentText, 10).leftEqualToView(_titleText).rightEqualToView(_titleText).bottomSpaceToView(self, 5);
}

-(void)saveContent:(id)sender
{
    if (_titleText.text.length != 0 && _contentText.text.length != 0)
    {
      
        if (_saveBlock)
        {
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:@"yyyy.MM.dd hh.mm.ss"];
            NSString *dateTime = [formatter stringFromDate:[NSDate date]];   
            _saveBlock(_titleText.text, _contentText.text, dateTime);
        }
    }
    else
    {
        if (_titleText.text.length == 0)
        {
            [JJToastView showMessage:@"写个标题吧！"];
        }
        else
        {
            [JJToastView showMessage:@"内容没写呢！"];
        }
    }
}

- (UITextField *)titleText
{
    if (!_titleText)
    {
        _titleText = [[UITextField alloc]init];
        _titleText.font = [UIFont systemFontOfSize:16 weight:5];
        _titleText.borderStyle = 0;
        _titleText.textAlignment = 1;
        _titleText.backgroundColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1];
        _titleText.placeholder = @"请输入标题";
        _titleText.delegate = self;
    }
    return _titleText;
}



- (JJTextView *)contentText
{
    if (!_contentText)
    {
        _contentText = [[JJTextView alloc]init];
        _contentText.backgroundColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1];
        _contentText.font = [UIFont systemFontOfSize:14];
        _contentText.placeHolder = @"请输入正文";
    }
    return _contentText;
}

- (UIButton *)saveButton
{
    if (!_saveButton)
    {
        _saveButton = [[UIButton alloc]init];
        _saveButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [_saveButton.layer setMasksToBounds:YES];
        [_saveButton.layer setCornerRadius:15];
        _saveButton.layer.borderColor = [[UIColor colorWithRed:0 green:0.6 blue:1 alpha:1] CGColor];
        _saveButton.layer.borderWidth = 1;
        _saveButton.titleLabel.font = [UIFont systemFontOfSize:14];
        [_saveButton setTitle:@"保存" forState:UIControlStateNormal];
        [_saveButton addTarget:self action:@selector(saveContent:) forControlEvents:UIControlEventTouchUpInside];

    }
    return _saveButton;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
