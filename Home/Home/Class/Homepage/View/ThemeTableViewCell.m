//
//  ThemeTableViewCell.m
//  Home
//
//  Created by scjy on 16/3/3.
//  Copyright © 2016年 scjy. All rights reserved.
//

#import "ThemeTableViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "AppDelegate.h"
#import <BmobSDK/Bmob.h>
#import "ProgressHUD.h"
#import "DataBaseManager.h"
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
    self.likeBtn.backgroundColor = [UIColor blackColor];
    self.likeBtn.alpha = 0.8;
    self.likeBtn.layer.cornerRadius = 6;
    self.likeBtn.clipsToBounds = YES;
        [self.likeBtn setImage:[UIImage imageNamed:@"collect"] forState:UIControlStateNormal];
    self.likeBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, self.likeBtn.frame.size.width * 2 / 3);
      [self.likeBtn setTitle:[NSString stringWithFormat:@"%@", model.like_count] forState:UIControlStateNormal];
    self.likeBtn.titleEdgeInsets = UIEdgeInsetsMake(0, -self.likeBtn.frame.size.width * 1 / 3, 0, 0);
    self.likeBtn.titleLabel.font = [UIFont systemFontOfSize:14.0];
    self.likeBtn.titleLabel.textColor = [UIColor whiteColor];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
