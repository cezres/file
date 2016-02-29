//
//  NSObject+SwizzleMethod.h
//  buyer
//
//  Created by 云之彼端 on 16/1/7.
//  Copyright © 2016年 云之彼端. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (SwizzleMethod)

+ (void)swizzleMethod:(SEL)originalSelector swizzledSelector:(SEL)swizzledSelector;

@end
