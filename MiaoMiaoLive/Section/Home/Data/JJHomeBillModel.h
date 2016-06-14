//
//  JJHomeBillModel.h
//  MiaoMiaoLive
//
//  Created by 金晓浩 on 16/5/29.
//  Copyright © 2016年 XiaoHaoJin. All rights reserved.
//

#import "JJFMDBModel.h"

@interface JJHomeBillModel : JJFMDBModel

@property (nonatomic, copy) NSString *typeName;
@property (nonatomic, copy) NSString *type;
@property (nonatomic, copy) NSString *money;
@property (nonatomic, copy) NSString *currentTime;

@end
