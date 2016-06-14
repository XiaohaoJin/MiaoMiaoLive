//
//  JJHomePageBillDetailController.h
//  MiaoMiaoLive
//
//  Created by 金晓浩 on 16/6/3.
//  Copyright © 2016年 XiaoHaoJin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JJHomeBillModel.h"

@interface JJHomePageBillDetailController : UIViewController

@property (nonatomic, copy) NSString *typeName;
@property (nonatomic, copy) NSString *type;
@property (nonatomic, copy) NSString *dateTime;
@property (nonatomic, copy) NSString *money;

@property (nonatomic, strong) JJHomeBillModel *dataModel;

@end
