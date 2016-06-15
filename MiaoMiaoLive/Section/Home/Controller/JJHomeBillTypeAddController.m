//
//  JJHomeBillTypeAddController.m
//  MiaoMiaoLive
//
//  Created by 金晓浩 on 16/6/15.
//  Copyright © 2016年 XiaoHaoJin. All rights reserved.
//

#import "JJHomeBillTypeAddController.h"

CGFloat const kHorizontalMargin = 10.f;
CGFloat const kVerticalMargin = 20.f;

@interface JJHomeBillTypeAddController () <UITextViewDelegate, IFlyRecognizerViewDelegate>
@property (nonatomic, strong) UITextView *textView;
@property (nonatomic, strong) UILabel *markLabel;
@property (nonatomic, strong) UIButton *doneButton;

@property (nonatomic, strong) UIButton *rightNavButton;
@property (nonatomic, strong) IFlyRecognizerView *iflyRecognizerView;//带界面的识别对象

@end

@implementation JJHomeBillTypeAddController


#pragma mark - lift cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = ViewBgColor;
    self.edgesForExtendedLayout = NO;
    UIBarButtonItem *navButton = [[UIBarButtonItem alloc] initWithCustomView:self.rightNavButton];
    self.navigationItem.rightBarButtonItem = navButton;
    
    [self.view addSubview:self.textView];
    [_textView addSubview:self.markLabel];
    [self.view addSubview:self.doneButton];
    [self configIflyRecognizerView];
    [self showOrHideMarkLabel];
    
}

- (void)dealloc
{
    _textView = nil;
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    CGSize size = self.view.bounds.size;
    CGFloat margin = 12;
    _textView.frame = CGRectMake(margin, margin, size.width - margin*2, 120);
    _markLabel.frame = CGRectMake(5, 5, CGRectGetWidth(_textView.frame), 20);
    CGFloat doneBtnHeight = 40;
    _doneButton.frame = CGRectMake(12, CGRectGetMaxY(_textView.frame) + margin, size.width - margin*2, doneBtnHeight);
    _rightNavButton.frame = CGRectMake(0 , 0, 22, 22);
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:true];
}

#pragma mark - action

- (void)doneButtonAction:(UIButton *)sender
{
    // 调用回调
    if (_doneBlock)
    {
        _doneBlock(_textView.text);
    }
    // 关闭窗体
    if (self.navigationController)
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
    else
    {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}


#pragma mark - textViewDelegate

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    
    if ([text isEqualToString:@"\n"])
    { // 判断输入的字是否是回车，即按下return
        // 在这里做响应return键的代码
        [self doneButtonAction:_doneButton];
        return NO; //这里返回NO，就代表return键值失效，即页面上按下return，不会出现换行，如果为yes，则输入页面会换行
    }
    return YES;
}

- (void)textViewDidChange:(UITextView *)textView
{
    
    [self showOrHideMarkLabel];
}

- (void)showOrHideMarkLabel
{
    
    if (_textView.text.length)
    {
        _markLabel.hidden = true;
    }
    else
    {
        _markLabel.hidden = false;
    }
}

- (void)configIflyRecognizerView
{
    _iflyRecognizerView = [[IFlyRecognizerView alloc] initWithCenter:self.view.center];
    _iflyRecognizerView.delegate = self;
    [_iflyRecognizerView setParameter:@"iat" forKey:[IFlySpeechConstant IFLY_DOMAIN]];
    // 保存录音文件名 如不再需要，设置value为nil表示取消，默认目录是documents
    [_iflyRecognizerView setParameter:@"asr.pcm" forKey:[IFlySpeechConstant ASR_AUDIO_PATH]];
    //设置听写结果格式为json
    //    [_iflyRecognizerView setParameter:@"plain" forKey:[IFlySpeechConstant RESULT_TYPE]];
    
}

/*!
 *  回调返回识别结果
 *  @param resultArray 识别结果，NSArray的第一个元素为NSDictionary，NSDictionary的key为识别结果，sc为识别结果的置信度
 *  @param isLast      -[out] 是否最后一个结果
 */
- (void)onResult:(NSArray *)resultArray isLast:(BOOL)isLast
{
    NSMutableString * result = [[NSMutableString alloc] init];
    NSDictionary * dic = [resultArray objectAtIndex:0];
    for (NSString *key in dic)
    {
        [result appendFormat:@"%@",key];
    }
    NSString *resu = [ISRDataHelper stringFromJson:result];
    if (kIsNull(resu))
    {
        [JJAlertView showAlertWithTitle:@"提示" message:@"没有识别到内容" cancelButtonTitle:@"确认" otherButtonTitles:nil completion:nil];
    }
    else
    {
        [self showOrHideMarkLabel];
        _textView.text = [_textView.text stringByAppendingString:resu];
    }
}

/*!
 *  识别结束回调
 *  @param error 识别结束错误码
 */
- (void)onError: (IFlySpeechError *) error
{
    DLog(@"识别结束回调  == %@",error);
}

- (void)beginButtonAction
{
    　//启动识别服务
    [_iflyRecognizerView start];
    
}

#pragma mark - lazy load
- (UIButton *)rightNavButton
{
    if (!_rightNavButton)
    {
        UIButton *button = [[UIButton alloc]init];
        [button setImage:[UIImage imageNamed:@"ic_tab_voice"] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(beginButtonAction) forControlEvents:UIControlEventTouchUpInside];
        _rightNavButton = button;
    }
    return _rightNavButton;
}


- (UITextView *)textView
{
    if (!_textView)
    {
        _textView = [UITextView new];
        _textView.delegate = self;
        _textView.backgroundColor = [UIColor colorWithHexString:@"EEEEEE"];
        [_textView.layer setMasksToBounds:YES];
        [_textView.layer setCornerRadius:4];
        _textView.returnKeyType = UIReturnKeyDone;
    }
    return _textView;
}

- (UILabel *)markLabel
{
    if (!_markLabel)
    {
        _markLabel = [UILabel new];
        _markLabel.text = @"请点击输入";
        _markLabel.textColor = [UIColor colorWithHexString:@"AAAAAA"];
        _markLabel.font = [UIFont systemFontOfSize:14];
    }
    return _markLabel;
}

- (UIButton *)doneButton
{
    if (!_doneButton)
    {
        _doneButton = [UIButton new];
        _doneButton.backgroundColor = BtnNormalBgColor;
        [_doneButton.layer setMasksToBounds:YES];
        [_doneButton.layer setCornerRadius:6];
        _doneButton.titleLabel.font = [UIFont systemFontOfSize:14];
        [_doneButton setTitle:@"完成" forState:UIControlStateNormal];
        [_doneButton addTarget:self action:@selector(doneButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _doneButton;
}


- (void)didReceiveMemoryWarning
{
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
