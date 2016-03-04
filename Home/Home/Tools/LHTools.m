//
//  LHTools.m
//  Home
//
//  Created by scjy on 16/3/4.
//  Copyright © 2016年 scjy. All rights reserved.
//

#import "LHTools.h"

@implementation LHTools
+ (NSString *)getDataFromString:(NSString *)timeTamp{
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[timeTamp doubleValue]];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy.MM.dd"];
     NSString *nowTimeStr = [formatter stringFromDate:date];
    return nowTimeStr;
    
    
}

+ (NSDate *)getSystemNowDate{
    NSDateFormatter *df = [[NSDateFormatter alloc] init ];
    df.dateFormat = @"yyyy-MM-dd HH:mm";
    NSString *dateStr = [df stringFromDate:[NSDate date]];
    NSDate *date = [df dateFromString:dateStr];
    return date;
}



+ (CGFloat)getLableTextHeight:(NSString *)text bigestSize:(CGSize)bigestSize textFont:(CGFloat)font{
    CGFloat textHeight;
    CGRect textRect = [text boundingRectWithSize:bigestSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:font]} context:nil];
    return textRect.size.height;
    return textHeight;
}



@end
