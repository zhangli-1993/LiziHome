//
//  DataBaseManager.h
//  Home
//
//  Created by scjy on 16/3/9.
//  Copyright © 2016年 scjy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EveryUpdateModel.h"
@interface DataBaseManager : NSObject
@property (nonatomic, copy) NSString *name;
+ (DataBaseManager *)sharedInstance;
#pragma mark--数据库基础操作
//创建数据库
- (void)createDataBase;
//打开数据库
- (void)openDataBase;
//创建数据库表
- (void)createDataBaseTable;
//关闭数据库
- (void)closeDataBase;
- (void)insertIntoCollect:(NSDictionary *)dic withNumber:(NSInteger)num;
- (void)deleteWithNum:(NSInteger)num;
- (NSMutableArray *)selectAllCollect;
- (NSMutableArray *)selectAllCollectWithNum:(NSInteger)num;
@end
