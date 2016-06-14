//
//  JJHomeClassifyCell.h
//  MiaoMiaoLiveShow
//
//  Created by 金晓浩 on 16/5/28.
//  Copyright © 2016年 XiaoHaoJin. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^JJHomeClassifyCellBlock)(NSInteger selectIndex);

@interface JJHomeClassifyCell : UITableViewCell <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, copy) JJHomeClassifyCellBlock block;
- (void)setBlock:(JJHomeClassifyCellBlock)block;

@end
