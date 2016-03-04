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
@property (weak, nonatomic) IBOutlet UIImageView *imageview;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLable;
@property (weak, nonatomic) IBOutlet UILabel *likeLable;


@end

@implementation SingleCollectionViewCell
- (void)setModel:(SingleModel *)model{
    [self.imageview sd_setImageWithURL:[NSURL URLWithString:model.imageStr]];
    self.nameLabel.text = model.name;
    self.priceLable.text = model.price;
    self.likeLable.text = model.like_counts;
    
}
- (void)awakeFromNib {
    // Initialization code
}

@end
