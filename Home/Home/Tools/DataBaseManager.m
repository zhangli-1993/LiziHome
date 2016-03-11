//
//  DataBaseManager.m
//  Home
//
//  Created by scjy on 16/3/9.
//  Copyright © 2016年 scjy. All rights reserved.
//

#import "DataBaseManager.h"
#import <sqlite3.h>
#import "Collect.h"
#import <BmobSDK/Bmob.h>
@interface DataBaseManager ()
{
    NSString *dataBasePath; //数据库创建路径
}
@end

@implementation DataBaseManager
static DataBaseManager *dbManager = nil;

+ (DataBaseManager *)sharedInstance{
    //如果为空，就去创建一个
    if (dbManager == nil) {
        dbManager = [[DataBaseManager alloc] init];
    }
    return dbManager;
}
static sqlite3 *dataBase = nil;

//创建数据库
- (void)createDataBase{
    NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    dataBasePath = [documentPath stringByAppendingPathComponent:@"/like.sqlite"];
    NSLog(@"%@", dataBasePath);
}
//打开数据库
- (void)openDataBase{
    if (dataBase != nil) {
        return;
    }
    [self createDataBase];
    int result = sqlite3_open([dataBasePath UTF8String], &dataBase);
    if (result == SQLITE_OK) {
        ZLLog(@"数据库打开成功");
        [self createDataBaseTable];
    } else {
        ZLLog(@"数据库打开失败失败");
    }
}
- (void)createDataBaseTable{
    //建表语句
    self.name = [BmobUser getCurrentUser].username;

    NSString *sql =[NSString stringWithFormat:@"create table a%@ (number integer , dic blob not null)", self.name];
    NSLog(@"%@", sql);
    //执行SQL语句
    /*
     第一个参数：数据库
     第二个参数：sql语句，UTF8String编码格式
     第三个参数：sqlites_callBack是函数回调，当这条语句执行完之后会调用你提供的函数，可以是NULL
     第四个参数：是你提供的指针变量，这个参数最终会传到你的回调函数中，也可以为NULL
     第五个参数：是错误信息，需要注意是指针类型，接收sqlite3执行的错误信息， 也可以为null
     */
    char *error = nil;
    sqlite3_exec(dataBase, [sql UTF8String], NULL, NULL, &error);
    
}



//关闭数据库
- (void)closeDataBase{
    int result = sqlite3_close(dataBase);
    if (result == SQLITE_OK) {
        NSLog(@"关闭成功");
        dataBase = nil;
    }else{
        NSLog(@"关闭失败");
    }
}


- (void)insertIntoCollect:(NSDictionary *)dic withNumber:(NSInteger)num{
    [self openDataBase];
    sqlite3_stmt *stmt = nil;
    NSLog(@"%@", self.name);
    self.name = [BmobUser getCurrentUser].username;
    NSData *dicData = [NSKeyedArchiver archivedDataWithRootObject:dic];
    NSString *sql =[NSString stringWithFormat:@"insert into a%@(number, dic) values(?, ?)", self.name];
    int result = sqlite3_prepare_v2(dataBase, [sql UTF8String], -1, &stmt, NULL);
    if (result == SQLITE_OK) {
        //sql语句没有问题---绑定数据(绑定的是上边sql语句中的？。也就是讲？替换为应该存储的值)
        //绑定？时，标记从1开始，不是0
        
        sqlite3_bind_int(stmt,1, num);
        sqlite3_bind_blob(stmt, 2, [dicData bytes], [dicData length], NULL);
        
        //执行
        sqlite3_step(stmt);
        
    }else{
        NSLog(@"sql语句有问题");
    }
    //删除释放掉
    sqlite3_finalize(stmt);
    
}



- (void)deleteWithNum:(NSInteger)num{
    [self openDataBase];
    self.name = [BmobUser getCurrentUser].username;

    //创建一个存储sql语句的变量
    sqlite3_stmt *stmt = nil;
    NSString *sql = [NSString stringWithFormat:@"delete from a%@ where number = ?", self.name];
    //验证sql语句
    int result = sqlite3_prepare_v2(dataBase, [sql UTF8String], -1, &stmt, NULL);
    if (result == SQLITE_OK) {
        //绑定name的值
        
        sqlite3_bind_int(stmt, 1, num);
        sqlite3_step(stmt);
        
        NSLog(@"删除成功");
    } else {
        NSLog(@"删除失败");
    }
    //释放
    sqlite3_finalize(stmt);
    
    
}
- (NSMutableArray *)selectAllCollect{
    [self openDataBase];
    self.name = [BmobUser getCurrentUser].username;

    sqlite3_stmt *stmt = nil;
    NSString *sql = [NSString stringWithFormat:@"select *from a%@", self.name];
    int result = sqlite3_prepare_v2(dataBase, [sql UTF8String], -1, &stmt, NULL);
    NSMutableArray *array = nil;
    if (result == SQLITE_OK) {
        array = [NSMutableArray new];
        while (sqlite3_step(stmt) == SQLITE_ROW) {
            const void *value = sqlite3_column_blob(stmt, 1);
            int bytes = sqlite3_column_bytes(stmt, 1);
            NSData *data = [NSData dataWithBytes:value length:bytes];
            NSDictionary *dic = [NSKeyedUnarchiver unarchiveObjectWithData:data];
            NSInteger num = (NSInteger)sqlite3_column_int64(stmt, 0);
            Collect *collect = [[Collect alloc]initWithDic:dic withNum:num];
            [array addObject:collect];
        }
    }
    else{
        NSLog(@"获取失败");
        array = [NSMutableArray new];
    }
    sqlite3_finalize(stmt);
    return array;
    
    
}
- (NSMutableArray *)selectAllCollectWithNum:(NSInteger)num{
    [self openDataBase];
    self.name = [BmobUser getCurrentUser].username;

    sqlite3_stmt *stmt = nil;
    NSString *sql =[NSString stringWithFormat:@"select * from a%@ where number = ?", self.name];
    int result = sqlite3_prepare_v2(dataBase, [sql UTF8String], -1, &stmt, NULL);
    NSMutableArray *array = [NSMutableArray new];
    if (result == SQLITE_OK) {
        
        sqlite3_bind_int(stmt, 1, num);
        while (sqlite3_step(stmt) == SQLITE_ROW){
            const void *value = sqlite3_column_blob(stmt, 1);
            int bytes = sqlite3_column_bytes(stmt, 1);
            NSData *data = [NSData dataWithBytes:value length:bytes];
            NSDictionary *dic = [NSKeyedUnarchiver unarchiveObjectWithData:data];
            
            
            [array addObject:dic];
            
        }
    }
    else{
        NSLog(@"获取失败");
        
    }
    sqlite3_finalize(stmt);
    NSLog(@"%@", array);
    return array;
    
}

@end
