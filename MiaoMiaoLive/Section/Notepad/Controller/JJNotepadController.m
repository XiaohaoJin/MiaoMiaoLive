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

@interface JJNotepadController () <UITextFieldDelegate, UIScrollViewDelegate>

@property (nonatomic, strong) JJToolBarView *toolBar;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) JJNotepadEditView *editNotepad;
@property (nonatomic, nonnull, strong) JJNotepadListView *listView;
@property (nonatomic, strong) NSMutableArray *notepadDataArray;


@end

@implementation JJNotepadController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.edgesForExtendedLayout = NO;
    self.navigationItem.title = @"记事本";
    VCAddSubview(self.toolBar);
    VCAddSubview(self.scrollView);
    [self.scrollView addSubview:self.editNotepad];
    [self.scrollView addSubview:self.listView];
    
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
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
            if (1 == button.tag)
            {
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
