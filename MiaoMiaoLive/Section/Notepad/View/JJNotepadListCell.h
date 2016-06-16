//
//  JJNotepadListCell.h
//  MiaoMiaoLive
//
//  Created by 金晓浩 on 16/6/16.
//  Copyright © 2016年 XiaoHaoJin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JJEditContentModel.h"
@interface JJNotepadListCell : UITableViewCell

@property (nonatomic, strong) UIImageView *signImage;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *dateLabel;
@property (nonatomic, strong) UILabel *contentLabel;

@property (nonatomic, strong) JJEditContentModel *dataModel;

@end
