//
//  JJGameController.m
//  MiaoMiaoLive
//
//  Created by 金晓浩 on 16/6/14.
//  Copyright © 2016年 XiaoHaoJin. All rights reserved.
//

#import "JJGameController.h"
#import "JJGameLevelTable.h"
#import "JJPlayingGameController.h"

@interface JJGameController ()

@property (nonatomic, strong) JJGameLevelTable *table;

@end

@implementation JJGameController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = ViewBgColor;
    self.edgesForExtendedLayout = NO;
    self.navigationItem.title = @"休闲娱乐";
    [self.view addSubview:self.table];
    
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    _table.frame = CGRectMake(0, 0 , ScreenWidth/2.0 , 120);
    _table.center = self.view.center;
}

- (void)Click
{
    JJGameController *game = [[JJGameController alloc] init];
    [self.navigationController pushViewController:game animated:YES];
}

- (JJGameLevelTable *)table
{
    if (!_table)
    {
        _table = [[JJGameLevelTable alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _table.layer.borderColor = [UIColor grayColor].CGColor;
        _table.layer.borderWidth = 1;
        _table.layer.cornerRadius = 20;
        _table.scrollEnabled = NO;
        _table.backgroundColor = [UIColor blueColor];
        __weak typeof(self) weakSelf = self;
        [_table setBlock:^(NSInteger index) {
            JJPlayingGameController *playing = [[JJPlayingGameController alloc] init];
            playing.level = index;
            [weakSelf.navigationController pushViewController:playing animated:YES];
        }];
    }
    return _table;
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
