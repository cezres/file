//
//  ESFileListTableViewCell.m
//  file
//
//  Created by 翟泉 on 16/2/27.
//  Copyright © 2016年 云之彼端. All rights reserved.
//

#import "ESFileListTableViewCell.h"

@interface ESFileListTableViewCell ()



@end

@implementation ESFileListTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setMode:(ESFileModel *)model; {
    self.nameLabel.text = model.name;
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSString *destDateString = [dateFormatter stringFromDate:model.creationDate];
    
    self.desLabel.text = [NSString stringWithFormat:@"%@", destDateString];
    
    if (model.type == ESFileTypeDirectory) {
        self.iconView.image = [UIImage imageNamed:@"Directory"];
    }
    else if (model.type == ESFileTypePhoto) {
//        UIImage *image = [[UIImage imageWithContentsOfFile:model.path] cutImageWithSquare];
        UIImage *image = [UIImage thumbnailWithFilePath:model.path];
        self.iconView.image = image;//[UIImage imageWithContentsOfFile:model.path];
    }
    else if (model.type == ESFileTypeVideo) {
        self.iconView.image = [UIImage imageNamed:@"Video"];
    }
    else if (model.type == ESFileTypeAudio) {
        self.iconView.image = [UIImage imageNamed:@"Audio"];
    }
    else if (model.type == ESFileTypeUnknown) {
        self.iconView.image = [UIImage imageNamed:@"Unknown"];
    }
    else {
        self.iconView.image = nil;
    }
    
//    self.editingAccessoryType = UITableViewCellAccessoryCheckmark;
}


- (void)setEditing:(BOOL)editing animated:(BOOL)animated; {
//    [super setEditing:editing animated:animated];
//    NSLog(@"%s", __FUNCTION__);
    
    if (editing) {
        if (animated) {
            [UIView animateWithDuration:0.3 animations:^{
                self.selectImageView.transform = CGAffineTransformTranslate(self.selectImageView.transform, 10-self.selectImageView.x, 0);
                self.iconView.transform = CGAffineTransformTranslate(self.iconView.transform, 52-self.iconView.x, 0);
                self.nameLabel.transform = CGAffineTransformTranslate(self.nameLabel.transform, 92-self.nameLabel.x, 0);
                self.desLabel.transform = CGAffineTransformTranslate(self.desLabel.transform, 92-self.desLabel.x, 0);
            }];
        }
        else {
            self.selectImageView.transform = CGAffineTransformTranslate(self.selectImageView.transform, 10-self.selectImageView.x, 0);
            self.iconView.transform = CGAffineTransformTranslate(self.iconView.transform, 52-self.iconView.x, 0);
            self.nameLabel.transform = CGAffineTransformTranslate(self.nameLabel.transform, 92-self.nameLabel.x, 0);
            self.desLabel.transform = CGAffineTransformTranslate(self.desLabel.transform, 92-self.desLabel.x, 0);
        }
    }
    else {
        self.selectImageView.image = [UIImage imageNamed:@"icon-checkbox-n"];
        if (animated) {
            [UIView animateWithDuration:0.3 animations:^{
                self.selectImageView.transform = CGAffineTransformTranslate(self.selectImageView.transform, -32-self.selectImageView.x, 0);
                self.iconView.transform = CGAffineTransformTranslate(self.iconView.transform, 10-self.iconView.x, 0);
                self.nameLabel.transform = CGAffineTransformTranslate(self.nameLabel.transform, 50-self.nameLabel.x, 0);
                self.desLabel.transform = CGAffineTransformTranslate(self.desLabel.transform, 50-self.desLabel.x, 0);
            }];
        }
        else {
            self.selectImageView.transform = CGAffineTransformTranslate(self.selectImageView.transform, -32-self.selectImageView.x, 0);
            self.iconView.transform = CGAffineTransformTranslate(self.iconView.transform, 10-self.iconView.x, 0);
            self.nameLabel.transform = CGAffineTransformTranslate(self.nameLabel.transform, 50-self.nameLabel.x, 0);
            self.desLabel.transform = CGAffineTransformTranslate(self.desLabel.transform, 50-self.desLabel.x, 0);
        }
    }
}
- (void)willTransitionToState:(UITableViewCellStateMask)state; {
//    [super willTransitionToState:state];
//    NSLog(@"%ld", state);
    NSLog(@"%s", __FUNCTION__);
}
- (void)didTransitionToState:(UITableViewCellStateMask)state; {
//    NSLog(@"%ld", state);
    NSLog(@"%s", __FUNCTION__);
}

#pragma mark - Lazy
- (UIImageView *)iconView; {
    if (_iconView == NULL) {
        _iconView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 5, 30, 30)];
        [self addSubview:_iconView];
    }
    return _iconView;
}
- (UILabel *)nameLabel; {
    if (_nameLabel == NULL) {
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 4, SSize.width-self.iconView.maxX-10-10, 16)];
        _nameLabel.font = F13;
        [self addSubview:_nameLabel];
    }
    return _nameLabel;
}
- (UILabel *)desLabel; {
    if (_desLabel == NULL) {
        _desLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 20, SSize.width-self.iconView.maxX-10-10, 16)];
        _desLabel.textColor = ColorRGB(146, 146, 146);
        _desLabel.font = F12;
        [self addSubview:_desLabel];
    }
    return _desLabel;
}

- (UIImageView *)selectImageView; {
    if (_selectImageView == NULL) {
        _selectImageView = [[UIImageView alloc] init];
        _selectImageView.image = [UIImage imageNamed:@"icon-checkbox-n"];
        _selectImageView.frame = CGRectMake(-32, (self.height-32)/2, 32, 32);
        [self addSubview:_selectImageView];
        
        if ([self respondsToSelector:@selector(setLayoutMargins:)]) {
            [self setLayoutMargins:UIEdgeInsetsZero];
        }
    }
    return _selectImageView;
}

@end
