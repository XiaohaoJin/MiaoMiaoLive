//
//  JJFMDBManager.m
//  
//
//  Created by 金晓浩 on 16/5/29.
//
//

#import "JJFMDBManager.h"

NSString * const MMLBillDBName = @"mmrbill";

@implementation JJFMDBManager

+ (instancetype)sharedManager {
    static JJFMDBManager * dbManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dbManager = [self new];
    });
    return dbManager;
}

// 创建数据库
+ (NSString *)dbPath
{
    NSString *docsdir = [NSSearchPathForDirectoriesInDomains( NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSFileManager *filemanage = [NSFileManager defaultManager];
    
    docsdir = [docsdir stringByAppendingPathComponent:@"MiaoMiaoLiveDB"]; // 创建文件夹
    BOOL isDir;
    BOOL exit =[filemanage fileExistsAtPath:docsdir isDirectory:&isDir];
    if (!exit || !isDir) {
        [filemanage createDirectoryAtPath:docsdir withIntermediateDirectories:YES attributes:nil error:nil];
    }
    NSString *dbpath = [docsdir stringByAppendingPathComponent:FormatString(@"%@.sqlite",MMLBillDBName)];
    return dbpath;
}


//创建多线程安全的数据库

- (FMDatabaseQueue *)dbQueue
{
    if (!_dbQueue) {
        _dbQueue = [[FMDatabaseQueue alloc] initWithPath:[self.class dbPath]];
    }
    return _dbQueue;
}




@end



