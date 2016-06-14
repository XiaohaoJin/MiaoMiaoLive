//
//  JJHomeBillTypeManagerCell.h
//  MiaoMiaoLive
//
//  Created by 金晓浩 on 16/5/29.
//  Copyright © 2016年 XiaoHaoJin. All rights reserved.
//

#import <UIKit/UIKit.h>
@class JJHomeBillTypeManagerCell;

typedef void(^JJHomeBillTypeManagerCellBlock)(BOOL isWobble);
typedef void(^JJHomeBillTypeManagerCellDeleteBlock)(JJHomeBillTypeManagerCell * aCell);
typedef void(^JJHomeBillTypeManagerCellShowSeletedCellBlock)(JJHomeBillTypeManagerCell *aCell);
@interface JJHomeBillTypeManagerCell : UICollectionViewCell

@property (nonatomic, strong) UIImageView *iconImg;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIButton *deleButton;

@property (nonatomic, assign) BOOL wobble;
@property (nonatomic, copy) JJHomeBillTypeManagerCellBlock wobbleBlock;
@property (nonatomic, copy) JJHomeBillTypeManagerCellDeleteBlock deleteBlock;
@property (nonatomic, copy) JJHomeBillTypeManagerCellShowSeletedCellBlock showSelectedBlock;

- (void)setWobbleBlock:(JJHomeBillTypeManagerCellBlock)wobbleBlock;
- (void)setDeleteBlock:(JJHomeBillTypeManagerCellDeleteBlock)deleteBlock;

- (void)setShowSelectedBlock:(JJHomeBillTypeManagerCellShowSeletedCellBlock)showSelectedBlock;

- (void)cancelWobble;
- (void)beginWobble;

@end
