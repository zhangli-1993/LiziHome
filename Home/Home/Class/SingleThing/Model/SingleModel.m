//
//  SingleModel.m
//  Home
//
//  Created by scjy on 16/3/4.
//  Copyright © 2016年 scjy. All rights reserved.
//

#import "SingleModel.h"

@implementation SingleModel
- (instancetype)initWithDictionary:(NSDictionary *)dic{
    self = [super init];
    if (self) {
        self.imageStr = dic[@"cover_image_url"];
        self.name = dic[@"name"];
        self.price = dic[@"price"];
        self.like_counts = dic[@"favorites_count"];
    }
    return self;
}
@end
