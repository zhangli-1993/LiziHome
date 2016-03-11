//
//  Collect.h
//  Home
//
//  Created by scjy on 16/3/10.
//  Copyright © 2016年 scjy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Collect : NSObject
@property (nonatomic, assign) NSInteger num;
@property (nonatomic, strong) NSDictionary *dic;
- (instancetype)initWithDic:(NSDictionary *)dic withNum:(NSInteger)num;
@end
