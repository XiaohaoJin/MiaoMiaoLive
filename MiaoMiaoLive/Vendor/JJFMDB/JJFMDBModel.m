//
//  JJFMDBModel.m
//  MiaoMiaoLive
//
//  Created by 金晓浩 on 16/5/29.
//  Copyright © 2016年 XiaoHaoJin. All rights reserved.
//

#import "JJFMDBModel.h"
#import "JJFMDBManager.h"
#import <objc/runtime.h>

@implementation JJFMDBModel

#pragma mark - 创建数据库 -> 通过运行时拿到模型所有的属性，属性类型 -> 添加一个主键属性 -> 将所有的属性，主键拼接成（符合sqlite语法）字段定义语句 -> 执行语句，创建表以及表字段 -> 重新拿到所有的属性名，以及数据库中所有的字段名；将这2个数组进行对比，一旦发现某个属性在数据库没有对应的字段（漏掉了），数据库立即新增字段 -> 关闭数据库
/**
 * 创建表
 * 如果已经创建，返回YES
 */
+ (BOOL)createTable
{
    //拿到数据库路径，创建数据库
    FMDatabase *db = [FMDatabase databaseWithPath:[JJFMDBManager dbPath]];
    //开启数据库
    if (![db open]) {
        DLog(@"数据库打开失败!");
        return NO;
    }
    
    NSString *tableName = NSStringFromClass(self.class);
    NSString *columeAndType = [self.class getColumeAndTypeString];
    //创建字段，columeAndType中保存的是模型中所有的属性名与属性类型
    NSString *sql = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@(%@);",tableName,columeAndType];
    if (![db executeUpdate:sql]) {
        return NO;
    }
    
    NSMutableArray *columns = [NSMutableArray array];
    //schema:纲要(既然是纲要，那么就不会涉及具体的数据，只会涉及字段名，字段类型...)。
    //需要传入的参数：表名，返回值：查询表后的结果集FMResultSet
    FMResultSet *resultSet = [db getTableSchema:tableName];
    while ([resultSet next]) {
        //取出结果集中name对应的值，即字段的名称（取出所有的字段名）
        NSString *column = [resultSet stringForColumn:@"name"];
        [columns addObject:column];
    }
    //拿到存有所有属性（包括自己添加的主键字段）的字典
    NSDictionary *dict = [self.class getAllProperties];
    //拿到所有属性名
    NSArray *properties = [dict objectForKey:@"name"];
    //这个过滤数组的作用：检查模型中所有的属性在数据库中是否都有对应的字段，如果没有，立即新增一个字段
    NSPredicate *filterPredicate = [NSPredicate predicateWithFormat:@"NOT (SELF IN %@)",columns];
    //过滤数组
    NSArray *resultArray = [properties filteredArrayUsingPredicate:filterPredicate];
    
    for (NSString *column in resultArray) {
        NSUInteger index = [properties indexOfObject:column];
        NSString *proType = [[dict objectForKey:@"type"] objectAtIndex:index];
        NSString *fieldSql = [NSString stringWithFormat:@"%@ %@",column,proType];
        //在表中添加新的字段（或者说新的列）
        NSString *sql = [NSString stringWithFormat:@"ALTER TABLE %@ ADD COLUMN %@ ",NSStringFromClass(self.class),fieldSql];
        if (![db executeUpdate:sql]) {
            return NO;
        }
    }
    [db close];
    return YES;
}
/**
 *  获取该类的所有属性以及属性对应的类型,并且存入字典中
 */
+ (NSDictionary *)getPropertys
{
    //存放模型中所有的属性名
    NSMutableArray *proNames = [NSMutableArray array];
    //存放模型中所有属性对应的类型(sqlite数据类型)
    NSMutableArray *proTypes = [NSMutableArray array];
    NSArray *theTransients = [[self class] transients];
    unsigned int outCount, i;
    objc_property_t *properties = class_copyPropertyList([self class], &outCount);
    for (i = 0; i < outCount; i++) {
        objc_property_t property = properties[i];
        //获取属性名
        NSString *propertyName = [NSString stringWithCString:property_getName(property) encoding:NSUTF8StringEncoding];
        //子类模型中一些不需要创建数据库字段的property，直接跳过去
        if ([theTransients containsObject:propertyName]) {
            continue;
        }
        [proNames addObject:propertyName];
        //获取属性类型等参数
        NSString *propertyType = [NSString stringWithCString: property_getAttributes(property) encoding:NSUTF8StringEncoding];
        /*
         c char         C unsigned char
         i int          I unsigned int
         l long         L unsigned long
         s short        S unsigned short
         d double       D unsigned double
         f float        F unsigned float
         q long long    Q unsigned long long
         B BOOL
         @ 对象类型 //指针 对象类型 如NSString 是@“NSString”
         
         
         64位下long 和long long 都是Tq
         SQLite 默认支持五种数据类型TEXT、INTEGER、REAL、BLOB、NULL
         */
        if ([propertyType hasPrefix:@"T@"]) {//@:字符串
            [proTypes addObject:SQLTEXT];
        } else if ([propertyType hasPrefix:@"Ti"]||[propertyType hasPrefix:@"TI"]||[propertyType hasPrefix:@"Ts"]||[propertyType hasPrefix:@"TS"]||[propertyType hasPrefix:@"TB"]) {//i,I(integer):整形； s(short):短整形； B(BOOL):布尔；
            [proTypes addObject:SQLINTEGER];
        } else {
            [proTypes addObject:SQLREAL];
        }
        
    }
    free(properties);
    
    return [NSDictionary dictionaryWithObjectsAndKeys:proNames,@"name",proTypes,@"type",nil];
}
#pragma mark - must be override method
/** 如果子类中有一些property不需要创建数据库字段，那么这个方法必须在子类中重写
 */
+ (NSArray *)transients
{
    return [NSArray array];
}
//将属性名与属性类型拼接成sqlite语句：integer a,real b,...
+ (NSString *)getColumeAndTypeString
{
    NSMutableString* pars = [NSMutableString string];
    NSDictionary *dict = [self.class getAllProperties];
    
    NSMutableArray *proNames = [dict objectForKey:@"name"];
    NSMutableArray *proTypes = [dict objectForKey:@"type"];
    
    for (int i=0; i< proNames.count; i++) {
        [pars appendFormat:@"%@ %@",[proNames objectAtIndex:i],[proTypes objectAtIndex:i]];
        if(i+1 != proNames.count)
        {
            [pars appendString:@","];
        }
    }
    return pars;
}
/** 获取模型中的所有属性，并且添加一个主键字段pk。这些数据都存入一个字典中 */
+ (NSDictionary *)getAllProperties
{
    NSDictionary *dict = [self.class getPropertys];
    
    NSMutableArray *proNames = [NSMutableArray array];
    NSMutableArray *proTypes = [NSMutableArray array];
    [proNames addObject:primaryId];
    [proTypes addObject:[NSString stringWithFormat:@"%@ %@",SQLINTEGER,PrimaryKey]];
    [proNames addObjectsFromArray:[dict objectForKey:@"name"]];
    [proTypes addObjectsFromArray:[dict objectForKey:@"type"]];
    
    return [NSDictionary dictionaryWithObjectsAndKeys:proNames,@"name",proTypes,@"type",nil];
}

#pragma mark - 初始化时，创建数据库，新增字段
+ (void)initialize
{
    if (self != [JJFMDBModel self]) {
        [self createTable];
    }
}
#pragma mark - 创建对象时，给成员变量赋值
- (instancetype)init
{
    self = [super init];
    if (self) {
        NSDictionary *dic = [self.class getAllProperties];
        _columeNames = [[NSMutableArray alloc] initWithArray:[dic objectForKey:@"name"]];
        _columeTypes = [[NSMutableArray alloc] initWithArray:[dic objectForKey:@"type"]];
    }
    
    return self;
}
#pragma mark - 保存数据(保存模型数据).通过运行时拿到所有属性 -> 通过KVC，拿到所有属性地址存储的值，用一个数组保存 -> 利用先前拿到的属性名与值的数组，依照sqlite语法拼接成插入语句 -> 执行插入操作
//【关键】：想要插入数据到创建好的数据库，需要字段名与值；字段名就是所有的属性名，值就是属性地址存储的值;
- (BOOL)save
{
    NSString *tableName = NSStringFromClass(self.class);
    NSMutableString *keyString = [NSMutableString string];
    NSMutableString *valueString = [NSMutableString string];
    NSMutableArray *insertValues = [NSMutableArray  array];
    for (int i = 0; i < self.columeNames.count; i++) {
        NSString *proname = [self.columeNames objectAtIndex:i];
        //如果是主键，不处理
        if ([proname isEqualToString:primaryId]) {
            continue;
        }
        [keyString appendFormat:@"%@,", proname];
        [valueString appendString:@"?,"];
        //【KVC】通过KVC将属性值取出来(运行时配合KVC还真方便)
        id value = [self valueForKey:proname];
        //属性值可能为空
        if (!value) {
            value = @"";
        }
        [insertValues addObject:value];
    }
    
    //删除最后的那个","
    [keyString deleteCharactersInRange:NSMakeRange(keyString.length - 1, 1)];
    [valueString deleteCharactersInRange:NSMakeRange(valueString.length - 1, 1)];
    
    JJFMDBManager *ykDB = [JJFMDBManager sharedManager];
    __block BOOL res = NO;
    [ykDB.dbQueue inDatabase:^(FMDatabase *db) {
        NSString *sql = [NSString stringWithFormat:@"INSERT INTO %@(%@) VALUES (%@);", tableName, keyString, valueString];
        //这个方法会自动到一个数组中去取值
        res = [db executeUpdate:sql withArgumentsInArray:insertValues];
        //获取数据库最后一个行的id
        self.pk = res?[NSNumber numberWithLongLong:db.lastInsertRowId].intValue:0;
        DLog(res?@"插入成功":@"插入失败");
        if (res) {
            [JJToastView showMessage:@"添加成功"];
        }
        else {
            [JJToastView showMessage:@"添加失败"];
        }
    }];
    return res;
}
#pragma mark - 应用事务来保存数据
/** 应用事务批量保存用户对象 */
+ (BOOL)saveObjects:(NSArray *)array
{
    //判断是否是JJFMDBModel的子类
    for (JJFMDBModel *model in array) {
        if (![model isKindOfClass:[JJFMDBModel class]]) {
            return NO;
        }
    }
    
    __block BOOL res = YES;
    JJFMDBManager *jjDB = [JJFMDBManager sharedManager];
    // 如果要支持事务
    [jjDB.dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        for (JJFMDBModel *model in array) {
            NSString *tableName = NSStringFromClass(model.class);
            NSMutableString *keyString = [NSMutableString string];
            NSMutableString *valueString = [NSMutableString string];
            NSMutableArray *insertValues = [NSMutableArray  array];
            for (int i = 0; i < model.columeNames.count; i++) {
                NSString *proname = [model.columeNames objectAtIndex:i];
                if ([proname isEqualToString:primaryId]) {
                    continue;
                }
                [keyString appendFormat:@"%@,", proname];
                [valueString appendString:@"?,"];
                id value = [model valueForKey:proname];
                if (!value) {
                    value = @"";
                }
                [insertValues addObject:value];
            }
            [keyString deleteCharactersInRange:NSMakeRange(keyString.length - 1, 1)];
            [valueString deleteCharactersInRange:NSMakeRange(valueString.length - 1, 1)];
            
            NSString *sql = [NSString stringWithFormat:@"INSERT INTO %@(%@) VALUES (%@);", tableName, keyString, valueString];
            BOOL flag = [db executeUpdate:sql withArgumentsInArray:insertValues];
            model.pk = flag?[NSNumber numberWithLongLong:db.lastInsertRowId].intValue:0;
            DLog(flag?@"插入成功":@"插入失败");
            
            NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
            NSData * data = [defaults objectForKey:IsFirstRunning];
            NSString * isFirst = [NSString stringWithFormat:@"%@",data];
            DLog(@"%@",isFirst);
            
            if ([isFirst isEqualToString:@"YES"])
            {
                if (res) {
                    [JJToastView showMessage:@"添加成功"];
                }
                else {
                    [JJToastView showMessage:@"添加失败"];
                }
            }
            
          
            if (!flag) {
                res = NO;
                //一旦出错，回滚
                *rollback = YES;
                return;
            }
        }
    }];
    return res;
}
#pragma mark - 删除数据.删除数据需要的资源：表名NSStringFromClass(self.class)，条件语句WHERE pk < 10
/** 通过条件删除数据 */
+ (BOOL)deleteObjectsByCriteria:(NSString *)criteria
{
    JJFMDBManager *jjDB = [JJFMDBManager sharedManager];
    __block BOOL res = NO;
    [jjDB.dbQueue inDatabase:^(FMDatabase *db) {
        NSString *tableName = NSStringFromClass(self.class);
        NSString *sql = [NSString stringWithFormat:@"DELETE FROM %@ %@ ",tableName,criteria];
        res = [db executeUpdate:sql];
        DLog(res?@"删除成功":@"删除失败");
    }];
    return res;
}
/** 删除单个对象(你能拿到对象地址，你就能删除对象在数据库中的数据) */
/*【分析】：凭什么删除数据库中的数据？通过条件语句来删除，比如主键where key < 10;
 那么拿到对象地址，怎么保证能拿到对象数据在数据库中对应的主键值？创建对象时，给主键赋值。这个不行吧？
 */

//- (BOOL)deleteObject
//{
//    JJFMDBManager *jjDB = [JJFMDBManager sharedManager];
//    __block BOOL res = NO;
//    [jjDB.dbQueue inDatabase:^(FMDatabase *db) {
//        NSString *tableName = NSStringFromClass(self.class);
//        id primaryValue = [self valueForKey:primaryId];
//        if (!primaryValue || primaryValue <= 0) {
//            return ;
//        }
//        NSString *sql = [NSString stringWithFormat:@"DELETE FROM %@ WHERE %@ = ?",tableName,primaryId];
//        res = [db executeUpdate:sql withArgumentsInArray:@[primaryValue]];
//        DLog(res?@"删除成功":@"删除失败");
//    }];
//    return res;
//}
#pragma mark - 更新数据
/** 条件更新数据(这里的条件暂时以主键为条件，因为创建模型对象时，会给主键主动赋一个值) */
//【需要的资源】：@"UPDATE %@ SET %@ WHERE %@ = ?;", tableName（表名）, keyString（属性名）([@" %@=?,", proname]?是占位符，每个没有赋值的字段都必须放一个占位符), primaryId（条件）；
//             [db executeUpdate:sql withArgumentsInArray:updateValues（数组中存储的是所有属性的值）];
- (BOOL)update
{
    JJFMDBManager *jjDB = [JJFMDBManager sharedManager];
    __block BOOL res = NO;
    [jjDB.dbQueue inDatabase:^(FMDatabase *db) {
        NSString *tableName = NSStringFromClass(self.class);
        id primaryValue = [self valueForKey:primaryId];
        if (!primaryValue || primaryValue <= 0) {
            return ;
        }
        NSMutableString *keyString = [NSMutableString string];
        NSMutableArray *updateValues = [NSMutableArray  array];
        for (int i = 0; i < self.columeNames.count; i++) {
            NSString *proname = [self.columeNames objectAtIndex:i];
            if ([proname isEqualToString:primaryId]) {
                continue;
            }
            [keyString appendFormat:@" %@=?,", proname];
            id value = [self valueForKey:proname];
            if (!value) {
                value = @"";
            }
            [updateValues addObject:value];
        }
        
        //删除最后那个逗号
        [keyString deleteCharactersInRange:NSMakeRange(keyString.length - 1, 1)];
        NSString *sql = [NSString stringWithFormat:@"UPDATE %@ SET %@ WHERE %@ = ?;", tableName, keyString, primaryId];
        [updateValues addObject:primaryValue];
        res = [db executeUpdate:sql withArgumentsInArray:updateValues];
        DLog(res?@"更新成功":@"更新失败");
        if (res) {
            [JJToastView showMessage:@"更新成功"];
        }
        else {
            [JJToastView showMessage:@"更新失败"];
        }
        
    }];
    return res;
}
/** 批量更新用户对象*/
/*批量更新数据的关键是什么？关键就是数组中的模型对象怎么与数据库的数据对应起来？靠主键*/
+ (BOOL)updateObjects:(NSArray *)array
{
    //如果数组中的模型对象不是JJFMDBModel的子类，那么不好意思，处理不了
    for (JJFMDBModel *model in array) {
        if (![model isKindOfClass:[JJFMDBModel class]]) {
            return NO;
        }
    }
    __block BOOL res = YES;
    JJFMDBManager *jjDB = [JJFMDBManager sharedManager];
    // 如果要支持事务
    [jjDB.dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        for (JJFMDBModel *model in array) {
            //拿到表名，模型类不同，表名也不同NSStringFromClass(model.class)
            NSString *tableName = NSStringFromClass(model.class);
            id primaryValue = [model valueForKey:primaryId];
            if (!primaryValue || primaryValue <= 0) {
                res = NO;
                *rollback = YES;
                return;
            }
            
            NSMutableString *keyString = [NSMutableString string];
            NSMutableArray *updateValues = [NSMutableArray  array];
            for (int i = 0; i < model.columeNames.count; i++) {
                NSString *proname = [model.columeNames objectAtIndex:i];
                if ([proname isEqualToString:primaryId]) {
                    continue;
                }
                [keyString appendFormat:@" %@=?,", proname];
                id value = [model valueForKey:proname];
                if (!value) {
                    value = @"";
                }
                [updateValues addObject:value];
            }
            
            //删除最后那个逗号
            [keyString deleteCharactersInRange:NSMakeRange(keyString.length - 1, 1)];
            NSString *sql = [NSString stringWithFormat:@"UPDATE %@ SET %@ WHERE %@=?;", tableName, keyString, primaryId];
            [updateValues addObject:primaryValue];
            BOOL flag = [db executeUpdate:sql withArgumentsInArray:updateValues];
            DLog(flag?@"更新成功":@"更新失败");
            if (!flag) {
                res = NO;
                *rollback = YES;
                return;
            }
            if (flag) {
                [JJToastView showMessage:@"更新成功"];
            }
            else {
                [JJToastView showMessage:@"更新失败"];
            }
        }
    }];
    
    return res;
}

/** 查找某条数据 */
+ (instancetype)findFirstByCriteria:(NSString *)criteria
{
    NSArray *results = [self.class findByCriteria:criteria];
    if (results.count < 1) {
        return nil;
    }
    
    return [results firstObject];
}
/** 通过条件查找数据 */
//我准备用sqlite的什么语法来查询数据？@"SELECT * FROM %@ %@",tableName,criteria;
//这个方案我目前缺什么数据？怎么解决？表名，查询条件;
+ (NSMutableArray *)findByCriteria:(NSString *)criteria
{
    JJFMDBManager *jjDB = [JJFMDBManager sharedManager];
    NSMutableArray *users = [NSMutableArray array];
    [jjDB.dbQueue inDatabase:^(FMDatabase *db) {
        //拿到表名,查询条件就是参数criteria
        NSString *tableName = NSStringFromClass(self.class);
        NSString *sql = [NSString stringWithFormat:@"SELECT * FROM %@ %@",tableName,criteria];
        FMResultSet *resultSet = [db executeQuery:sql];
        //从数据库中查询出来的数据有2种：字符串，整形，我必须对这2种数据区分处理
        while ([resultSet next]) {
            JJFMDBModel *model = [[self.class alloc] init];
            for (int i=0; i< model.columeNames.count; i++) {
                NSString *columeName = [model.columeNames objectAtIndex:i];
                NSString *columeType = [model.columeTypes objectAtIndex:i];
                if ([columeType isEqualToString:SQLTEXT]) {
                    [model setValue:[resultSet stringForColumn:columeName] forKey:columeName];
                } else {
                    [model setValue:[NSNumber numberWithLongLong:[resultSet longLongIntForColumn:columeName]] forKey:columeName];
                }
            }
            [users addObject:model];
            FMDBRelease(model);
        }
    }];
    
    return users;
}
/** 查询全部数据 */
//@"SELECT * FROM %@",tableName      有个表名就完事了
//查询结果先赋值给模型，再用一个数组装起来
+ (NSMutableArray *)findAll
{
    JJFMDBManager *jjDB = [JJFMDBManager sharedManager];
    NSMutableArray *users = [NSMutableArray array];
    
    [jjDB.dbQueue inDatabase:^(FMDatabase *db) {
        
        NSString *tableName = NSStringFromClass(self.class);
        NSString *sql = [NSString stringWithFormat:@"SELECT * FROM %@",tableName];
        FMResultSet *resultSet = [db executeQuery:sql];
        while ([resultSet next]) {
            JJFMDBModel *model = [[self.class alloc] init];
            for (int i=0; i< model.columeNames.count; i++) {
                NSString *columeName = [model.columeNames objectAtIndex:i];
                NSString *columeType = [model.columeTypes objectAtIndex:i];
                if ([columeType isEqualToString:SQLTEXT]) {
                    [model setValue:[resultSet stringForColumn:columeName] forKey:columeName];
                } else {
                    [model setValue:[NSNumber numberWithLongLong:[resultSet longLongIntForColumn:columeName]] forKey:columeName];
                }
            }
            [users addObject:model];
            FMDBRelease(model);
        }
    }];
    
    return users;
}
- (NSString *)description
{
    NSString *result = @"";
    NSDictionary *dict = [self.class getAllProperties];
    NSMutableArray *proNames = [dict objectForKey:@"name"];
    for (int i = 0; i < proNames.count; i++) {
        NSString *proName = [proNames objectAtIndex:i];
        id  proValue = [self valueForKey:proName];
        result = [result stringByAppendingFormat:@"%@:%@\n",proName,proValue];
    }
    return result;
}
/** 数据库中是否存在表 */
+ (BOOL)isExistInTable
{
    __block BOOL res = NO;
    JJFMDBManager *jjDB = [JJFMDBManager sharedManager];
    [jjDB.dbQueue inDatabase:^(FMDatabase *db) {
        NSString *tableName = NSStringFromClass(self.class);
        res = [db tableExists:tableName];
    }];
    return res;
}
//取出数据库中，指定表名的所有字段名称
+ (NSMutableArray *)getColumns
{
    JJFMDBManager *jjDB = [JJFMDBManager sharedManager];
    NSMutableArray *columns = [NSMutableArray array];
    [jjDB.dbQueue inDatabase:^(FMDatabase *db) {
        NSString *tableName = NSStringFromClass(self.class);
        FMResultSet *resultSet = [db getTableSchema:tableName];
        while ([resultSet next]) {
            NSString *column = [resultSet stringForColumn:@"name"];
            [columns addObject:column];
        }
    }];
    return [columns copy];
}
/** 清空表 */
+ (BOOL)clearTable
{
    JJFMDBManager *jjDB = [JJFMDBManager sharedManager];
    __block BOOL res = NO;
    [jjDB.dbQueue inDatabase:^(FMDatabase *db) {
        NSString *tableName = NSStringFromClass(self.class);
        NSString *sql = [NSString stringWithFormat:@"DELETE FROM %@",tableName];
        res = [db executeUpdate:sql];
        DLog(res?@"清空成功":@"清空失败");
        if (res) {
            [JJToastView showMessage:@"删除成功"];
        }
        else {
            [JJToastView showMessage:@"删除失败"];
        }
    }];
    return res;
}




@end
