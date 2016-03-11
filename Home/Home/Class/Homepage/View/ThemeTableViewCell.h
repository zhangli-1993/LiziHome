//
//  ThemeTableViewCell.h
//  Home
//
//  Created by scjy on 16/3/3.
//  Copyright © 2016年 scjy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EveryUpdateModel.h"
@interface ThemeTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *likeBtn;
@property (nonatomic, strong) EveryUpdateModel *model;
- (void)likeList:(UIButton *)btn :(EveryUpdateModel *)model;
@end
