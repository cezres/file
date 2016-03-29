//
//  UIImage+Thumbnail.h
//  file
//
//  Created by 翟泉 on 16/2/29.
//  Copyright © 2016年 云之彼端. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ESFileManager.h"

@interface UIImage (Thumbnail)

/**
 *  加载缩略图 【有缓存
 *
 *  @param path 图片路径
 *
 *  @return 图片缩略图
 */
+ (UIImage *)thumbnailWithFile:(ESFileModel *)file;

@end
