//
//  JJHomeBillTypeAddController.h
//  MiaoMiaoLive
//
//  Created by 金晓浩 on 16/6/15.
//  Copyright © 2016年 XiaoHaoJin. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^JJHomeBillTypeAddControllerDoneBlock)(NSString *content);

@interface JJHomeBillTypeAddController : UIViewController



@property (nonatomic, copy) JJHomeBillTypeAddControllerDoneBlock doneBlock;
- (void)setDoneBlock:(JJHomeBillTypeAddControllerDoneBlock)doneBlock;


@end
