//
//  Collect.m
//  Home
//
//  Created by scjy on 16/3/10.
//  Copyright © 2016年 scjy. All rights reserved.
//

#import "Collect.h"

@implementation Collect
- (instancetype)initWithDic:(NSDictionary *)dic withNum:(NSInteger)num{
    self = [super init];
    if (self) {
        self.dic = dic;
        self.num = num;
    }
    return self;
}
@end
