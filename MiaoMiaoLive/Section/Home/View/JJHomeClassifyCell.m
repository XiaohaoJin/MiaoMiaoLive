//
//  JJHomeClassifyCell.m
//  MiaoMiaoLiveShow
//
//  Created by 金晓浩 on 16/5/28.
//  Copyright © 2016年 XiaoHaoJin. All rights reserved.
//

#import "JJHomeClassifyCell.h"
#import "JJHomeClassifyCollectionCell.h"

static NSString *cellID = @"JJHomeClassifyCollectionCell";

@implementation JJHomeClassifyCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self.contentView addSubview:self.collectionView];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.collectionView.frame = self.bounds;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (_block)
    {
        _block(indexPath.row);
    }
    
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake((ScreenWidth - 20)/2.0, (ScreenWidth - 20)/2.0);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(5, 5, 5, 5);
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    JJHomeClassifyCollectionCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellID forIndexPath:indexPath];
    if (!cell)
    {
        cell = [[JJHomeClassifyCollectionCell alloc] init];
    }
    cell.titleLabel.text = _dataArray[indexPath.row];
    return cell;
}


- (UICollectionView *)collectionView
{
    if (!_collectionView)
    {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        [flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
          [_collectionView registerClass:[JJHomeClassifyCollectionCell class] forCellWithReuseIdentifier:cellID];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = [UIColor whiteColor];
        
    }
    return _collectionView;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}





@end
