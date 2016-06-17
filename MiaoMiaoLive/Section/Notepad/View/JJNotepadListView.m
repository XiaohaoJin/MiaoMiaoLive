//
//  JJNotepadListView.m
//  MiaoMiaoLive
//
//  Created by 金晓浩 on 16/6/16.
//  Copyright © 2016年 XiaoHaoJin. All rights reserved.
//

#import "JJNotepadListView.h"
#import "JJNotepadListCell.h"

#import "UITableView+FDTemplateLayoutCell.h"

@interface JJNotepadListView () <UITableViewDelegate, UITableViewDataSource>

@end

@implementation JJNotepadListView

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    self = [super initWithFrame:frame style:style];
    if (self)
    {
        self.delegate = self;
        self.dataSource = self;
        _dataList = [NSMutableArray array];
        [self registerClass:[JJNotepadListCell class] forCellReuseIdentifier:@"notepadcell"];
    }
    return self;
}

- (void)queryData
{
    _dataList = [NSMutableArray array];
    for (JJEditContentModel *model in [JJEditContentModel findAll]) {
        [_dataList insertObject:model atIndex:0];
    
    }
    [self reloadData];
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    JJEditContentModel *model = _dataList[indexPath.row];
    if (_selectdBlock)
    {
        _selectdBlock(indexPath.row, model);
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = [self cellHeightForIndexPath:indexPath
                                            model:_dataList[indexPath.row]
                                          keyPath:@"dataModel"
                                        cellClass:[JJNotepadListCell class]
                                 contentViewWidth:ScreenWidth];
//    WS;
//    CGFloat height = [self fd_heightForCellWithIdentifier:@"notepadcell" cacheByIndexPath:indexPath configuration:^(id cell) {
//        JJNotepadListCell *tmpCell = cell;
//        tmpCell.dataModel = weakSelf.dataList[indexPath.row];
//    }];
    DLog(@"%f", height);
    return height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * cellID = @"notepadcell";
    JJNotepadListCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell)
    {
        cell = [[JJNotepadListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"notepadcell"];
    }
    
    JJEditContentModel *model = _dataList[indexPath.row];
    [cell setDataModel:model];
    
    return cell;
}





@end
