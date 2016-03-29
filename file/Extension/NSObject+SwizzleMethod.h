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

- (void)essssss:(NSString *)ss, ... NS_REQUIRES_NIL_TERMINATION;

//- (NSString *)rac_liftSelector:(SEL)selector withObjects:(id)arg, ... __attribute__((unavailable("Use -rac_liftSelector:withSignals: instead")));

@end
