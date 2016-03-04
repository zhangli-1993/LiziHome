//
//  ThemeTableViewCell.m
//  Home
//
//  Created by scjy on 16/3/3.
//  Copyright © 2016年 scjy. All rights reserved.
//

#import "ThemeTableViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
@interface ThemeTableViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *imageview;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end
@implementation ThemeTableViewCell

- (void)awakeFromNib {
    // Initialization code
}
- (void)setModel:(EveryUpdateModel *)model{
    [self.imageview sd_setImageWithURL:[NSURL URLWithString:model.image]];
    self.imageview.layer.cornerRadius = 5;
    self.imageview.clipsToBounds = YES;
    self.titleLabel.text = model.title;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
