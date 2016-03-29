//
//  NSObject+SwizzleMethod.m
//  buyer
//
//  Created by 云之彼端 on 16/1/7.
//  Copyright © 2016年 云之彼端. All rights reserved.
//

#import "NSObject+SwizzleMethod.h"
#import <objc/runtime.h>

@implementation NSObject (SwizzleMethod)

+ (void)swizzleMethod:(SEL)originalSelector swizzledSelector:(SEL)swizzledSelector;   {
    Method originalMethod = class_getInstanceMethod([self class], originalSelector);
    Method swizzledMethod = class_getInstanceMethod([self class], swizzledSelector);
    if (class_addMethod([self class],originalSelector,method_getImplementation(swizzledMethod),method_getTypeEncoding(swizzledMethod))) {
        class_replaceMethod([self class],swizzledSelector,method_getImplementation(originalMethod),method_getTypeEncoding(originalMethod));
    } else {
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
}


- (void)essssss:(NSString *)ss, ...; {
    
    va_list args;
    va_start(args, ss);
    for (id obj = ss; obj!=nil; obj = va_arg(args, id)) {
        NSLog(@"%@", obj);
    }
    va_end(args);
    
}

@end