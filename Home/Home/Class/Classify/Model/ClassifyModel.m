//
//  ClassifyModel.m
//  Home
//
//  Created by scjy on 16/3/5.
//  Copyright © 2016年 scjy. All rights reserved.
//

#import "ClassifyModel.h"

@implementation ClassifyModel
- (instancetype)initWithDictionary:(NSDictionary *)dic{
    self = [super init];
    if (self) {
        self.image = dic[@"icon_url"];
        self.name = dic[@"name"];
        self.idStr = dic[@"id"];
    }
    return self;
}
@end
