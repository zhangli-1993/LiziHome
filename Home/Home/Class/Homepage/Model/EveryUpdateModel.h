//
//  EveryUpdateModel.h
//  Home
//
//  Created by scjy on 16/3/4.
//  Copyright © 2016年 scjy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EveryUpdateModel : NSObject
@property (nonatomic, strong) NSString *image;
@property (nonatomic, strong) NSString *like_count;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *idStr;

- (instancetype)initWithDictionary:(NSDictionary *)dic;
@end
