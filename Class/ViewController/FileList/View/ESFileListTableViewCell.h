//
//  ESFileListTableViewCell.h
//  file
//
//  Created by 翟泉 on 16/2/27.
//  Copyright © 2016年 云之彼端. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ESFileModel.h"

@protocol ESTableViewCellEditDelegate <NSObject>

- (void)tableViewCell:(UITableViewCell *)cell;

@end

@interface ESFileListTableViewCell : UITableViewCell


@property (strong, nonatomic) UIImageView   *iconView;
@property (strong, nonatomic) UILabel       *nameLabel;
@property (strong, nonatomic) UILabel       *desLabel;

@property (strong, nonatomic) UIButton      *selectButton;

- (void)setMode:(ESFileModel *)model;

@end
