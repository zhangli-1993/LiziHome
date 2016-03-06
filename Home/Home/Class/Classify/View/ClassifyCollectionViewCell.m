//
//  ClassifyCollectionViewCell.m
//  Home
//
//  Created by scjy on 16/3/5.
//  Copyright © 2016年 scjy. All rights reserved.
//

#import "ClassifyCollectionViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
@interface ClassifyCollectionViewCell ()
@property (nonatomic, strong) UIImageView *imageview;
@property (nonatomic, strong) UILabel *name;
@end
@implementation ClassifyCollectionViewCell
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self configView];
    }
    return self;
}
- (void)configView{
    [self addSubview:self.imageview];
    
    [self addSubview:self.name];
}
- (void)setModel:(ClassifyModel *)model{
    [self.imageview sd_setImageWithURL:[NSURL URLWithString:model.image]];
    self.name.text = model.name;
}
- (UIImageView *)imageview{
    if (_imageview == nil) {
        self.imageview = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, (kWidth - 50) / 4, (kWidth - 50) / 4)];
        self.imageview.layer.cornerRadius = (kWidth - 50) / 8;
        self.imageview.clipsToBounds = YES;

    }
    return _imageview;
}
- (UILabel *)name{
    if (_name == nil) {
        self.name = [[UILabel alloc] initWithFrame:CGRectMake(0, (kWidth - 50) / 4, (kWidth - 50) / 4, 40)];
        self.name.numberOfLines = 0;
        self.name.font = [UIFont systemFontOfSize:15.0];
        self.name.textColor = kColor;
        self.name.textAlignment = NSTextAlignmentCenter;
    }
    return _name;
}






@end
