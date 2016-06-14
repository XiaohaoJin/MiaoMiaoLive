//
//  JJFMDBManager.h
//  
//
//  Created by 金晓浩 on 16/5/29.
//
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "FMDB.h"



@interface JJFMDBManager : NSObject

@property (nonatomic, strong) FMDatabaseQueue *dbQueue;

+ (instancetype)sharedManager;
+ (NSString *)dbPath;

@end
