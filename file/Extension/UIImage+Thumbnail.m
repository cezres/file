//
//  UIImage+Thumbnail.m
//  file
//
//  Created by 翟泉 on 16/2/29.
//  Copyright © 2016年 云之彼端. All rights reserved.
//

#import "UIImage+Thumbnail.h"
#import "NSString+MD5.h"
#import "UIImage+Cut.h"

@implementation UIImage (Thumbnail)

+ (UIImage *)thumbnailWithFile:(ESFileModel *)file; {
    NSString *cacheDirectoryPath = [NSString stringWithFormat:@"%@/Thumbnail", [ESFileManager sharedInstance].CachesPath];
    NSString *cachePath = [cacheDirectoryPath stringByAppendingFormat:@"/%@", [NSString stringWithFormat:@"%ld", file.fileNumber].MD5];
    UIImage *thumbnail = [UIImage imageWithContentsOfFile:cachePath];
    if (!thumbnail) {
        
        BOOL flag;
        NSFileManager *fileManager = [NSFileManager defaultManager];
        if (![fileManager fileExistsAtPath:cacheDirectoryPath isDirectory:&flag] || !flag) {
            [fileManager createDirectoryAtPath:cacheDirectoryPath withIntermediateDirectories:YES attributes:nil error:nil];
        }
        
        
        UIImage *image = [[UIImage imageWithContentsOfFile:file.path] cutImageWithSquare];
        
        //
        CGSize size = CGSizeMake(90, 90);
        UIGraphicsBeginImageContext(size);
        [image drawInRect:CGRectMake(0,0,size.width,size.height)];
        thumbnail = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        NSData *data = UIImagePNGRepresentation(thumbnail);
        
        
//        CGFloat compressionQuality = 90 / image.size.width;
//        NSData *data = UIImageJPEGRepresentation(image, compressionQuality);
//        thumbnail = [UIImage imageWithData:data];
        
        [data writeToFile:cachePath atomically:YES];
    }
    return thumbnail;
}

@end
