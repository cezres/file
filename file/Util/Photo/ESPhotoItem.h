//
//  ESPhotoItem.h
//  file
//
//  Created by 翟泉 on 16/3/7.
//  Copyright © 2016年 云之彼端. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ESPhotoItem : UIView

@property (strong, nonatomic) UIImage *image;
@property (strong, nonatomic) UIImage *placeholderImage;

- (void)loadImageWithURL:(NSURL *)url;

@end
