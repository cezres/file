//
//  UIView+Frame.h
//  buyer
//
//  Created by 云之彼端 on 15/11/30.
//  Copyright © 2015年 云之彼端. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  便捷获取、设置视图位置相关属性
 */
@interface UIView (Frame)

@property(assign, nonatomic) CGFloat    x;
@property(assign, nonatomic) CGFloat    y;
@property(assign, nonatomic) CGFloat    width;
@property(assign, nonatomic) CGFloat    height;
@property(assign, nonatomic) CGSize     size;
@property(assign, nonatomic) CGPoint    origin;
@property(assign, nonatomic) CGFloat    maxX;
@property(assign, nonatomic) CGFloat    maxY;
@property (nonatomic, assign) CGFloat centerX;
@property (nonatomic, assign) CGFloat centerY;
@end
