//
//  ClassifyModel.h
//  Home
//
//  Created by scjy on 16/3/5.
//  Copyright © 2016年 scjy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ClassifyModel : NSObject
@property (nonatomic, strong) NSString *image;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *idStr;
- (instancetype)initWithDictionary:(NSDictionary *)dic;
@end
