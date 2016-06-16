//
//  JJNotepadListView.h
//  MiaoMiaoLive
//
//  Created by 金晓浩 on 16/6/16.
//  Copyright © 2016年 XiaoHaoJin. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^JJNotepadListViewDidSelected)(NSInteger index);

@interface JJNotepadListView : UITableView

@property (nonatomic, strong) NSMutableArray *dataList;
@property (nonatomic, copy) JJNotepadListViewDidSelected selectdBlock;

- (void)setSelectdBlock:(JJNotepadListViewDidSelected)selectdBlock;

- (void)queryData;

@end
