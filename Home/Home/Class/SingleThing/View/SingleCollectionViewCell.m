//
//  SingleCollectionViewCell.m
//  Home
//
//  Created by scjy on 16/3/4.
//  Copyright © 2016年 scjy. All rights reserved.
//

#import "SingleCollectionViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
@interface SingleCollectionViewCell ()
@property (nonatomic, strong) UIImageView *imageview;
@property (nonatomic, strong) UILabel *name;
@property (nonatomic, strong) UILabel *price;
@property (nonatomic, strong) UILabel *like;
@end
@implementation SingleCollectionViewCell
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self configView];
    }
    return self;
}
- (void)configView{
    UIImageView *heart = [[UIImageView alloc] initWithFrame:CGRectMake((kWidth - 15) / 2 - 76, (kWidth - 15) / 2 + (kWidth - 8) / 15 + 13, 15, 15)];
    heart.image = [UIImage imageNamed:@"like"];
    [self addSubview:heart];
    
    [self addSubview:self.imageview];
    
    [self addSubview:self.name];
    [self addSubview:self.price];
    [self addSubview:self.like];
}
- (void)setModel:(SingleModel *)model{
    [self.imageview sd_setImageWithURL:[NSURL URLWithString:model.imageStr]];
    self.name.text = model.name;
    self.price.text = model.price;
    
    self.like.text = model.like_counts;
}
- (UIImageView *)imageview{
    if (_imageview == nil) {
        self.imageview = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, (kWidth - 15) / 2, (kWidth - 15) / 2)];
 
    }
    return _imageview;
}
- (UILabel *)name{
    if (_name == nil) {
        self.name = [[UILabel alloc] initWithFrame:CGRectMake(5, (kWidth - 15) / 2, (kWidth - 15) / 2 - 10, (kWidth - 15) / 10)];
        self.name.numberOfLines = 0;
        self.name.font = [UIFont systemFontOfSize:15.0];
    }
    return _name;
}
- (UILabel *)price{
    if (_price == nil) {
        self.price = [[UILabel alloc] initWithFrame:CGRectMake(5, (kWidth - 15) / 2 + (kWidth - 15) / 15, 60 , 40)];
        self.price.textColor = kColor;
        
    }
    return _price;
}
- (UILabel *)like{
    if (_like == nil) {
        self.like = [[UILabel alloc] initWithFrame:CGRectMake((kWidth - 15) / 2 - 60, (kWidth - 15) / 2 + (kWidth - 8) / 15, 60, 40)];
        self.like.font = [UIFont systemFontOfSize:12.0];
        self.like.textColor = [UIColor grayColor];
    }
    return _like;
}

@end
