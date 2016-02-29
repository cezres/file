//
//  UIView+Frame.m
//  buyer
//
//  Created by 云之彼端 on 15/11/30.
//  Copyright © 2015年 云之彼端. All rights reserved.
//

#import "UIView+Frame.h"

@implementation UIView (Frame)

- (CGFloat)x; {
    return self.origin.x;
}
- (void)setX:(CGFloat)x; {
    self.origin = CGPointMake(x, self.y);
}
- (CGFloat)y; {
    return self.origin.y;
}
- (void)setY:(CGFloat)y; {
    self.origin = CGPointMake(self.x, y);
}
- (CGFloat)width; {
    return self.size.width;
}
- (void)setWidth:(CGFloat)width; {
    self.size = CGSizeMake(width, self.height);
}
- (CGFloat)height; {
    return self.size.height;
}
- (void)setHeight:(CGFloat)height; {
    self.size = CGSizeMake(self.width, height);
}
- (CGSize)size; {
    return self.frame.size;
}
- (void)setSize:(CGSize)size; {
    self.frame = CGRectMake(self.x, self.y, size.width, size.height);
}
- (CGPoint)origin; {
    return self.frame.origin;
}
- (void)setOrigin:(CGPoint)origin; {
    self.frame = CGRectMake(origin.x, origin.y, self.width, self.height);
}
- (CGFloat)maxX; {
    return self.x + self.width;
}
- (void)setMaxX:(CGFloat)maxX; {
    self.x = maxX - self.width;
}
- (CGFloat)maxY; {
    return self.y + self.height;
}
- (void)setMaxY:(CGFloat)maxY; {
    self.y = maxY - self.height;
}
- (void)setCenterX:(CGFloat)centerX
{
    CGPoint center = self.center;
    center.x = centerX;
    self.center = center;
}
- (CGFloat)centerX; {
    return self.center.x;
}

- (void)setCenterY:(CGFloat)centerY
{
    CGPoint center = self.center;
    center.y = centerY;
    self.center = center;
}
- (CGFloat)centerY; {
    return self.center.y;
}
@end
