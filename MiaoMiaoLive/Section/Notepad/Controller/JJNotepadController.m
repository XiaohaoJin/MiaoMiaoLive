//
//  JJNotepadController.m
//  MiaoMiaoLive
//
//  Created by 金晓浩 on 16/6/15.
//  Copyright © 2016年 XiaoHaoJin. All rights reserved.
//

#import "JJNotepadController.h"
#import "JJToolBarView.h"
#import "JJNotepadEditView.h"
#import "JJEditContentModel.h"
#import "JJNotepadListView.h"
#import "JJNotepadDetailController.h"

@interface JJNotepadController () <UITextFieldDelegate, UIScrollViewDelegate, IFlyRecognizerViewDelegate>

@property (nonatomic, strong) JJToolBarView *toolBar;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) JJNotepadEditView *editNotepad;
@property (nonatomic, nonnull, strong) JJNotepadListView *listView;
@property (nonatomic, strong) NSMutableArray *notepadDataArray;
@property (nonatomic, strong) UIButton *rightNavButton;
@property (nonatomic, strong) IFlyRecognizerView *iflyRecognizerView;//带界面的识别对象


@end

@implementation JJNotepadController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.edgesForExtendedLayout = NO;
    self.navigationItem.title = @"记事本";
    UIBarButtonItem *navButton = [[UIBarButtonItem alloc] initWithCustomView:self.rightNavButton];
    self.navigationItem.rightBarButtonItem = navButton;
    
    VCAddSubview(self.toolBar);
    VCAddSubview(self.scrollView);
    [self.scrollView addSubview:self.editNotepad];
    [self.scrollView addSubview:self.listView];
    [self configIflyRecognizerView];
    
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    _rightNavButton.frame = CGRectMake(0 , 0, 22, 22);
    
    _toolBar.sd_layout
    .topSpaceToView(self.view, 0)
    .leftSpaceToView(self.view, 0)
    .heightIs(30)
    .widthIs(ScreenWidth);
    
    _scrollView.sd_layout
    .topSpaceToView(self.toolBar, 0)
    .leftSpaceToView(self.view, 0)
    .rightSpaceToView(self.view, 0)
    .bottomSpaceToView(self.view, 0);
    
    _editNotepad.sd_layout
    .topSpaceToView(self.scrollView, 0)
    .leftSpaceToView(self.scrollView, 0)
    .widthIs(ScreenWidth)
    .bottomSpaceToView(self.scrollView, 0);
    
    _listView.sd_layout
    .topEqualToView(self.scrollView)
    .leftSpaceToView(self.editNotepad, 0)
    .bottomEqualToView(self.editNotepad)
    .widthIs(self.scrollView.width_sd);
    
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    CGFloat offsizeX = scrollView.contentOffset.x;
    NSInteger index = offsizeX / ScreenWidth;
    [self.toolBar selectItem:index];
    
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
        if (_editNotepad.titleText.isFirstResponder)
        {
            DLog(@"titleText focused");
            _editNotepad.titleText.text = [_editNotepad.titleText.text stringByAppendingString:resu];
        }
        else if (_editNotepad.contentText.isFirstResponder)
        {
            DLog(@"contentText focused");
            _editNotepad.contentText.text = [_editNotepad.contentText.text stringByAppendingString:resu];
        }
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
- (void)beginButtonAction
{
    // 启动识别服务
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

- (JJToolBarView *)toolBar
{
    if (!_toolBar)
    {
        _toolBar = [JJToolBarView new];
        _toolBar.titleArray = @[ @"编辑", @"查看"];
        _toolBar.followBarLocation = 1;
        _toolBar.followBarColor = [UIColor greenColor];
        WS;
        [_toolBar jjToolBarViewItemSelected:^(UIButton *button) {
            NSInteger index = button.tag;
            weakSelf.scrollView.contentOffset = CGPointMake(ScreenWidth*index, 0);
            if (0 == button.tag) {
                self.rightNavButton.hidden = NO;
            }
            if (1 == button.tag)
            {
                self.rightNavButton.hidden = YES;
                [self.listView queryData];
            }
        }];
    }
    return _toolBar;
}

- (UIScrollView *)scrollView
{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.contentSize = CGSizeMake(ScreenWidth*2, 0);
        _scrollView.pagingEnabled = YES;
        _scrollView.delegate = self;
    }
    return _scrollView;
}

- (JJNotepadEditView *)editNotepad
{
    if (!_editNotepad)
    {
        _editNotepad = [[JJNotepadEditView alloc] init];
        [_editNotepad setSaveBlock:^(NSString *title, NSString *content, NSString *date) {
            JJEditContentModel * model = [[JJEditContentModel alloc] init];
            model.title = title;
            model.content = content;
            model.dateTime = date;
            [JJEditContentModel saveObjects:@[model]];
        }];
    }
    return _editNotepad;
}

- (JJNotepadListView *)listView
{
    if (!_listView) {
        _listView = [[JJNotepadListView alloc] init];
        WS;
        [_listView setSelectdBlock:^(NSInteger index, JJEditContentModel *model) {
            JJNotepadDetailController *detailVC = [JJNotepadDetailController new];
            detailVC.model = model;
            [weakSelf.navigationController pushViewController:detailVC animated:YES];
            
        }];
    }
    return _listView;
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
