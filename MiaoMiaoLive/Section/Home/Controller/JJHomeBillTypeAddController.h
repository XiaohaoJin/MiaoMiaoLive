//
//  DDBInputTextController.h
//  DingDangB2B
//
//  Created by 大威 on 16/4/27.
//  Copyright © 2016年 华晓春. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^JJHomeBillTypeAddControllerDoneBlock)(NSString *content);

@interface JJHomeBillTypeAddController : UIViewController



@property (nonatomic, copy) JJHomeBillTypeAddControllerDoneBlock doneBlock;
- (void)setDoneBlock:(JJHomeBillTypeAddControllerDoneBlock)doneBlock;


@end
