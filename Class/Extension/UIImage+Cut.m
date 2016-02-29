//
//  UIImage+Cut.m
//  buyer
//
//  Created by 翟泉 on 16/2/23.
//  Copyright © 2016年 云之彼端. All rights reserved.
//

#import "UIImage+Cut.h"

@implementation UIImage (Cut)

- (UIImage *)cutImageWithSquare; {
    CGRect rect;
    if (self.size.width > self.size.height) {
        rect = CGRectMake((self.size.width - self.size.height) / 2, 0, self.size.height, self.size.height);
    }
    else if (self.size.width < self.size.height) {
        rect = CGRectMake(0, (self.size.height - self.size.width) / 2, self.size.width, self.size.width);
    }
    else {
        return self;
    }
    CGImageRef imageRef = CGImageCreateWithImageInRect(self.CGImage, rect);
//    CGRect small = CGRectMake(0, 0, CGImageGetWidth(imageRef), CGImageGetHeight(imageRef));
//    UIGraphicsBeginImageContext(small.size);
    UIImage *image = [UIImage imageWithCGImage:imageRef];
//    UIGraphicsEndImageContext();
    
    CGImageRelease(imageRef);
    
    return image;
}


- (UIImage *)cutImageWithSquare:(CGSize)size; {
    CGRect rect;
    if (self.size.width > self.size.height) {
        rect = CGRectMake((self.size.width - self.size.height) / 2, 0, self.size.height, self.size.height);
    }
    else if (self.size.width < self.size.height) {
        rect = CGRectMake(0, (self.size.height - self.size.width) / 2, self.size.width, self.size.width);
    }
    else {
        return self;
    }
    CGImageRef imageRef = CGImageCreateWithImageInRect(self.CGImage, rect);
    CGRect small = CGRectMake(0, 0, CGImageGetWidth(imageRef), CGImageGetHeight(imageRef));
    UIGraphicsBeginImageContext(small.size);
    UIImage *image = [UIImage imageWithCGImage:imageRef];
    UIGraphicsEndImageContext();
    
    return image;
}

@end
