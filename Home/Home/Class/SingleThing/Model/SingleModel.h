//
//  SingleModel.h
//  Home
//
//  Created by scjy on 16/3/4.
//  Copyright © 2016年 scjy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SingleModel : NSObject
@property (nonatomic, strong) NSString *imageStr;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *price;
@property (nonatomic, strong) NSString *like_counts;
- (instancetype)initWithDictionary:(NSDictionary *)dic;



@end
