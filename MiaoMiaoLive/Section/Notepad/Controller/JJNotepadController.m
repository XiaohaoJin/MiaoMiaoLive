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

@interface JJNotepadController () <UITextFieldDelegate>

@property (nonatomic, strong) JJToolBarView *toolBar;
@property (nonatomic, strong) JJNotepadEditView *editNotepad;

@end

@implementation JJNotepadController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.edgesForExtendedLayout = NO;
//    UIBarButtonItem * item = [[UIBarButtonItem alloc] initWithCustomView:self.toolBar];
//    self.navigationItem.leftBarButtonItem = item;
    VCAddSubview(self.toolBar);
    VCAddSubview(self.editNotepad);
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    _toolBar.sd_layout
    .topSpaceToView(self.view, 0)
    .leftSpaceToView(self.view, 0)
    .heightIs(30)
    .widthIs(ScreenWidth);
    
    _editNotepad.sd_layout
    .topSpaceToView(_toolBar, 0)
    .leftSpaceToView(self.view, 0)
    .rightSpaceToView(self.view, 0)
    .bottomSpaceToView(self.view, 0);
}


- (JJToolBarView *)toolBar
{
    if (!_toolBar)
    {
        _toolBar = [JJToolBarView new];
        _toolBar.titleArray = @[ @"编辑", @"查看"];
    }
    return _toolBar;
}

- (JJNotepadEditView *)editNotepad
{
    if (!_editNotepad)
    {
        _editNotepad = [[JJNotepadEditView alloc] init];
    }
    return _editNotepad;
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
