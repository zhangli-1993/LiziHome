//
//  EveryUpdateModel.m
//  Home
//
//  Created by scjy on 16/3/4.
//  Copyright © 2016年 scjy. All rights reserved.
//

#import "EveryUpdateModel.h"

@implementation EveryUpdateModel
- (instancetype)initWithDictionary:(NSDictionary *)dic{
    self = [super init];
    if (self) {
        self.image = dic[@"cover_image_url"];
        self.like_count = dic[@"likes_count"];
        self.title = dic[@"title"];
        self.idStr = dic[@"id"];
    }
    return self;
}
@end
